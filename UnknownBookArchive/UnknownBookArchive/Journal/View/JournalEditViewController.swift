import Foundation
import SnapKit
import UIKit

final class JournalEditViewController: UIViewController {
    private let topView = UIView()
    private let mainLabel = UILabel()
    private let saveButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    private let vStack = UIStackView()
    private let pageField = UITextField()
    private let mainField = UITextView()
    private let mainPlaceholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureStack()
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
        
        let image = UIImage(named: "saveButton")?.withRenderingMode(.alwaysOriginal)
        saveButton.setImage(image, for: .normal)
        
        
        
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
        
        mainPlaceholderLabel.text = "노트를 작성해보세요"
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
        navigationController?.popViewController(animated: true)
    }
}

extension JournalEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        mainPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}
