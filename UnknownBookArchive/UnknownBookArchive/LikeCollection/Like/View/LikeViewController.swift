// MARK: - 좋아요: 메인 컬렉션뷰

import Foundation
import SnapKit
import UIKit

final class LikeViewController: UIViewController {
    private let viewModel = LikeViewModel()
    
    private lazy var LikeParagraphVC = LikeParagraphViewController()
    private lazy var LikeBookVC = LikeBookViewController()
    
    private let likeTitle = UILabel()
    private let topView = UIView()
    
    
    
    
    // 탭을 눌러서 스크롤 중인지 여부
    private var isTabScrolling = false
    // 현재 페이지 인덱스는 VC가 직접 관리
    private var currentPageIndex: Int = 0
    
    // MARK: - 탭바
    private lazy var tabCollectionView: UICollectionView = {
        let layout = makeMenuLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(LikeTabCell.self,
                    forCellWithReuseIdentifier: LikeTabCell.id)
        return cv
    }()
    
    // MARK: - 페이지
    private lazy var contentCollectionView: UICollectionView = {
        let layout = makeContentLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceVertical = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(LikePageCell.self,
                    forCellWithReuseIdentifier: LikePageCell.id)
        return cv
    }()
    
    // MARK: - 인디케이터
    private let indicatorView: UIView = {
        let indicate = UIView()
        indicate.backgroundColor = .black
        return indicate
    }()
    
    // 배경 인디케이터
    private let bottomLineView: UIView = {
        let bottom = UIView()
        bottom.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return bottom
    }()
    
    private var indicatorLeadingConstraint: Constraint?
    private var indicatorWidthConstraint: Constraint?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupInitialSelection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    // MARK: - UI 세팅
    
    private func setupUI() {
        likeTitle.text = "좋아요"
        likeTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        view.addSubview(topView)
        topView.addSubview(likeTitle)
        
        [tabCollectionView, contentCollectionView, bottomLineView, indicatorView]
            .forEach { view.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        
        
        likeTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        
        tabCollectionView.snp.makeConstraints {
            $0.top.equalTo(likeTitle.snp.bottom).offset(8)
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
        }
    }
    
    // MARK: - 페이지 변경 공통 함수
    
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
    
    
    
}

// MARK: - 레이아웃

extension LikeViewController {
    
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
        
        // 메인 스크롤 방향은 세로, 페이지는 가로 스크롤
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section,
                                                         configuration: config)
        return layout
    }
}

// MARK: - CollectionView Delegate/DataSource

extension LikeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
                withReuseIdentifier: LikeTabCell.id,
                for: indexPath
            ) as? LikeTabCell else { return .init() }
            
            let title = viewModel.titleForTab(index: indexPath.item)
            cell.configure(title: title)
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LikePageCell.id,
                for: indexPath
            ) as? LikePageCell else {
                return UICollectionViewCell()
            }
            
            // 혹시 남아 있는 이전 뷰 제거
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            let childVC: UIViewController
            if indexPath.item == 0 {
                childVC = LikeParagraphVC
            } else {
                childVC = LikeBookVC
            }
            
            if childVC.parent == nil {
                addChild(childVC)
                childVC.didMove(toParent: self)
            }
            
            cell.contentView.addSubview(childVC.view)
            childVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
            
            return cell
        }
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
