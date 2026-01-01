// MARK: - 마이페이지 UI

import Foundation
import UIKit
import SnapKit

final class MyPageView: UIView {

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
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
        shareButton.applyBorder(.primaryBlue50)
        reviewButton.applyBorder(.primaryBlue50)
        communicationButton.applyBorder(.primaryBlue50)
    }


    func setSelectedYear(_ year: Int) {
        statsSubLabel.text = "\(year)년 활동 내역이에요"
        yearDropdownLabel.text = "\(year)년 ▾"
        yearLabel.text = "\(year)년 완독한 책"
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
        label.textColor = .myPageLabelColor
        label.font = .semiBoldFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()


    private let activeView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 8
        stView.distribution = .fill
        stView.alignment = .center

        stView.backgroundColor = .activityLabelBackgroundColor
        stView.layer.cornerRadius = 8
        stView.clipsToBounds = true

        stView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        stView.isLayoutMarginsRelativeArrangement = true
        return stView
    }()

    private let statsSubLabel: UILabel = {
        let label = UILabel()
        label.text = "----년 활동 내역이에요"
        label.textColor = .activityLabelTextColor
        label.font = .mediumFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()

    private let spacerView: UIView = {
        let v = UIView()
        v.setContentHuggingPriority(.defaultLow, for: .horizontal)
        v.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return v
    }()

    private let yearDropdownLabel: UILabel = {
        let label = UILabel()
        label.text = "----년 ▾"
        label.textColor = .activityLabelTextColor
        label.font = .semiBoldFont(ofSize: 12)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    let activeTapButton: UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = .clear
        return b
    }()

    // MARK: - Month / Year Stats

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
        view.dynamicBorder = UIColor.statsBorderColor
        return view
    }()

    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 달 완독한 책"
        label.textColor = .statsDescriptionTextColor
        label.font = .mediumFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    let monthCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .statsNumberTextColor
        label.font = .semiBoldFont(ofSize: 24)
        label.textAlignment = .right
        return label
    }()

    private let yearView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.dynamicBorder = UIColor.statsBorderColor
        return view
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "----년 완독한 책"
        label.textColor = .statsDescriptionTextColor
        label.font = .mediumFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    let yearCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .statsNumberTextColor
        label.font = .semiBoldFont(ofSize: 24)
        label.textAlignment = .right
        return label
    }()

    // MARK: - Compliment

    private let complimentTitle: UILabel = {
        let label = UILabel()
        label.text = "칭찬하기"
        label.font = .semiBoldFont(ofSize: 20)
        label.textColor = .myPageLabelColor
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    // 추천 버튼
    let shareButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.dynamicBorder = UIColor.myPageButtonBorderColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let shareTitle: UILabel = {
        let label = UILabel()
        label.text = "책을 좋아하는 사람에게 추천해 주세요"
        label.font = .mediumFont(ofSize: 12)
        label.textColor = .myPageButtonTextColor
        return label
    }()

    private let shareIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .myPageButtonIconFillColor
        return imageView
    }()

    // 리뷰 버튼
    let reviewButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.dynamicBorder = UIColor.myPageButtonBorderColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "평점 리뷰를 남겨주세요"
        label.font = .mediumFont(ofSize: 12)
        label.textColor = .myPageButtonTextColor
        return label
    }()

    private let reviewIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .myPageButtonIconFillColor
        return imageView
    }()

    // MARK: - Communication

    private let askingTitle: UILabel = {
        let label = UILabel()
        label.text = "소통하기"
        label.font = .semiBoldFont(ofSize: 20)
        label.textColor = .myPageLabelColor
        return label
    }()

    let communicationButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.dynamicBorder = UIColor.myPageButtonBorderColor
        return button
    }()

    private let communicationTitle: UILabel = {
        let label = UILabel()
        label.text = "사용 문의 및 건의하기"
        label.font = .mediumFont(ofSize: 12)
        label.textColor = .myPageButtonTextColor
        return label
    }()

    private let communicationIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "envelope"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .myPageButtonIconFillColor
        return imageView
    }()

    // MARK: - Configure UI

    private func configureUI() {
        backgroundColor = .backgroundModeColor

        [
            topView,
            statsLabel,
            activeView,
            activeTapButton,
            monthYearSV,
            complimentTitle,
            stackView,
            askingTitle,
            communicationButton
        ].forEach { addSubview($0) }

        topView.addSubview(myPageTitle)

        // activeView 구성
        activeView.addArrangedSubview(statsSubLabel)
        activeView.addArrangedSubview(spacerView)
        activeView.addArrangedSubview(yearDropdownLabel)

        // month/year cards
        [monthLabel, monthCountLabel].forEach { monthView.addSubview($0) }
        [yearLabel, yearCountLabel].forEach { yearView.addSubview($0) }
        [monthView, yearView].forEach { monthYearSV.addArrangedSubview($0) }

        // compliment buttons
        [shareButton, reviewButton].forEach { stackView.addArrangedSubview($0) }

        shareButton.addSubview(shareTitle)
        shareButton.addSubview(shareIconView)

        reviewButton.addSubview(reviewTitleLabel)
        reviewButton.addSubview(reviewIconView)

        // communication
        communicationButton.addSubview(communicationTitle)
        communicationButton.addSubview(communicationIconView)

        // 왼쪽 라벨은 늘어나고 오른쪽은 고정
        statsSubLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        statsSubLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    // MARK: - Layout

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
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }

        activeView.snp.makeConstraints {
            $0.top.equalTo(statsLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }

        activeTapButton.snp.makeConstraints {
            $0.edges.equalTo(activeView)
        }

        monthYearSV.snp.makeConstraints {
            $0.top.equalTo(activeView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        monthView.snp.makeConstraints { $0.height.equalTo(94) }
        yearView.snp.makeConstraints { $0.height.equalTo(94) }

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

        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(complimentTitle.snp.bottom).offset(8)
        }

        shareButton.snp.makeConstraints { $0.height.equalTo(40) }
        reviewButton.snp.makeConstraints { $0.height.equalTo(40) }

        shareTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        shareIconView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
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
        layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
    }
}
