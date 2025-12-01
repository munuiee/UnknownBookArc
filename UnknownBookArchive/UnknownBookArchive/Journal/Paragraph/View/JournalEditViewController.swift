// MARK: - 저널 '문단 수집' 추가/편집 페이지

import Foundation
import SnapKit
import UIKit

final class JournalEditViewController: UIViewController {
    private let topView = UIView()
    private let mainLabel = UILabel()
    private let backButton = UIButton(type: .system)
    
    private let vStack = UIStackView()
    private let pageField = UITextField()
    private let mainField = UITextView()
    private let mainPlaceholderLabel = UILabel()
    
    private let buttonView = UIView()
    private let saveButton = UIButton(type: .system)
    
    private let viewModel: JournalEditViewModel
    
    var journal: Journal?
    
    init(journal: Journal?) {
        self.viewModel = JournalEditViewModel(journal: journal)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureStack()
        
        pageField.addTarget(self, action: #selector(updateSaveButtonState), for: .editingChanged)
        mainField.delegate = self
        updateSaveButtonState()
        
        viewModel.onSaved = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        if let journal = journal {
            pageField.text = journal.savedPage
            mainField.text = journal.journalText
            if let text = journal.journalText {
                mainPlaceholderLabel.isHidden = !text.isEmpty
            }
            updateSaveButtonState()
        }
    }
    
    
    
    private func configureUI() {
        [topView, vStack].forEach { view.addSubview($0) }
        [backButton, mainLabel, saveButton].forEach { topView.addSubview($0) }
        
        let backConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .black
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        let enabledImage = UIImage(named: "saveButton")?.withRenderingMode(.alwaysOriginal)
        let disabledImage = UIImage(named: "unsaveButton")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)

        // 상태별 이미지 설정
        saveButton.setImage(enabledImage, for: .normal)
        saveButton.setImage(disabledImage, for: .disabled)

        // 초기 상태 비활성화
        saveButton.isEnabled = false
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)


        
        
        mainLabel.text = "문단 수집"
        mainLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
        }
        
        mainLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        saveButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(25)
        }
        saveButton.isEnabled = false
        
    }
    
    private func configureStack() {
        [pageField, mainField].forEach { vStack.addArrangedSubview($0) }
        
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 24
        vStack.alignment = .fill
        
        pageField.placeholder = " 책의 페이지를 기록해주세요."
        pageField.layer.cornerRadius = 10
        pageField.backgroundColor = .systemGray6
        pageField.font = .systemFont(ofSize: 15)
        pageField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        pageField.leftViewMode = .always
        pageField.keyboardType = .numberPad
        
        
        mainField.layer.cornerRadius = 10
        mainField.backgroundColor = .systemGray6
        mainField.font = .systemFont(ofSize: 15)
        mainField.textColor = .black
        mainField.isScrollEnabled = true
        mainField.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        mainField.delegate = self
        
        mainPlaceholderLabel.text = "문단을 작성해보세요."
        mainPlaceholderLabel.textColor = UIColor(named: "placeholderColor")
        mainPlaceholderLabel.font = .systemFont(ofSize: 15)
        mainField.addSubview(mainPlaceholderLabel)
        mainPlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        vStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(topView.snp.bottom).offset(28)
        }
        
        pageField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(46)
            $0.width.equalTo(335)
        }
        
        mainField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pageField.snp.bottom).offset(24)
            $0.height.equalTo(260)
        }
    }
    
    
    
    @objc private func didTapBackButton() {
        
        if backButtonCheck() {
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
    
    private func backButtonCheck() -> Bool {
        let newPage = (pageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let newText = (mainField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 수정 화면 알럿
        let editPage = (journal?.savedPage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let editText = (journal?.journalText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        let textChanged = (newPage != editPage) || (newText != editText)
        
        return textChanged
    }
    
    @objc private func saveButtonTapped() {
        let page = pageField.text ?? ""
        let text = mainField.text ?? ""
        
        
        viewModel.saveButtonTapped(journal: journal, savedPage: page, journalText: text, liked: false)
    }
    
    @objc private func updateSaveButtonState() {
        let newPage = (pageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let newText = (mainField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 새로 추가하는 경우
        guard let journal = journal else {
            saveButton.isEnabled = !newPage.isEmpty && !newText.isEmpty
            return
        }
        
        // 수정하는 경우
        let oldPage = (journal.savedPage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let oldText = (journal.journalText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        let hasTextChanged = (newPage != oldPage) || (newText != oldText)
        
        saveButton.isEnabled = !newPage.isEmpty && !newText.isEmpty && hasTextChanged
    }
    
}

extension JournalEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        mainPlaceholderLabel.isHidden = !textView.text.isEmpty
        updateSaveButtonState()
    }
}
