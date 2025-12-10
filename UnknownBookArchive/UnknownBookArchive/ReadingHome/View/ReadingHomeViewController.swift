// MARK: 메인화면

import UIKit
import SnapKit
import RxSwift

final class ReadingHomeViewController: UIViewController {
    
    private let viewModel = ReadingHomeViewModel()
    private let disposeBag = DisposeBag()
    
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
    
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // 스크롤시 네비게이션바 뜨는 현상 제거
        if let navBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.shadowColor = .clear
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.compactAppearance = appearance
        }

        scrollView.contentInset.bottom = 20
        
        setupUI()
        setupCollectionViews()
        setupHierarchy()
        setupConstraints()
        bindViewModel()
        applyInitialSpacing()
        
        addBookButton.addTarget(self, action: #selector(didTapAddBook), for: .touchUpInside)
        
        viewModel.loadInitialData()
        
        // MARK: - Notification 기반
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bookUpdated),
            name: .bookUpdated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bookUpdated),
            name: .bookDeleted,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        iCloudAlert()
    }
    
    // MARK: 아이클라우드 알럿
    private func iCloudAlert() {
        let key = "didShowICloudAlert"

        if UserDefaults.standard.bool(forKey: key) {
            return
        }
  
        let alert = UIAlertController(
            title: "📢 iCloud 동기화 안내",
            message: """
            이 앱은 독서 기록을 iCloud에 저장해
            기기 간에 자동으로 동기화합니다.
            같은 계정으로 로그인된 기기에서
            언제든 이어서 보실 수 있어요.
            """,
            preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            UserDefaults.standard.set(true, forKey: key)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    // MARK: - Notification 받으면 UI 갱신
    @objc private func bookUpdated() {
        viewModel.reloadFromCoreData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    
        viewModel.reloadFromCoreData()
    }
    
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
        }
    }
    func scrollToTop() {
        // contentInset 고려해서 맨 위로
        let topOffset = CGPoint(x: 0, y: -scrollView.adjustedContentInset.top)
        scrollView.setContentOffset(topOffset, animated: true)
    }
    
    // MARK: - UI 업데이트
    private func updateUI() {
        let model = viewModel.model
        
        currentReadingBooks = Array(model.currentReadingBooks.prefix(10))
        
        plannedBooks = Array(model.plannedBooks.prefix(10))
        pausedBooks = Array(model.pausedBooks.prefix(10))
        finishedBooks = Array(model.finishedBooks.prefix(10))
        
        // 책 개수가 10권을 초과할 때만 더보기 버튼 보이기
        greetingMoreButton.isHidden = model.currentReadingBooks.count <= 10
        plannedMoreButton.isHidden = model.plannedBooks.count <= 10
        pausedMoreButton.isHidden = model.pausedBooks.count <= 10
        finishedMoreButton.isHidden = model.finishedBooks.count <= 10
        
        updateCurrentReadingCardUI()
        updateSectionVisibility()
        updateDynamicSpacing()
        
        currentReadingCollectionView.reloadData()
        plannedCollectionView.reloadData()
        pausedCollectionView.reloadData()
        finishedCollectionView.reloadData()
        
        if !currentReadingBooks.isEmpty {
            let firstItemIndexPath = IndexPath(item: 0, section: 0)
            DispatchQueue.main.async { [weak self] in
                self?.currentReadingCollectionView.scrollToItem(
                    at: firstItemIndexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
        }
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
        
        contentStackView.setCustomSpacing(plannedBooks.isEmpty ? 20 : 0, after: plannedHeader)
        contentStackView.setCustomSpacing(40, after: plannedEmptyCard)
        contentStackView.setCustomSpacing(16, after: plannedCollectionView)
        
        contentStackView.setCustomSpacing(pausedBooks.isEmpty ? 20 : 0, after: pausedHeader)
        contentStackView.setCustomSpacing(40, after: pausedEmptyCard)
        contentStackView.setCustomSpacing(40, after: pausedCollectionView)
        
        contentStackView.setCustomSpacing(finishedBooks.isEmpty ? 20 : 0, after: finishedHeader)
        contentStackView.setCustomSpacing(60, after: finishedEmptyCard)
        contentStackView.setCustomSpacing(60, after: finishedCollectionView)
    }
    
    
    @objc private func didTapAddBook() {
        let searchVC = BookSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let layer = greetingSectionView.layer
        
        layer.cornerRadius = 12
        layer.masksToBounds = false

        layer.shadowColor = UIColor(red: 0.102, green: 0.098, blue: 0.098, alpha: 0.12).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 0)
        

    }
    
    // MARK: - 기본 UI 설정
    private func setupUI() {
        
        let text = "책방지기님,\n독서하기 좋은 날이네요."
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 6
        
        greetingLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.semiBoldFont(ofSize: 20),
                .paragraphStyle: paragraph
            ]
        )
        
        greetingMoreButton.setTitle("더보기", for: .normal)
        greetingMoreButton.setTitleColor(UIColor(red: 0.161, green: 0.290, blue: 0.659, alpha: 1.0), for: .normal)
        greetingMoreButton.titleLabel?.font = UIFont.mediumFont(ofSize: 12)
        greetingMoreButton.addTarget(self, action: #selector(didTapCurrentMore), for: .touchUpInside)
        
        
        greetingLabel.numberOfLines = 0
        greetingLabel.textColor = .black
        
        greetingSectionView.backgroundColor = .primaryBlue100
        greetingSectionView.layer.cornerRadius = 12
        greetingSectionView.clipsToBounds = true
        
        
        currentReadingCardView.backgroundColor = .white
        currentReadingCardView.layer.cornerRadius = 8
        
        currentReadingCardTitleLabel.text = "읽고 있는 책을 추가해보세요"
        currentReadingCardTitleLabel.font = UIFont.semiBoldFont(ofSize: 16)
        currentReadingCardTitleLabel.textAlignment = .center
        
        currentReadingCardSubtitleLabel.text = "현재 읽고 있는 책이 여기에 표시돼요"
        currentReadingCardSubtitleLabel.font = UIFont.regularFont(ofSize: 14)
        currentReadingCardSubtitleLabel.textAlignment = .center
        currentReadingCardSubtitleLabel.textColor = .lightGray
        
        
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
            button.titleLabel?.font = UIFont.mediumFont(ofSize: 12)
        }
        styleMore(plannedMoreButton)
        styleMore(pausedMoreButton)
        styleMore(finishedMoreButton)
        
        
        addBookButton.setTitle("책 추가하기", for: .normal)
        addBookButton.layer.cornerRadius = 8
        addBookButton.backgroundColor = .primaryBlue800
        addBookButton.setTitleColor(.white, for: .normal)
        addBookButton.titleLabel?.font = UIFont.semiBoldFont(ofSize: 18)

        
        func styleCard(_ card: UIView, _ label: UILabel, _ text: String) {
            card.backgroundColor = UIColor(named: "gray50")
            card.layer.cornerRadius = 8
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1.0).cgColor

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
        
        currentReadingCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCurrentReadingLayout()
        )
        currentReadingCollectionView.backgroundColor = .clear
        currentReadingCollectionView.showsHorizontalScrollIndicator = false
        currentReadingCollectionView.dataSource = self
        currentReadingCollectionView.delegate = self
        
        currentReadingCollectionView.alwaysBounceVertical = false
        currentReadingCollectionView.isScrollEnabled = true
        
        currentReadingCollectionView.register(
            CurrentReadingCell.self,
            forCellWithReuseIdentifier: CurrentReadingCell.identifier
        )
        currentReadingCollectionView.isHidden = true
        
        
        plannedMoreButton.addTarget(self,
                                    action: #selector(didTapPlannedMore),
                                    for: .touchUpInside)
        
        pausedMoreButton.addTarget(self,
                                   action: #selector(didTapPausedMore),
                                   for: .touchUpInside)
        
        finishedMoreButton.addTarget(self,
                                     action: #selector(didTapFinishedMore),
                                     for: .touchUpInside)
        
        
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
        
        currentReadingEmptyStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        currentReadingCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
            $0.height.equalTo(180)
        }
        
        contentStackView.addArrangedSubview(addBookButton)
        
        
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
        
        topGap.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
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
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
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
            $0.height.equalTo(180)
            $0.bottom.equalTo(greetingSectionView.snp.bottom).offset(-16)
        }
        
        addBookButton.snp.makeConstraints {
            $0.top.equalTo(greetingSectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
    
    
    // MARK: - 더보기 버튼 액션들
    @objc private func didTapCurrentMore() {
        let vc = BookListMoreViewController()
        vc.listTitle = "읽는 중인 책"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapPlannedMore() {
        let vc = BookListMoreViewController()
        vc.listTitle = "읽을 예정인 책"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapPausedMore() {
        let vc = BookListMoreViewController()
        vc.listTitle = "잠시 멈춘 책"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapFinishedMore() {
        let vc = BookListMoreViewController()
        vc.listTitle = "완독한 책"
        navigationController?.pushViewController(vc, animated: true)
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

}

//
// MARK: - extension
//
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
        
        if collectionView == currentReadingCollectionView {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrentReadingCell.identifier,
                for: indexPath
            ) as! CurrentReadingCell
            
            let book = currentReadingBooks[indexPath.item]
            
            cell.configure(with: book)
            
//            cell.titleLabel.text = book.title
//            cell.authorLabel.text = book.author
//            
//            if let imgData = book.coverImage,
//               let image = UIImage(data: imgData) {
//                cell.thumbnailImageView.image = image
//            }
//            
//            if let startDate = book.startDate {
//                let df = DateFormatter()
//                df.dateFormat = "yyyy.MM.dd"
//                cell.dateLabel.text = df.string(from: startDate)
//            }
//            
//            let currentPage = Int(book.currentPage)
//            let totalPage = Int(book.totalPage)
//            let percent = Int(book.percent)
//            
//            if totalPage > 0 {
//                cell.progressBar.progress = Float(currentPage) / Float(totalPage)
//                cell.percentLabel.text = "\(currentPage)/\(totalPage) P"
//                
//            } else {
//                let clamped = max(0, min(percent, 100))
//                cell.progressBar.progress = Float(clamped) / 100
//                cell.percentLabel.text = "\(clamped)%"
//            }
            
            cell.onJournalButtonTapped = { [weak self] in
                let vc = JournalViewController(book: book)

                vc.hidesBottomBarWhenPushed = true

                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.onProgressEditTapped = { [weak self, weak cell] bookToEdit in
                let editVC = ProgressEditViewController(book: bookToEdit)
                let navigationController = UINavigationController(rootViewController: editVC)
                    navigationController.modalPresentationStyle = .pageSheet
                    if let sheet = navigationController.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                    }
                editVC.completion = { [weak self, weak cell] updatedBook in
                    cell?.configure(with: updatedBook)
                    if let index = self?.currentReadingBooks.firstIndex(where: { $0.uuid == updatedBook.uuid }) {
                                self?.currentReadingBooks[index] = updatedBook
                            }
                        }
                self?.present(navigationController, animated: true)
            }
            return cell
        }
        
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
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
        
        let detailVC = BookDetailViewController(book: book)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
