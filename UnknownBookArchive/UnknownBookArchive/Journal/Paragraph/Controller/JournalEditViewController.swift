// MARK: - 저널 '문단 수집' 추가/편집 페이지

import Foundation
import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class JournalEditViewController: UIViewController, UIGestureRecognizerDelegate {
    private let journalEditView = JournalEditView()
    private let viewModel: JournalEditViewModel
    private let book: Book
    private let journalType: String
    private let disposeBag = DisposeBag()
    
    var journal: Journal?
    
    init(journal: Journal?, book: Book, type: String) {
        self.book = book
        self.journalType = type
        self.journal = journal
        self.viewModel = JournalEditViewModel(journal: journal, book: book, type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = journalEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundModeColor
        hidesBottomBarWhenPushed = true
        
        bindActions()
        bindEdit()
        bindMainFieldFocus()
        bindPageFieldFocus()
        updateSaveButtonState()
        bindTapGesture()
        bindKeyboard()
        
        viewModel.onSaved = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = [.down]
        view.addGestureRecognizer(swipe)

        
        if let journal = journal {
            journalEditView.pageField.text = journal.savedPage
            journalEditView.mainField.text = journal.journalText
            if let text = journal.journalText {
                journalEditView.mainPlaceholderLabel.isHidden = !text.isEmpty
            }
            updateSaveButtonState()
        }
    }
    
    
    private var didSetInitialHeight = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didSetInitialHeight else { return }
        
        didSetInitialHeight = true
        
        let safeHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let expandedHeight = min(512, safeHeight - 40)
        journalEditView.mainFieldHeightConstraint?.update(offset: expandedHeight)
    }

    
    
    // MARK: bind - 버튼 터치 이벤트 액션
    private func bindActions() {
        journalEditView.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapBackButton()
            })
            .disposed(by: disposeBag)
        
        journalEditView.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.saveButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEdit() {
        Observable.combineLatest(
            journalEditView.pageField.rx.text.orEmpty,
            journalEditView.mainField.rx.text.orEmpty
        )
        .subscribe(onNext: { [weak self] page, text in
            self?.journalEditView.mainPlaceholderLabel.isHidden = !text.isEmpty
            self?.updateSaveButtonState()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        tap.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.dismissKeyboard()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.handleKeyboard(notification)
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: 뒤로가기 버튼
    private func didTapBackButton() {
        if saveCheck() {
            let alert = UIAlertController(title: "나가기", message: "작성한 내용이 저장되지 않았어요. 나가시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "나가기", style: .destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            present(alert, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: 저장 버튼
    private func saveButtonTapped() {
        let page = journalEditView.pageField.text ?? ""
        let text = journalEditView.mainField.text ?? ""
        let currentLiked = journal?.liked ?? false
        
        viewModel.saveButtonTapped(journal: journal, savedPage: page, journalText: text, liked: currentLiked)
    }
    
    
    private func updateSaveButtonState() {
        let newPage = (journalEditView.pageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let newText = (journalEditView.mainField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let journal = journal else {
            journalEditView.saveButton.isEnabled = !newPage.isEmpty && !newText.isEmpty
            return
        }
        let oldPage = (journal.savedPage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let oldText = (journal.journalText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let hasTextChanged = (newPage != oldPage) || (newText != oldText)
        journalEditView.saveButton.isEnabled = !newPage.isEmpty && !newText.isEmpty && hasTextChanged
    }
    
    // MARK: 키보드
    
    // 키보드 높이 설정
    private func handleKeyboard(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let keyboardFrame = frameValue.cgRectValue
        let keyboardInView = view.convert(keyboardFrame, from: nil)
        
        // 키보드가 화면 안에 얼마나 들어와 있는지 계산
        let safeBottom = view.safeAreaInsets.bottom
        let overlap = max(0, view.bounds.height - keyboardInView.origin.y - safeBottom)
        let isKeyboardVisible = overlap > 0
        let safeHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let expandedHeight = safeHeight * 0.65
        let heightWhenKeyboard = safeHeight - overlap
        let collapsedHeight = max(heightWhenKeyboard * 0.65, 200)
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)

        journalEditView.mainFieldHeightConstraint?.update(offset: isKeyboardVisible ? collapsedHeight : expandedHeight)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 키보드 제스처
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: journalEditView.mainField) == true {
            return false
        }
        return true
    }
    
    private func saveCheck() -> Bool {
        let newPage = (journalEditView.pageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let newText = (journalEditView.mainField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let editPage = (journal?.savedPage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let editText = (journal?.journalText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let textChanged = (newPage != editPage) || (newText != editText)
        return textChanged
    }

    
    // MARK: 텍스트필드/텍스트뷰 클릭 시 border 적용
    private func bindPageFieldFocus() {
        journalEditView.pageField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let field = self?.journalEditView.pageField else { return }
                field.layer.borderWidth = 1
                field.dynamicBorder = UIColor.editSelectedBorderColor
            })
            .disposed(by: disposeBag)
        
        journalEditView.pageField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                self?.journalEditView.pageField.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMainFieldFocus() {
        journalEditView.mainField.rx.didBeginEditing
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.journalEditView.mainField.layer.borderWidth = 1
                self.journalEditView.mainField.dynamicBorder = UIColor.editSelectedBorderColor
            })
            .disposed(by: disposeBag)
        
        journalEditView.mainField.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.journalEditView.mainField.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)
    }
}



