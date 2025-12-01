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
    
    private let scrollView = UIScrollView()     // 전체 스크롤
    private let contentStackView = UIStackView()    // 콘텐츠 전체 스택
    
    private let greetingLabel = UILabel()       // 인사 문구 라벨
    private let greetingSectionView = UIView()  // 인사 + 카드 포함 박스
    private let currentReadingCardView = UIView()   // 카드 뷰 컨테이너
    private let currentReadingCardTitleLabel = UILabel()
    private let currentReadingCardSubtitleLabel = UILabel()
    
    // 현재 읽는 중 카드 placeholder 스택
    private let currentReadingEmptyStack = UIStackView()
    
    // 현재 읽는 중 책들 가로 스크롤용 컬렉션뷰
    private var currentReadingCollectionView: UICollectionView!
    
    private let greetingMoreButton = UIButton(type: .system)
    
    // 현재 읽는 중 책 데이터 (최대 10개)
    private var currentReadingBooks: [Book] = []
    
    private let addBookButton = UIButton(type: .system)
    
    // MARK: - 섹션 UI
    private let plannedTitleLabel = UILabel()
    private let plannedMoreButton = UIButton(type: .system)
    private let plannedEmptyCard = UIView()
    private let plannedEmptyLabel = UILabel()
    private var plannedCollectionView: UICollectionView!
    private var plannedHeader: UIStackView!
    
    private let pausedTitleLabel = UILabel()
    private let pausedMoreButton = UIButton(type: .system)
    private let pausedEmptyCard = UIView()
    private let pausedEmptyLabel = UILabel()
    private var pausedCollectionView: UICollectionView!
    private var pausedHeader: UIStackView!
    
    private let finishedTitleLabel = UILabel()
    private let finishedMoreButton = UIButton(type: .system)
    private let finishedEmptyCard = UIView()
    private let finishedEmptyLabel = UILabel()
    private var finishedCollectionView: UICollectionView!
    private var finishedHeader: UIStackView!
    
    // MARK: - 데이터
    private var plannedBooks: [Book] = []
    private var pausedBooks: [Book] = []
    private var finishedBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        scrollView.contentInset.bottom = 20
        
        setupUI()
        setupCollectionViews()
        setupHierarchy()
        setupConstraints()
        bindViewModel()
        applyInitialSpacing()
        
        addBookButton.addTarget(self, action: #selector(didTapAddBook), for: .touchUpInside)
        
        viewModel.loadInitialData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadFromCoreData()
    }
    
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
        }
    }
    
    
    // MARK: - UI 업데이트
    private func updateUI() {
        let model = viewModel.model
        
        // 현재 읽는 중 책 (최대 10개)
        currentReadingBooks = Array(model.currentReadingBooks.prefix(10))
        
        plannedBooks = Array(model.plannedBooks.prefix(10))
        pausedBooks = Array(model.pausedBooks.prefix(10))
        finishedBooks = Array(model.finishedBooks.prefix(10))
        
        updateCurrentReadingCardUI()
        updateSectionVisibility()
        updateDynamicSpacing()
        
        currentReadingCollectionView.reloadData()
        plannedCollectionView.reloadData()
        pausedCollectionView.reloadData()
        finishedCollectionView.reloadData()
        
    }
    
    
    // MARK: - 현재 읽는 중 카드 UI
    private func updateCurrentReadingCardUI() {
        if currentReadingBooks.isEmpty {
            currentReadingEmptyStack.isHidden = false
            currentReadingCollectionView.isHidden = true
            
        } else {
            currentReadingEmptyStack.isHidden = true
            currentReadingCollectionView.isHidden = false
           
        }
    }
    
    
    // MARK: - show/hide emptyCard or collectionView
    private func updateSectionVisibility() {
        
        plannedEmptyCard.isHidden = !plannedBooks.isEmpty
        plannedCollectionView.isHidden = plannedBooks.isEmpty
        
        pausedEmptyCard.isHidden = !pausedBooks.isEmpty
        pausedCollectionView.isHidden = pausedBooks.isEmpty
        
        finishedEmptyCard.isHidden = !finishedBooks.isEmpty
        finishedCollectionView.isHidden = finishedBooks.isEmpty
    }
    
    
    // MARK: - 동적 간격 조절
    private func updateDynamicSpacing() {
        
        // 읽을 예정인 책
        contentStackView.setCustomSpacing(plannedBooks.isEmpty ? 20 : 0, after: plannedHeader)
        contentStackView.setCustomSpacing(40, after: plannedEmptyCard)
        contentStackView.setCustomSpacing(16, after: plannedCollectionView)
        
        // 잠시 멈춘 책
        contentStackView.setCustomSpacing(pausedBooks.isEmpty ? 20 : 0, after: pausedHeader)
        contentStackView.setCustomSpacing(40, after: pausedEmptyCard)
        contentStackView.setCustomSpacing(40, after: pausedCollectionView)
        
        // 완독한 책
        contentStackView.setCustomSpacing(finishedBooks.isEmpty ? 20 : 0, after: finishedHeader)
        contentStackView.setCustomSpacing(60, after: finishedEmptyCard)
        contentStackView.setCustomSpacing(60, after: finishedCollectionView)
    }
    
    
    @objc private func didTapAddBook() {
        let searchVC = BookSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    // MARK: - 기본 UI 설정
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
        
        greetingMoreButton.setTitle("더보기", for: .normal)
            greetingMoreButton.setTitleColor(.addBookButtonColor, for: .normal)
            greetingMoreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
    
        greetingLabel.numberOfLines = 0
        greetingLabel.textColor = .black
        
        greetingSectionView.backgroundColor = .readinHomeBannerColor
        greetingSectionView.layer.cornerRadius = 8
        greetingSectionView.clipsToBounds = true

        
        currentReadingCardView.backgroundColor = .white
        currentReadingCardView.layer.cornerRadius = 8
        
        currentReadingCardTitleLabel.text = "읽고 있는 책을 추가해보세요"
        currentReadingCardTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        currentReadingCardTitleLabel.textAlignment = .center
        
        currentReadingCardSubtitleLabel.text = "현재 읽고 있는 책이 여기에 표시돼요"
        currentReadingCardSubtitleLabel.font = .systemFont(ofSize: 14)
        currentReadingCardSubtitleLabel.textAlignment = .center
        currentReadingCardSubtitleLabel.textColor = .lightGray
        
        
        // 읽을 예정인 책 / 잠시 멈춘 책 / 완독한 책
        func styleTitle(_ label: UILabel, _ text: String) {
            label.text = text
            label.font = .boldSystemFont(ofSize: 20)
        }
        styleTitle(plannedTitleLabel, "읽을 예정인 책")
        styleTitle(pausedTitleLabel, "잠시 멈춘 책")
        styleTitle(finishedTitleLabel, "완독한 책")
        
        func styleMore(_ button: UIButton) {
            button.setTitle("더보기", for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
        }
        styleMore(plannedMoreButton)
        styleMore(pausedMoreButton)
        styleMore(finishedMoreButton)
        
        addBookButton.setTitle("책 추가하기", for: .normal)
        addBookButton.layer.cornerRadius = 8
        addBookButton.backgroundColor = .addBookButtonColor
        addBookButton.setTitleColor(.white, for: .normal)
        addBookButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        // Empty 카드 공통 스타일
        func styleCard(_ card: UIView, _ label: UILabel, _ text: String) {
            card.backgroundColor = .readingHomeGrayColor
            card.layer.cornerRadius = 8
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor.systemGray5.cgColor
            
            label.text = text
            label.textAlignment = .center
            label.textColor = .lightGray
        }
        styleCard(plannedEmptyCard, plannedEmptyLabel, "읽을 예정인 책이 없어요")
        styleCard(pausedEmptyCard, pausedEmptyLabel, "잠시 멈춘 책이 없어요")
        styleCard(finishedEmptyCard, finishedEmptyLabel, "완독한 책이 없어요")
        
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 0
    }
    
    
    // MARK: - CollectionView 설정
    private func setupCollectionViews() {
        
        // 현재 읽는 책 카드 — 한 권씩 스와이프되도록 스냅 페이징 적용
        currentReadingCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCurrentReadingLayout()
            
        )
        currentReadingCollectionView.backgroundColor = .clear
        currentReadingCollectionView.showsHorizontalScrollIndicator = false
        currentReadingCollectionView.dataSource = self
        currentReadingCollectionView.delegate = self
        
        currentReadingCollectionView.alwaysBounceVertical = false   // 세로 바운스 제거
        currentReadingCollectionView.isScrollEnabled = true         // 가로 스크롤 유지
        

        currentReadingCollectionView.register(
            CurrentReadingCell.self,
            forCellWithReuseIdentifier: CurrentReadingCell.identifier
        )
        currentReadingCollectionView.isHidden = true
        

        
        
        // 아래 3개 섹션 공통 레이아웃
        func layout() -> UICollectionViewFlowLayout {
            let l = UICollectionViewFlowLayout()
            l.scrollDirection = .horizontal
            l.itemSize = CGSize(width: 80, height: 119)
            l.minimumLineSpacing = 16
            l.sectionInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 32)
            return l
        }
        
        plannedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        pausedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        finishedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())

        [plannedCollectionView, pausedCollectionView, finishedCollectionView].forEach {
            $0?.backgroundColor = .clear
            $0?.showsHorizontalScrollIndicator = false
            $0?.dataSource = self
            $0?.delegate = self
            $0?.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.identifier)
        }

        plannedCollectionView.isHidden = true
        pausedCollectionView.isHidden = true
        finishedCollectionView.isHidden = true
    }

    
    
    // MARK: - 계층 구성
    private func setupHierarchy() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        let topGap = UIView()
        contentStackView.addArrangedSubview(topGap)
        
        greetingSectionView.addSubview(greetingLabel)
        greetingSectionView.addSubview(currentReadingCardView)
        
        greetingSectionView.addSubview(greetingMoreButton)

        greetingMoreButton.snp.makeConstraints {
            $0.top.equalTo(greetingSectionView).offset(12)
            $0.trailing.equalTo(greetingSectionView).inset(12)
        }
        
        contentStackView.addArrangedSubview(greetingSectionView)
        
        currentReadingEmptyStack.axis = .vertical
        currentReadingEmptyStack.alignment = .center
        currentReadingEmptyStack.spacing = 2
        currentReadingEmptyStack.addArrangedSubview(currentReadingCardTitleLabel)
        currentReadingEmptyStack.addArrangedSubview(currentReadingCardSubtitleLabel)
        
        currentReadingCardView.addSubview(currentReadingEmptyStack)
        currentReadingCardView.addSubview(currentReadingCollectionView)
        
        currentReadingEmptyStack.snp.makeConstraints { $0.center.equalToSuperview()
        }
        
        currentReadingCollectionView.snp.makeConstraints { $0.edges.equalToSuperview().inset(12)
            $0.height.equalTo(180)
        }
        
        contentStackView.addArrangedSubview(addBookButton)
        
        greetingSectionView.addSubview(greetingMoreButton)

        greetingMoreButton.snp.makeConstraints {
            $0.top.equalTo(greetingSectionView).offset(12)
            $0.trailing.equalTo(greetingSectionView).inset(12)
        }
        
        
        // 공통 섹션 생성
        plannedHeader = addSection(titleLabel: plannedTitleLabel,
                                   moreButton: plannedMoreButton,
                                   emptyCard: plannedEmptyCard,
                                   emptyLabel: plannedEmptyLabel,
                                   collectionView: plannedCollectionView)
        
        pausedHeader = addSection(titleLabel: pausedTitleLabel,
                                  moreButton: pausedMoreButton,
                                  emptyCard: pausedEmptyCard,
                                  emptyLabel: pausedEmptyLabel,
                                  collectionView: pausedCollectionView)
        
        finishedHeader = addSection(titleLabel: finishedTitleLabel,
                                    moreButton: finishedMoreButton,
                                    emptyCard: finishedEmptyCard,
                                    emptyLabel: finishedEmptyLabel,
                                    collectionView: finishedCollectionView)
        
        topGap.snp.makeConstraints { $0.height.equalTo(20) }
        
        view.bringSubviewToFront(addBookButton)
    }
    
    
    // MARK: - 섹션 생성 함수
    @discardableResult
    private func addSection(titleLabel: UILabel,
                            moreButton: UIButton,
                            emptyCard: UIView,
                            emptyLabel: UILabel,
                            collectionView: UICollectionView) -> UIStackView {
        
        let header = UIStackView(arrangedSubviews: [titleLabel, UIView(), moreButton])
        header.axis = .horizontal
        
        contentStackView.addArrangedSubview(header)
        
        header.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        emptyCard.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        contentStackView.addArrangedSubview(emptyCard)
        contentStackView.addArrangedSubview(collectionView)
        
        emptyCard.snp.makeConstraints {
            $0.height.equalTo(140)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        
        return header
    }
    
    
    // MARK: - 초기 간격 설정
    private func applyInitialSpacing() {
        contentStackView.setCustomSpacing(32, after: greetingSectionView)
        contentStackView.setCustomSpacing(40, after: addBookButton)
    }
    
    
    // MARK: - Constraints
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalToSuperview()
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
            $0.height.equalTo(180)
            $0.bottom.equalTo(greetingSectionView.snp.bottom).offset(-16)
        }
        
        addBookButton.snp.makeConstraints {
            $0.top.equalTo(greetingSectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }

    }
}

// MARK: - 현재 읽는 중 컬렉션 레이아웃
private func makeCurrentReadingLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }



// MARK: - CollectionView DataSource + Delegate
extension ReadingHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == currentReadingCollectionView {
            return currentReadingBooks.count
        }
        
        if collectionView == plannedCollectionView { return plannedBooks.count }
        if collectionView == pausedCollectionView { return pausedBooks.count }
        return finishedBooks.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 현재 읽는 중 카드 셀
        if collectionView == currentReadingCollectionView {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrentReadingCell.identifier,
                for: indexPath
            ) as! CurrentReadingCell
            
            let book = currentReadingBooks[indexPath.item]
            
            // 책 정보 적용
            cell.titleLabel.text = book.title
            cell.authorLabel.text = book.author
            
            if let imgData = book.coverImage,
               let image = UIImage(data: imgData) {
                cell.thumbnailImageView.image = image
            }
            
            if let startDate = book.startDate {
                let df = DateFormatter()
                df.dateFormat = "yyyy.MM.dd"
                cell.dateLabel.text = df.string(from: startDate)
            }
            
            let currentPage = Int(book.currentPage)
            let totalPage = Int(book.totalPage)
            let percent = Int(book.percent)   

            var progressValue: Float = 0.0
            var progressText: String = ""

            // 페이지 기반 진행률 (totalPage가 0보다 클 때만)
            if totalPage > 0 {
                progressValue = Float(currentPage) / Float(totalPage)
                progressText = "\(currentPage)/\(totalPage) P"
            } else {
                // 퍼센트 기반 진행률 (0~100 사이 보정)
                let clamped = max(0, min(percent, 100))
                progressValue = Float(clamped) / 100.0
                progressText = "\(clamped)%"
            }

            cell.progressBar.progress = progressValue
            cell.percentLabel.text = progressText

            
            cell.onJournalButtonTapped = { [weak self] in
                let vc = JournalViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        
        // 기존 섹션 썸네일 셀
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ThumbnailCell.identifier,
            for: indexPath
        ) as! ThumbnailCell
        
        let book: Book
        
        if collectionView == plannedCollectionView {
            book = plannedBooks[indexPath.item]
        } else if collectionView == pausedCollectionView {
            book = pausedBooks[indexPath.item]
        } else {
            book = finishedBooks[indexPath.item]
        }
        
        if let data = book.coverImage,
           let img = UIImage(data: data) {
            cell.imageView.image = img
        }
        
        return cell
    }
    
    
    // 썸네일 클릭 -> 책 상세 화면 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let book: Book
        
        if collectionView == currentReadingCollectionView {
            book = currentReadingBooks[indexPath.item]
        } else if collectionView == plannedCollectionView {
            book = plannedBooks[indexPath.item]
        } else if collectionView == pausedCollectionView {
            book = pausedBooks[indexPath.item]
        } else {
            book = finishedBooks[indexPath.item]
        }
        
        let detailVC = BookDetailViewController()
        detailVC.book = book
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
