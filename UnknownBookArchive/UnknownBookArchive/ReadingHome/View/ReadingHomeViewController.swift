//
//  ReadingHomeViewController.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/20/25.
//



import UIKit
import SnapKit

final class ReadingHomeViewController: UIViewController {

    private let viewModel = ReadingHomeViewModel()
    
    private let topSpacer = UIView()                // 상단 여백용 뷰
    private let scrollView = UIScrollView()         // 전체 스크롤
    private let contentStackView = UIStackView()    // 콘텐츠 전체 스택

    private let greetingLabel = UILabel()           // 인사 문구 라벨

    private let currentReadingTitleLabel = UILabel()    // 현재 읽고 있는 책
    
    private let currentReadingCardView = UIView()           // 카드 뷰 컨테이너
    private let currentReadingCardTitleLabel = UILabel()    // 카드 제목
    private let currentReadingCardSubtitleLabel = UILabel() // 카드 부제목

    private let addBookButton = UIButton(type: .system)     // 책 추가 버튼

    private let plannedTitleLabel = UILabel()   // 읽을 예정인 책
    private let pausedTitleLabel = UILabel()    // 잠시 멈춘 책
    private let finishedTitleLabel = UILabel()  // 완독한 책

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupHierarchy()
        setupConstraints()
        applySpacing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - UI 설정
    private func setupUI() {

        // Greeting
        let text = "책방지기님,\n독서하기 좋은 날이네요."
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 6

        greetingLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .paragraphStyle: paragraph
            ]
        )
        greetingLabel.numberOfLines = 0

        // StackView 설정
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 0

        // Titles
        currentReadingTitleLabel.text = "현재 읽고 있는 책"
        currentReadingTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        currentReadingTitleLabel.textColor = .darkGray

        plannedTitleLabel.text = "읽을 예정인 책"
        plannedTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)

        pausedTitleLabel.text = "잠시 멈춘 책"
        pausedTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)

        finishedTitleLabel.text = "완독한 책"
        finishedTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)

        // CardView
        currentReadingCardView.backgroundColor = .systemGray6
        currentReadingCardView.layer.cornerRadius = 8

        currentReadingCardTitleLabel.text = "읽고 있는 책을 추가해보세요"
        currentReadingCardTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        currentReadingCardTitleLabel.textAlignment = .center

        currentReadingCardSubtitleLabel.text = "현재 읽고 있는 책이 여기에 표시돼요"
        currentReadingCardSubtitleLabel.font = .systemFont(ofSize: 14)
        currentReadingCardSubtitleLabel.textColor = .secondaryLabel
        currentReadingCardSubtitleLabel.textAlignment = .center

        // Button
        addBookButton.setTitle("책 추가하기", for: .normal)
        addBookButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        addBookButton.setTitleColor(.label, for: .normal)
        addBookButton.backgroundColor = .systemGray6
        addBookButton.layer.cornerRadius = 8
    }

    // MARK: - 계층 구성
    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // 상단 여백
        contentStackView.addArrangedSubview(topSpacer)
        contentStackView.addArrangedSubview(greetingLabel)

        // 인사 라벨
        contentStackView.addArrangedSubview(greetingLabel)

        // 현재 읽고 있는 책
        contentStackView.addArrangedSubview(currentReadingTitleLabel)

        // 카드 내부 스택
        let cardStack = UIStackView(arrangedSubviews: [
            currentReadingCardTitleLabel,
            currentReadingCardSubtitleLabel
        ])
        cardStack.axis = .vertical
        cardStack.alignment = .center
        cardStack.spacing = 2

        currentReadingCardView.addSubview(cardStack)
        contentStackView.addArrangedSubview(currentReadingCardView)

        cardStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 버튼 추가
        contentStackView.addArrangedSubview(addBookButton)

        // 아래 3개 타이틀
        contentStackView.addArrangedSubview(plannedTitleLabel)
        contentStackView.addArrangedSubview(pausedTitleLabel)
        contentStackView.addArrangedSubview(finishedTitleLabel)
    }

    // MARK: - 제약
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        topSpacer.snp.makeConstraints {
            $0.height.equalTo(32)

        }


        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }

        // 카드 높이
        currentReadingCardView.snp.makeConstraints {
            $0.height.equalTo(192)
        }

        addBookButton.snp.makeConstraints {
            $0.height.equalTo(64)
        }
    }

    // MARK: - 요소 간 간격
    private func applySpacing() {
        // Greeting -> 현재 읽고 있는 책
        contentStackView.setCustomSpacing(30, after: greetingLabel)

        // 현재 읽는 책 -> 카드
        contentStackView.setCustomSpacing(16, after: currentReadingTitleLabel)

        // 카드 -> 버튼
        contentStackView.setCustomSpacing(20, after: currentReadingCardView)

        // 버튼 -> 읽을 예정인 책
        contentStackView.setCustomSpacing(24, after: addBookButton)

        // 읽을 예정 -> 잠시 멈춘
        contentStackView.setCustomSpacing(24, after: plannedTitleLabel)

        // 잠시 멈춘 -> 완독
        contentStackView.setCustomSpacing(24, after: pausedTitleLabel)
    }
}
