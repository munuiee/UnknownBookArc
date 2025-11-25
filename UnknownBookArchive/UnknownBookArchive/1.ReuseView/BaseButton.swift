
// MARK: 독서 상태 체크와 책 유형 체크 용 버튼

import UIKit
import SnapKit

class BaseButton: UIButton {
    
    var defaultBgColor: UIColor = .stateDefaultBGColor
    var selectBgColor: UIColor = .gray
    var defautTitleColor: UIColor = .stateDefaultTextColor
    var selectTitleColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.backgroundColor = .stateDefaultBGColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.stateDefaultBorderColor.cgColor
        titleLabel?.font = .systemFont(ofSize: 15)
        self.snp.makeConstraints {
            $0.width.equalTo(77.75)
            $0.height.equalTo(32)
        }
    }
    func configure(title: String,
                   backgroundColor: UIColor,
                   titleColor: UIColor,
                   borderColor: UIColor,
                   selectedBgColor: UIColor,
                   selectedTitleColor: UIColor
    ) {
        setTitle(title, for: .normal)
        setTitleColor(.stateDefaultTextColor, for: .normal)
        self.backgroundColor = defaultBgColor
        self.layer.borderColor = borderColor.cgColor
        self.selectTitleColor = selectedTitleColor
        self.selectBgColor = selectedBgColor
    }
    
    override var isSelected: Bool {
        get { return super.isSelected }
        set {
            super.isSelected = newValue
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        if isSelected {
            backgroundColor = selectBgColor
            self.layer.borderColor = selectBgColor.cgColor
            setTitleColor(selectTitleColor, for: .normal)
        } else {
            backgroundColor = defaultBgColor
            self.layer.borderColor = UIColor.stateDefaultBorderColor.cgColor
            setTitleColor(defautTitleColor, for: .normal)

        }
    }
}
