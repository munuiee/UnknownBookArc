import Foundation
import UIKit
import SnapKit

final class MyPageView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
        setupUI()
        applyAllBorders()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyAllBorders()
    }
    
    private func applyAllBorders() {
        monthView.applyBorder(.gray100)
        yearView.applyBorder(.gray100)
        recommendationButton.applyBorder(.primaryBlue50)
        reviewButton.applyBorder(.primaryBlue50)
        communicationButton.applyBorder(.primaryBlue50)
    }
    
    
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
        label.textColor = .primaryBlue900
        label.font = .semiBoldFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    private let statsSubLabel: UILabel = {
        let label = UILabel()
        label.text = "   2025년 활동 내역이에요"
        label.textColor = .primaryBlue800
        label.font = .mediumFont(ofSize: 12)
        label.textAlignment = .left
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.backgroundColor = .primaryBlue50
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
        view.layer.borderColor = UIColor.gray100.cgColor
        return view
    }()
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 달 완독한 책"
        label.textColor = .gray600
        label.font = .mediumFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    let monthCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .gray900
        label.font = .semiBoldFont(ofSize: 24)
        label.textAlignment = .right
        return label
    }()
    private let yearView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.gray100.cgColor
        return view
    }()
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2025년 완독한 책"
        label.textColor = .gray600
        label.font = .mediumFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    let yearCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .gray900
        label.font = .semiBoldFont(ofSize: 24)
        label.textAlignment = .right
        return label
    }()
    
    private let complimentTitle: UILabel = {
        let label = UILabel()
        label.text = "칭찬하기"
        label.font = .semiBoldFont(ofSize: 20)
        label.textColor = .primaryBlue900
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    
    // 추천 버튼
    private let recommendationButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primaryBlue50.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let recommendationTitle: UILabel = {
        let label = UILabel()
        label.text = "책을 좋아하는 사람에게 추천해 주세요"
        label.font = .mediumFont(ofSize: 12)
        label.textColor = .gray600
        return label
    }()
    
    private let recommendationIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray200
        return imageView
    }()
    
    // 리뷰 버튼
    private let reviewButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primaryBlue50.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "평점 리뷰를 남겨주세요"
        label.font = .mediumFont(ofSize: 12)
        label.textColor = .gray600
        return label
    }()

    private let reviewIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray200
        return imageView
    }()
    
    
    
    private let askingTitle: UILabel = {
        let label = UILabel()
        label.text = "소통하기"
        label.font = .semiBoldFont(ofSize: 20)
        label.textColor = .primaryBlue900
        return label
    }()

    private let communicationButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primaryBlue50.cgColor
        return button
    }()

    private let communicationTitle: UILabel = {
        let label = UILabel()
        label.text = "사용 문의 및 건의하기"
        label.font = .mediumFont(ofSize: 12)
        label.textColor = .gray600
        return label
    }()
    
    private let communicationIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "envelope"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray200
        return imageView
    }()
    
    private func configureUI() {
        self.backgroundColor = .white
        
        
        [topView, statsLabel, statsSubLabel, monthYearSV, complimentTitle, stackView, askingTitle, communicationButton].forEach { self.addSubview($0) }

        topView.addSubview(myPageTitle)
        [monthLabel, monthCountLabel].forEach { monthView.addSubview($0) }
        [yearLabel, yearCountLabel].forEach { yearView.addSubview($0) }
        [monthView, yearView].forEach { monthYearSV.addArrangedSubview($0) }
        
        [recommendationButton, reviewButton].forEach { stackView.addArrangedSubview($0) }
        
        recommendationButton.addSubview(recommendationTitle)
        recommendationButton.addSubview(recommendationIconView)
        reviewButton.addSubview(reviewTitleLabel)
        reviewButton.addSubview(reviewIconView)
        
        communicationButton.addSubview(communicationTitle)
        communicationButton.addSubview(communicationIconView)
        
    }
    
    private func setupUI() {
        
        topView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
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
            $0.height.equalTo(44)
        }
        statsSubLabel.snp.makeConstraints {
            $0.top.equalTo(statsLabel.snp.bottom)
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
        
        complimentTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(monthYearSV.snp.bottom).offset(16)
            $0.height.equalTo(44)
        }
        
        recommendationButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        recommendationTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        
        recommendationIconView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        reviewButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        reviewTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        reviewIconView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(complimentTitle.snp.bottom).offset(8)
        }
        
        askingTitle.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(44)

        }
        
        communicationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(askingTitle.snp.bottom).offset(8)
            $0.height.equalTo(40)
        }
        
        communicationTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        communicationIconView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

    }
}


extension UIView {
    func applyBorder(_ color: UIColor, width: CGFloat = 1) {
        layer.borderWidth = width
        layer.borderColor = color.resolvedColor(with: traitCollection).cgColor
    }
}
