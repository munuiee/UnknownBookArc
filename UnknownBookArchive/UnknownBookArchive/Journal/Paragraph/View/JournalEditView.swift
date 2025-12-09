
import Foundation
import UIKit
import SnapKit

final class JournalEditView: UIView {
    
    let topView = UIView()
    let mainLabel = UILabel()
    let backButton = UIButton(type: .system)
    
    let vStack = UIStackView()
    let pageField = UITextField()
    let mainField = UITextView()
    let mainPlaceholderLabel = UILabel()
    
    private let buttonView = UIView()
    let saveButton = UIButton(type: .system)
    
    var mainFieldHeightConstraint: Constraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
        configureStack()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [topView, vStack].forEach { addSubview($0) }
        [backButton, mainLabel, saveButton].forEach { topView.addSubview($0) }
        
        let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .black
        backButton.sizeToFit()
        
        
        let enabledImage = UIImage(named: "saveButton")?.withRenderingMode(.alwaysOriginal)
        let disabledImage = UIImage(named: "unSaveButton")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        // 상태별 이미지 설정
        saveButton.setImage(enabledImage, for: .normal)
        saveButton.setImage(disabledImage, for: .disabled)
        saveButton.backgroundColor = .clear
        
        // 초기 상태 비활성화
        saveButton.isEnabled = false
        
        mainLabel.text = "문단 수집"
        mainLabel.font = UIFont.semiBoldFont(ofSize: 18)
        
        topView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
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
    
    // 스택뷰 설정
    private func configureStack() {
        [pageField, mainField].forEach { vStack.addArrangedSubview($0) }
        
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 24
        vStack.alignment = .fill
        
        pageField.placeholder = " 책의 페이지를 기록해주세요."
        pageField.layer.cornerRadius = 10
        pageField.backgroundColor = .gray50
        pageField.font = UIFont.regularFont(ofSize: 15)
        pageField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        pageField.leftViewMode = .always
        pageField.keyboardType = .numberPad
        
        
        mainField.layer.cornerRadius = 10
        mainField.backgroundColor = .gray50
        mainField.font = UIFont.regularFont(ofSize: 15)
        mainField.textColor = .black
        mainField.isScrollEnabled = true
        mainField.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        mainPlaceholderLabel.text = "문단을 작성해보세요."
        mainPlaceholderLabel.textColor = UIColor(named: "placeholderColor")
        mainPlaceholderLabel.font = UIFont.regularFont(ofSize: 15)
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
            mainFieldHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
}


