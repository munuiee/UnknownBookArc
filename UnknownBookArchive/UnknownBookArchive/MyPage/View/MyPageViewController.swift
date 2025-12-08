// MARK: 마이페이지

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    private let myPageTitle: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = UIFont.semiBoldFont(ofSize: 18)
        return label
    }()
    
    private let topView = UIView()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.text = "통계"
        label.textColor = .color1A1919
        label.font = .semiBoldFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    private let statsSubLabel: UILabel = {
        let label = UILabel()
        label.text = "   2025년 활동 내역이에요"
        label.textColor = .color375846
        label.font = .mediumFont(ofSize: 12)
        label.textAlignment = .left
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.tagSeletedBGColor.cgColor
        return label
    }()
    private let monthYearSV: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 8
        stView.distribution = .fillEqually
        stView.alignment = .center
        return stView
    }()
    
    private let monthView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.colorE6E6E6.cgColor
        return view
    }()
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 달 완독한 책"
        label.textColor = .color375846
        label.font = .mediumFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private let monthCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .color1A1919
        label.font = .semiBoldFont(ofSize: 24)
        label.textAlignment = .right
        return label
    }()
    private let yearView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.colorE6E6E6.cgColor
        return view
    }()
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2025년 완독한 책"
        label.textColor = .color375846
        label.font = .mediumFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    private let yearCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .color1A1919
        label.font = .semiBoldFont(ofSize: 24)
        label.textAlignment = .right
        return label
    }()
    private let backUpLabel: UILabel = {
        let label = UILabel()
        label.text = "백업 / 복원"
        label.textColor = .color1A1919
        label.font = .semiBoldFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    private let backUPSubLabel: UILabel = {
        let label = UILabel()
        label.text = "   [백업] 버튼을 눌러 백업 파일을 내보내 주세요"
        label.textColor = .color375846
        label.font = .mediumFont(ofSize: 12)
        label.textAlignment = .left
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.tagSeletedBGColor.cgColor
        return label
    }()
    private let backUPButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .primaryColor
        config.baseForegroundColor = .white
        let title = "백업하기"
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.semiBoldFont(ofSize: 18)]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attributes))
        button.configuration = config
        let iconImage = UIImage(systemName: "square.and.arrow.down")
        button.setImage(iconImage, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private let restoreSubLabel: UILabel = {
        let label = UILabel()
        label.text = "   [복원] 버튼을 눌러 백업 파일을 선택해 주세요"
        label.textColor = .color375846
        label.font = .mediumFont(ofSize: 12)
        label.textAlignment = .left
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.tagSeletedBGColor.cgColor
        return label
    }()
    private let restoreButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .primaryColor
        config.baseForegroundColor = .white
        let title = "복원하기"
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.semiBoldFont(ofSize: 18)]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attributes))
        button.configuration = config
        let iconImage = UIImage(systemName: "square.and.arrow.up")
        button.setImage(iconImage, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [topView, statsLabel, statsSubLabel, monthYearSV, backUpLabel, backUPSubLabel, backUPButton, restoreSubLabel, restoreButton].forEach { view.addSubview($0) }

        topView.addSubview(myPageTitle)
        [monthLabel, monthCountLabel].forEach { monthView.addSubview($0) }
        [yearLabel, yearCountLabel].forEach { yearView.addSubview($0) }
        [monthView, yearView].forEach { monthYearSV.addArrangedSubview($0) }
        
    }
    
    private func setupUI() {
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        
        myPageTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        statsLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        statsSubLabel.snp.makeConstraints {
            $0.top.equalTo(statsLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            
        }
        monthYearSV.snp.makeConstraints {
            $0.top.equalTo(statsSubLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        monthView.snp.makeConstraints {
            $0.height.equalTo(94)
        }
        yearView.snp.makeConstraints {
            $0.height.equalTo(94)
        }
        monthLabel.snp.makeConstraints {
            $0.centerX.equalTo(monthView.snp.centerX)
            $0.centerY.equalTo(monthView.snp.centerY).offset(-15)
            $0.top.equalTo(monthView.snp.top).offset(16)
        }
        monthCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(monthView.snp.centerY).offset(15)
            $0.trailing.equalTo(monthLabel.snp.trailing)
        }

        yearLabel.snp.makeConstraints {
            $0.centerX.equalTo(yearView.snp.centerX)
            $0.centerY.equalTo(yearView.snp.centerY).offset(-15)
            $0.top.equalTo(yearView.snp.top).offset(16)
        }
        yearCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(yearView.snp.centerY).offset(15)
            $0.trailing.equalTo(yearLabel.snp.trailing)
        }
        backUpLabel.snp.makeConstraints {
            $0.top.equalTo(monthYearSV.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        backUPSubLabel.snp.makeConstraints {
            $0.top.equalTo(backUpLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
        backUPButton.snp.makeConstraints {
            $0.top.equalTo(backUPSubLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        restoreSubLabel.snp.makeConstraints {
            $0.top.equalTo(backUPButton.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
        restoreButton.snp.makeConstraints {
            $0.top.equalTo(restoreSubLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }

    
}
