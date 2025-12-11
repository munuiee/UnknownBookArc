// MARK: 저널 - 메인 컬렉션뷰

import Foundation
import SnapKit
import UIKit

final class JournalViewController: UIViewController {
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let book: Book
    private let viewModel: JournalViewModel
    
    init(book: Book) {
        self.book = book
        self.viewModel = JournalViewModel(book: book)
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var paragraphViewController = ParagraphViewController(book: book)
    private lazy var momentViewController = MomentViewController(book: book)
    
    private let bookTitle = UILabel()
    private let addButton = UIButton(type: .system)
    private let topView = UIView()
    private let backButton = UIButton(type: .system)
    
    // 탭을 눌러서 스크롤 중인지 여부
    private var isTabScrolling = false
    // 현재 페이지 인덱스는 VC가 직접 관리
    private var currentPageIndex: Int = 0
    
    
    
    
    // MARK: - 탭바
    private lazy var tabCollectionView: UICollectionView = {
        let layout = makeMenuLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundModeColor
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(JournalTabCell.self,
                    forCellWithReuseIdentifier: JournalTabCell.id)
        return cv
    }()
    
    // MARK: - 페이지
    private lazy var contentCollectionView: UICollectionView = {
        let layout = makeContentLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundModeColor
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceVertical = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(JournalPageCell.self,
                    forCellWithReuseIdentifier: JournalPageCell.id)
        return cv
    }()
    
    // MARK: - 인디케이터
    private let indicatorView: UIView = {
        let indicate = UIView()
        indicate.backgroundColor = UIColor.recordTabSelectedBarBackgroundColor
        return indicate
    }()
    
    // 배경 인디케이터
    private let bottomLineView: UIView = {
        let bottom = UIView()
        bottom.backgroundColor = UIColor.recordTabUnselectedFillColor.withAlphaComponent(0.4)
        return bottom
    }()
    
    private var indicatorLeadingConstraint: Constraint?
    private var indicatorWidthConstraint: Constraint?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundModeColor
        
        setupUI()
        bindViewModel()
        setupInitialSelection()
        viewModel.fetchJournalRecords()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        // 페이지 변경(onPageChanged)은 VC가 직접 관리하므로 여기서는 편집 버튼만 연결
        viewModel.didTapEdit = { [weak self] in
            guard let self = self else { return }
            
            
            let editVC = JournalEditViewController(journal: nil, book: self.book, type: "문단 수집")
            
            if let nav = self.navigationController {
                nav.pushViewController(editVC, animated: true)
            } else {
                self.present(editVC, animated: true)
            }
        }
    }
    
    // MARK: - UI 세팅
    
    private func setupUI() {
        
        bookTitle.text = book.title ?? ""
        bookTitle.textAlignment = .center
        bookTitle.font = UIFont.semiBoldFont(ofSize: 18)
        bookTitle.textColor = UIColor.topColor
        
        let addConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let addImage = UIImage(systemName: "plus", withConfiguration: addConfig)
        addButton.setImage(addImage, for: .normal)
        addButton.tintColor = .topColor
        addButton.sizeToFit()
        addButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        let backConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .topColor
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        [backButton, bookTitle, addButton]
            .forEach { topView.addSubview($0) }
        view.addSubview(topView)
        
        [tabCollectionView, contentCollectionView, bottomLineView, indicatorView]
            .forEach { view.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
            
        }
        
        bookTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.equalTo(290)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(25)
        }
        
        tabCollectionView.snp.makeConstraints {
            $0.top.equalTo(bookTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        contentCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        indicatorView.snp.makeConstraints {
            $0.centerY.equalTo(bottomLineView.snp.centerY)
            $0.height.equalTo(bottomLineView.snp.height)
            indicatorLeadingConstraint = $0.leading.equalTo(bottomLineView.snp.leading).constraint
            indicatorWidthConstraint = $0.width.equalTo(0).constraint
        }
    }
    
    // MARK: - 초기 선택
    
    private func setupInitialSelection() {
        let indexPath = IndexPath(item: 0, section: 0)
        
        tabCollectionView.selectItem(at: indexPath,
                                     animated: false,
                                     scrollPosition: [])
        currentPageIndex = 0
        
        DispatchQueue.main.async {
            self.updateIndicator(for: 0, animated: false)
            self.addButtonVisibility(for: 0)
        }
    }
    
    // MARK: - 페이지 변경 공통 함수
    
    /// 페이지 변경은 이 함수 하나를 통해서만 처리
    private func changePage(to index: Int,
                            animated: Bool,
                            fromScroll: Bool) {
        guard index != currentPageIndex else { return }   // 같은 페이지면 무시
        
        currentPageIndex = index
        
        let indexPath = IndexPath(item: index, section: 0)
        
        // 탭 선택 동기화
        tabCollectionView.selectItem(at: indexPath,
                                     animated: animated,
                                     scrollPosition: [])
        
        // 인디케이터 & 버튼 상태
        updateIndicator(for: index, animated: animated)
        addButtonVisibility(for: index)
        
        // 스크롤 제스처가 아니라 탭 클릭으로 바뀐 경우에만 content 스크롤
        if !fromScroll {
            isTabScrolling = true
            contentCollectionView.scrollToItem(at: indexPath,
                                               at: .centeredHorizontally,
                                               animated: animated)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.isTabScrolling = false
            }
        }
    }
    
    // MARK: - 인디케이터 이동
    
    private func updateIndicator(for index: Int, animated: Bool = true) {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = tabCollectionView.cellForItem(at: indexPath) else { return }
        
        tabCollectionView.layoutIfNeeded()
        let cellFrame = cell.frame
        
        let indicatorWidth = cellFrame.width * 1.0
        let leading = cellFrame.minX + (cellFrame.width - indicatorWidth) / 2
        
        indicatorLeadingConstraint?.update(offset: leading)
        indicatorWidthConstraint?.update(offset: indicatorWidth)
        
        let animations = {
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.35,
                           animations: animations)
        } else {
            animations()
        }
    }
    
    private func addButtonVisibility(for index: Int) {
        let isParagraphTab = (index == 0)
        addButton.isHidden = !isParagraphTab
    }
    
    @objc private func didTapEditButton() {
        viewModel.editButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 레이아웃

extension JournalViewController {
    
    private func makeMenuLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(viewModel.numberOfTabs)),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .zero
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section,
                                                         configuration: config)
        return layout
    }
    
    // 페이지 레이아웃
    private func makeContentLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .zero
        
        // 가로 방향 페이지 스크롤
        section.orthogonalScrollingBehavior = .groupPaging
        
        // 탭/인디케이터 동기화
        section.visibleItemsInvalidationHandler = { [weak self] items, offset, environment in
            guard let self = self else { return }
            guard !items.isEmpty else { return }
            
            // 탭을 눌러서 강제 스크롤 중이면 무시
            if self.isTabScrolling { return }
            
            // contentCollectionView의 실제 width 기준으로 페이지 계산
            let width = self.contentCollectionView.bounds.width
            guard width > 0 else { return }
            
            let progress = offset.x / width
            var pageIndex = Int(round(progress))
            
            pageIndex = max(0, min(self.viewModel.numberOfTabs - 1, pageIndex))
            
            // 스크롤 제스처로 페이지 변경
            self.changePage(to: pageIndex,
                            animated: true,
                            fromScroll: true)
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section,
                                                         configuration: config)
        return layout
    }
}

// MARK: - CollectionView Delegate/DataSource

extension JournalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfTabs
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tabCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: JournalTabCell.id,
                for: indexPath
            ) as? JournalTabCell else { return .init() }
            
            let title = viewModel.titleForTab(index: indexPath.item)
            cell.configure(title: title)
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: JournalPageCell.id,
                for: indexPath
            ) as? JournalPageCell else {
                return UICollectionViewCell()
            }
            
            // 남아 있는 이전 뷰 제거
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            let childVC: UIViewController
            if indexPath.item == 0 {
                childVC = paragraphViewController
            } else {
                childVC = momentViewController
            }
            
            if childVC.parent == nil {
                addChild(childVC)
                childVC.didMove(toParent: self)
            }
            
            cell.contentView.addSubview(childVC.view)
            childVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        view.window?.endEditing(true)
        if collectionView == tabCollectionView {
            // 탭을 눌러서 페이지 변경
            changePage(to: indexPath.item,
                       animated: true,
                       fromScroll: false)
        }
    }
}
