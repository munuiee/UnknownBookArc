// MARK: 커스텀 내비게이션 바 베이스

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TopView: UIView {
    
    var backButtonTap: ControlEvent<Void> {
        return backButton.rx.tap
    }
    
    var rightButtonTap: ControlEvent<Void> {
        return rightButton.rx.tap
    }
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .topColor
        label.font = UIFont.semiBoldFont(ofSize: 18)
        return label
    }()
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .saveColor
        button.setTitleColor(.saveColor, for: .normal)
        button.titleLabel?.font = UIFont.semiBoldFont(ofSize: 14)
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let backConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)
        button.setImage(backImage, for: .normal)
        button.tintColor = .topColor
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    private func configureUI() {
        self.backgroundColor = .backgroundModeColor
        [backButton, mainLabel, rightButton].forEach { addSubview($0) }
    }
    private func setConstraints() {
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
        }

        mainLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
        }

        rightButton.snp.makeConstraints {
            //$0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, rightButtonTitle: String?, isRightButtonEnabled: Bool = true) {
        mainLabel.text = title
        rightButton.setTitle(rightButtonTitle, for: .normal)

        // 활성/비활성 상태에 따라 색상 변경
        rightButton.isEnabled = isRightButtonEnabled
        
        if isRightButtonEnabled {
            rightButton.setTitleColor(.saveColor, for: .normal)
            rightButton.alpha = 1.0
        } else {
            rightButton.setTitleColor(.topColor.withAlphaComponent(0.4), for: .disabled)
            rightButton.alpha = 0.5
        }
    }

}
