// MARK: 독서 상태 체크와 책 유형 체크 용 버튼 베이스

import UIKit
import SnapKit

class BaseButton: UIButton {
    
    var defaultBgColor: UIColor = .unselectedFillColor
    var selectBgColor: UIColor = .gray
    var defautTitleColor: UIColor = .unselectedTextColor
    var selectTitleColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.backgroundColor = .unselectedFillColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.unselectedBorderColor.cgColor
        titleLabel?.font = .systemFont(ofSize: 15)
        self.snp.makeConstraints {
            $0.width.equalTo(77.75).priority(.required)
            $0.height.equalTo(32).priority(.required)
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
        setTitleColor(.unselectedTextColor, for: .normal)
        self.backgroundColor = defaultBgColor
        self.dynamicBorder = UIColor.unselectedBorderColor
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
            self.dynamicBorder = selectBgColor
            setTitleColor(selectTitleColor, for: .normal)
        } else {
            backgroundColor = defaultBgColor
            self.dynamicBorder = UIColor.unselectedBorderColor
            setTitleColor(defautTitleColor, for: .normal)
        }
    }
}
