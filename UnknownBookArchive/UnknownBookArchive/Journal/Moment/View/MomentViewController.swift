// MARK: 찰나의 기록 페이지

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MomentViewController: UIViewController, UIGestureRecognizerDelegate {
    private let momentView = MomentView()
    private let viewModel: MomentListViewModel
    private let book: Book
    private let disposeBag = DisposeBag()
    private var hasLoggedMomentStarted = false
    
    init(book: Book) {
        self.book = book
        self.viewModel = MomentListViewModel(book: book)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var records: [MomentEntity] = []
    var moments: MomentEntity?
    
    override func loadView() {
        view = momentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundModeColor
        
        momentView.collectionView.delegate = self
        momentView.collectionView.dataSource = self
        momentView.collectionView.register(MomentCell.self,
                                           forCellWithReuseIdentifier: MomentCell.id)
        momentView.inputText.delegate = self
        
        bindAction()
        bindKeyboard()
        bindTapGesture()
        
        viewModel.onUpdateMoment = { [weak self] in
            guard let self = self else { return }
            self.momentView.collectionView.reloadData()
        }
        
        viewModel.fetchMoments()
        
        if let moments = moments {
            momentView.inputPage.text = moments.momentPage
            momentView.inputText.text = moments.momentText
            if let text = moments.momentText {
                momentView.textPlaceholderLabel.isHidden = !text.isEmpty
            }
        } else {
            momentView.inputText.text = ""
            textViewDidChange(momentView.inputText)
        }
        
        
    }
    
    // MARK: bind
    private func bindAction() {
        momentView.sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapSend()
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
    
    private func bindTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        tap.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.dismissKeyboard()
            })
            .disposed(by: disposeBag)
    }
    
    private func didTapSend() {
        let pageText = momentView.inputPage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let text = momentView.inputText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.isEmpty == false else { return }
        
        viewModel.addMoment(text: text, page: pageText)
        
        momentView.inputPage.text = ""
        momentView.inputText.text = ""
        momentView.textPlaceholderLabel.isHidden = false
        momentView.inputText.resignFirstResponder()
        
        textViewDidChange(momentView.inputText)
    }
    
    
    
    
    // MARK: 키보드가 올라오고 내려갈 때 chatView 조절
    private func handleKeyboard(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let keyboardFrame = frameValue.cgRectValue
        let keyboardInView = view.convert(keyboardFrame, from: nil)
        
        // 키보드가 화면 안에 있을 때만 overlap 계산
        let safeBottom = view.safeAreaInsets.bottom
        let overlap = max(0, view.bounds.height - keyboardInView.origin.y - safeBottom)
        
        // 입력창을 키보드 높이만큼
        momentView.chatViewBottomConstraint?.update(offset: -overlap)
        
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    // 단일섹션의 경우
    private func scrollToBottom() {
        let section = 0
        let itemCount = momentView.collectionView.numberOfItems(inSection: section)
        guard itemCount > 0 else { return }
        
        let indexPath = IndexPath(item: itemCount - 1, section: section)
        momentView.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    // 다중섹션의 경우
    private func scrollToLastItem() {
        let sectionCount = viewModel.numberOfSections
        guard sectionCount > 0 else { return }
        
        let lastSection = sectionCount - 1
        let itemCount = viewModel.numberOfItems(in: lastSection)
        guard itemCount > 0 else { return }
        
        let indexPath = IndexPath(item: itemCount - 1, section: lastSection)
        momentView.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    // 탭 했을 때 키보드 숨기기
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: momentView.chatView) == true {
            return false
        }
        return true
    }
    
    private func updateInputUI(for textView: UITextView) {
        momentView.textPlaceholderLabel.isHidden = !textView.text.isEmpty
        
        let isEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if isEmpty {
            // 입력 없음
            momentView.buttonView.backgroundColor = .sendButtonDisabledBackgroundColor
            momentView.sendButton.tintColor = .sendButtonDisabledIconColor
        } else {
            // 입력 있음
            momentView.buttonView.backgroundColor = .sendButtonEnabledBackgroundColor
            momentView.sendButton.tintColor = .sendButtonEnabledTextColor
        }
        
        let fittingWidth = textView.bounds.width > 0
        ? textView.bounds.width
        : momentView.inputContainer.bounds.width - 16  // 좌우 inset 고려해서 대략 값
        
        let targetSize = textView.sizeThatFits(
            CGSize(width: fittingWidth, height: .greatestFiniteMagnitude)
        )
        
        let newHeight = min(targetSize.height, momentView.maxTextViewHeight)
        
        momentView.inputTextHeightConstraint?.update(offset: newHeight)
        
        textView.isScrollEnabled = targetSize.height > momentView.maxTextViewHeight
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}

extension MomentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MomentCell.id,
            for: indexPath
        ) as? MomentCell
        else {
            return UICollectionViewCell()
        }
        
        //        cell.editTapped = { [weak self] in
        //            guard let self = self else { return }
        //            // 수정 액션
        //        }
        
        cell.deleteTapped = { [weak self] in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: "삭제",
                message: "이 기록을 삭제할까요?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.viewModel.delete(at: indexPath)
            })
            
            self.present(alert, animated: true)
        }
        
        cell.configure(
            mPage: viewModel.page(at: indexPath),
            mText: viewModel.text(at: indexPath),
            mDate: viewModel.mdateText(at: indexPath),
            mTime: viewModel.mTimeText(at: indexPath)
        )
        
        return cell
    }
    
    // 헤더
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: DateHeaderView.id,
            for: indexPath
        ) as! DateHeaderView
        
        let date = viewModel.dateForSection(indexPath.section)
        header.configure(date: date)
        return header
    }
    
}

extension MomentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if !trimmedText.isEmpty, !hasLoggedMomentStarted {
            AnalyticsManager.shared.logJournalStarted(type: "moment")
            hasLoggedMomentStarted = true
        }

        updateInputUI(for: textView)
    }
}
