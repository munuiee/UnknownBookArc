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
    private let currentReadingCardView = UIView()   // 카드 뷰 컨테이너
    private let greetingSectionView = UIView()      // 인사 + 카드 포함 박스
    
    private let currentReadingCardTitleLabel = UILabel()
    private let currentReadingCardSubtitleLabel = UILabel()

    private let addBookButton = UIButton(type: .system) // 책 추가 버튼

    private let plannedTitleLabel = UILabel()   // 읽을 예정인 책
    private let pausedTitleLabel = UILabel()    // 잠시 멈춘 책
    private let finishedTitleLabel = UILabel()  // 완독한 책
    
    private let plannedEmptyCard = UIView()
    private let pausedEmptyCard = UIView()
    private let finishedEmptyCard = UIView()

    private let plannedEmptyLabel = UILabel()
    private let pausedEmptyLabel = UILabel()
    private let finishedEmptyLabel = UILabel()
    
    private let topGap = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        scrollView.contentInset.bottom = 20

        setupUI()
        setupHierarchy()
        setupConstraints()
        applySpacing()
        
        addBookButton.addTarget(self, action: #selector(didTapAddBook), for: .touchUpInside)
    }
    
    @objc private func didTapAddBook() {
        let searchVC = BookSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }

    // MARK: - UI 설정
    private func setupUI() {

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
        greetingLabel.textColor = .black
        greetingLabel.numberOfLines = 0
        
        // 하늘색 카드
        greetingSectionView.backgroundColor = .readinHomeBannerColor
        greetingSectionView.layer.cornerRadius = 8
        greetingSectionView.layer.shadowColor = UIColor.black.cgColor
        greetingSectionView.layer.shadowOpacity = 0.15
        greetingSectionView.layer.shadowRadius = 12
        greetingSectionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        greetingSectionView.layer.masksToBounds = false

        // CardView
        currentReadingCardView.backgroundColor = .white
        currentReadingCardView.layer.cornerRadius = 8

        currentReadingCardTitleLabel.text = "읽고 있는 책을 추가해보세요"
        currentReadingCardTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        currentReadingCardTitleLabel.textAlignment = .center
        currentReadingCardTitleLabel.textColor = .black

        currentReadingCardSubtitleLabel.text = "현재 읽고 있는 책이 여기에 표시돼요"
        currentReadingCardSubtitleLabel.font = .systemFont(ofSize: 14)
        currentReadingCardSubtitleLabel.textAlignment = .center
        currentReadingCardSubtitleLabel.textColor = .lightGray

        // Button
        addBookButton.setTitle("책 추가하기", for: .normal)
        addBookButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        addBookButton.backgroundColor = .addBookButtonColor
        addBookButton.setTitleColor(.white, for: .normal)
        addBookButton.layer.cornerRadius = 8

        plannedTitleLabel.text = "읽을 예정인 책"
        plannedTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)

        pausedTitleLabel.text = "잠시 멈춘 책"
        pausedTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)

        finishedTitleLabel.text = "완독한 책"
        finishedTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)

        // 공통 카드 스타일
        func styleEmptyCard(_ card: UIView, label: UILabel, text: String) {
            card.backgroundColor = .readingHomeGrayColor
            card.layer.cornerRadius = 8
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor.systemGray5.cgColor
            
            label.text = text
            label.font = .systemFont(ofSize: 14)
            label.textColor = .lightGray
            label.textAlignment = .center
            
        }

        styleEmptyCard(plannedEmptyCard, label: plannedEmptyLabel, text: "읽을 예정인 책이 없어요")
        styleEmptyCard(pausedEmptyCard, label: pausedEmptyLabel, text: "잠시 멈춘 책이 없어요")
        styleEmptyCard(finishedEmptyCard, label: finishedEmptyLabel, text: "완독한 책이 없어요")

        contentStackView.axis = .vertical
        contentStackView.spacing = 0
    }

    // MARK: - 계층 구성
    private func setupHierarchy() {

        // 스크롤 + 스택뷰 추가
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        // 상단 여백용 spacer 추가 (하늘색 카드 위 여백)
        let topGap = UIView()
        contentStackView.addArrangedSubview(topGap)

        // greetingSectionView 안에 라벨 + 카드 넣기
        greetingSectionView.addSubview(greetingLabel)
        greetingSectionView.addSubview(currentReadingCardView)
        contentStackView.addArrangedSubview(greetingSectionView)

        let cardStack = UIStackView(arrangedSubviews: [
            currentReadingCardTitleLabel,
            currentReadingCardSubtitleLabel
        ])
        cardStack.axis = .vertical
        cardStack.alignment = .center
        cardStack.spacing = 2
        currentReadingCardView.addSubview(cardStack)

        cardStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 아래 구성
        contentStackView.addArrangedSubview(topSpacer)
        contentStackView.addArrangedSubview(addBookButton)
        
        contentStackView.addArrangedSubview(plannedTitleLabel)
        contentStackView.addArrangedSubview(plannedEmptyCard)
        
        contentStackView.addArrangedSubview(pausedTitleLabel)
        contentStackView.addArrangedSubview(pausedEmptyCard)
        
        contentStackView.addArrangedSubview(finishedTitleLabel)
        contentStackView.addArrangedSubview(finishedEmptyCard)
        
        plannedEmptyCard.addSubview(plannedEmptyLabel)
        pausedEmptyCard.addSubview(pausedEmptyLabel)
        finishedEmptyCard.addSubview(finishedEmptyLabel)

    }

    // MARK: - 제약
    private func setupConstraints() {
        
        topGap.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        greetingSectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(greetingSectionView).offset(16)
            $0.leading.trailing.equalTo(greetingSectionView).inset(16)
            $0.height.equalTo(70)
        }
        
        currentReadingCardView.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(greetingSectionView).inset(16)
            $0.height.equalTo(200)
            $0.bottom.equalTo(greetingSectionView.snp.bottom).offset(-16)
        }
        
        plannedTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
        }

        pausedTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
        }

        finishedTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
        }


        topSpacer.snp.makeConstraints {
            $0.height.equalTo(16)
        }

        addBookButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
      
        plannedEmptyCard.snp.makeConstraints {
            $0.height.equalTo(140)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        plannedEmptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        pausedEmptyCard.snp.makeConstraints {
            $0.height.equalTo(140)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        pausedEmptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        finishedEmptyCard.snp.makeConstraints {
            $0.height.equalTo(140)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        finishedEmptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    
    }

    // MARK: - 요소 간 간격
    private func applySpacing() {
        contentStackView.setCustomSpacing(24, after: addBookButton)
        contentStackView.setCustomSpacing(16, after: plannedTitleLabel)
        contentStackView.setCustomSpacing(32, after: plannedEmptyCard)
        contentStackView.setCustomSpacing(16, after: pausedTitleLabel)
        contentStackView.setCustomSpacing(32, after: pausedEmptyCard)
        contentStackView.setCustomSpacing(16, after: finishedTitleLabel)
        
        contentStackView.setCustomSpacing(50, after: finishedEmptyCard)
    }

}



