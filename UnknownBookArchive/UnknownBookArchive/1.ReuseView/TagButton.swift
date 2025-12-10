// MARK: 장르 태그 버튼 베이스

import UIKit
import SnapKit

class TagButton: UIButton {
    
    var defaultBgColor: UIColor = .genreTagUnselectedFillColor
    var selectBgColor: UIColor = .genreTagSelectedFillColor
    var defautTitleColor: UIColor = UIColor.genreTagUnselectedTextColor
    var selectTitleColor: UIColor = .genreTagSelectedTextColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.backgroundColor = defaultBgColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.genreTagUnselectedBorderColor.cgColor
        titleLabel?.font = UIFont.regularFont(ofSize: 15)

        self.setContentHuggingPriority(.required, for: .horizontal)
        self.snp.makeConstraints {
            $0.width.equalTo(61).priority(.required)
            $0.height.equalTo(32).priority(.required)
        }
    }
    func configure(title: String,
                   titleColor: UIColor,
                   backgroundColor: UIColor,
                   borderColor: UIColor,
                   selectedBgColor: UIColor,
                   selectedTitleColor: UIColor,
                   selectedBorderColor: UIColor
    ) {
        setTitle(title, for: .normal)
        setTitleColor(.genreTagUnselectedTextColor, for: .normal)
        titleLabel?.font = UIFont.mediumFont(ofSize: 14)
        self.backgroundColor = defaultBgColor
        self.dynamicBorder = borderColor
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
        backgroundColor = defaultBgColor
        if isSelected {
            backgroundColor = .genreTagSelectedFillColor
            self.dynamicBorder = UIColor.genreTagSelectedBorderColor
            setTitleColor(.genreTagSelectedTextColor, for: .normal)
        } else {
            backgroundColor = defaultBgColor
            self.dynamicBorder = UIColor.genreTagUnselectedBorderColor
            setTitleColor(defautTitleColor, for: .normal)

        }
    }
}
