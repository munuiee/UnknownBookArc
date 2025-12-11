// MARK: 책 상세페이지 텍스트 필드 베이스

import UIKit
import SnapKit

class BaseTextField: UITextField {
    
    // 텍스트 필드 여백 만들기
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.textField2BorderColor.cgColor
        backgroundColor = .textField2Background
        font = UIFont.mediumFont(ofSize: 14)
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.paragraphTextColor,
            .font: UIFont.mediumFont(ofSize: 14)
        ]
        self.defaultTextAttributes = defaultAttributes
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    func configure(placeholder: String) {
        let placeholderColor: UIColor = UIColor.textField2PlaceholderColor
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
            .font: UIFont.regularFont(ofSize: 15)
        ]
        
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder, attributes: attributes)
    }
}
