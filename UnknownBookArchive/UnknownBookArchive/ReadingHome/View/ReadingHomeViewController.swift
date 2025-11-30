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
        
        bindViewModel()
        viewModel.loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadFromCoreData()
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            print("onUpdate 실행됨")
            self?.updateUI()
        }
    }
    
    
    // MARK: - UI 업데이트
    private func updateUI() {
        let model = viewModel.model
        
        plannedBooks = Array(model.plannedBooks.prefix(10))
        pausedBooks = Array(model.pausedBooks.prefix(10))
        finishedBooks = Array(model.finishedBooks.prefix(10))
        
        updateSectionVisibility()
        updateDynamicSpacing()
        
        plannedCollectionView.reloadData()
        pausedCollectionView.reloadData()
        finishedCollectionView.reloadData()
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
        if plannedBooks.isEmpty {
            contentStackView.setCustomSpacing(20, after: plannedHeader)      // 제목 <-> emptyCard
        } else {
            contentStackView.setCustomSpacing(0, after: plannedHeader)       // 제목 <-> 컬렉션뷰 (붙이기)
        }
        contentStackView.setCustomSpacing(40, after: plannedEmptyCard)
        contentStackView.setCustomSpacing(16, after: plannedCollectionView)
        
        
        // 잠시 멈춘 책
        if pausedBooks.isEmpty {
            contentStackView.setCustomSpacing(20, after: pausedHeader)
        } else {
            contentStackView.setCustomSpacing(0, after: pausedHeader)
        }
        contentStackView.setCustomSpacing(40, after: pausedEmptyCard)
        contentStackView.setCustomSpacing(40, after: pausedCollectionView)
        
        
        // 완독한 책
        if finishedBooks.isEmpty {
            contentStackView.setCustomSpacing(20, after: finishedHeader)
        } else {
            contentStackView.setCustomSpacing(0, after: finishedHeader)
        }
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
        greetingLabel.numberOfLines = 0
        greetingLabel.textColor = .black
        
        greetingSectionView.backgroundColor = .readinHomeBannerColor
        greetingSectionView.layer.cornerRadius = 8
        
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
        
        addBookButton.setTitle("책 추가하기", for: .normal)
        addBookButton.layer.cornerRadius = 8
        addBookButton.backgroundColor = .addBookButtonColor
        addBookButton.setTitleColor(.white, for: .normal)
        
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
        
        // 데이터 없을 때는 collectionView 숨기기
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
        contentStackView.addArrangedSubview(greetingSectionView)
        
        let cardStack = UIStackView(arrangedSubviews: [
            currentReadingCardTitleLabel,
            currentReadingCardSubtitleLabel
        ])
        cardStack.axis = .vertical
        cardStack.alignment = .center
        currentReadingCardView.addSubview(cardStack)
        
        cardStack.snp.makeConstraints { $0.center.equalToSuperview() }
        
       
        contentStackView.addArrangedSubview(addBookButton)
        
        
        // 섹션 생성 (header를 반환)
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
        
    }
    
    
    // MARK: - 섹션 생성 함수 (제목 + 더보기 + 카드/컬렉션뷰)
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
        
        addBookButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}


// MARK: - 썸네일 셀
final class ThumbnailCell: UICollectionViewCell {
    
    static let identifier = "ThumbnailCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - CollectionView DataSource
extension ReadingHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == plannedCollectionView { return plannedBooks.count }
        if collectionView == pausedCollectionView { return pausedBooks.count }
        return finishedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        } else {
            cell.imageView.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let book: Book
        
        if collectionView == plannedCollectionView {
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


