import Foundation
import SnapKit
import UIKit

final class JournalViewController: UIViewController {
    
    private let viewModel = JournalViewModel()

    private let bookTitle = UILabel()
    private let addButton = UIButton(type: .system)
    private let topView = UIView()
    private let backButton = UIButton(type: .system)
    private var isTabScrolling = false


    // MARK: - 탭바
    private lazy var tabCollectionView: UICollectionView = {
        let layout = makeMenuLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
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
        cv.backgroundColor = .white
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


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        bindViewModel()
        setupInitialSelection()
    }
    
    private func bindViewModel() {
        viewModel.onPageChanged = { [weak self] pageIndex in
            print("🌀 onPageChanged 콜백: \(pageIndex)")
            guard let self = self else { return }
            
            let indexPath = IndexPath(item: pageIndex, section: 0)
            
            // 탭 선택
            self.tabCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            
            // 페이지 스크롤
            self.contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            // 인디케이터 이동
            self.updateIndicator(for: pageIndex)
        }
    }

    
    // MARK: - UI 세팅
    private func setupUI() {
        bookTitle.text = "책 제목"
        bookTitle.font = .boldSystemFont(ofSize: 18)

        let addConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let addImage = UIImage(systemName: "plus", withConfiguration: addConfig)
        addButton.setImage(addImage, for: .normal)
        addButton.tintColor = .black
        addButton.sizeToFit()

        let backConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .black
        backButton.sizeToFit()

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

    // 처음에 0번째 탭 선택 + 인디케이터 세팅
    private func setupInitialSelection() {
        let indexPath = IndexPath(item: 0, section: 0)

        tabCollectionView.selectItem(at: indexPath,
                                     animated: false,
                                     scrollPosition: [])
        viewModel.setPage(index: 0)
        
        DispatchQueue.main.async {
            self.updateIndicator(for: 0)
        }
    }

    
    // MARK: - 인디케이터 이동

    private func updateIndicator(for index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = tabCollectionView.cellForItem(at: indexPath) else { return }
        
        tabCollectionView.layoutIfNeeded()
        let cellFrame = cell.frame
        
        let indicatorWidth = cellFrame.width * 1.0
        let leading = cellFrame.minX + (cellFrame.width - indicatorWidth) / 2

        indicatorLeadingConstraint?.update(offset: leading)
        indicatorWidthConstraint?.update(offset: indicatorWidth)
        
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }


}



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
            widthDimension: .fractionalWidth(0.9999),
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
            
            //guard self.contentCollectionView.isDragging || self.contentCollectionView.isDecelerating else { return }
            
            if self.isTabScrolling {
                return
            }
            
            let containerWidth = environment.container.effectiveContentSize.width
            guard containerWidth > 0 else { return }

            let visibleCenterX = offset.x + containerWidth / 2

            let sorted = items.sorted {
                abs($0.frame.midX - visibleCenterX) < abs($1.frame.midX - visibleCenterX)
            }

            guard let currentItem = sorted.first else { return }
            let pageIndex = currentItem.indexPath.item

            self.viewModel.setPage(index: pageIndex)

        }

        // 메인 스크롤 방향은 세로, 페이지는 가로 스크롤
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical

        let layout = UICollectionViewCompositionalLayout(section: section,
                                                         configuration: config)
        return layout
    }
}


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
            ) as? JournalPageCell else { return .init() }

            if indexPath.item == 0 {
                cell.configure(type: .paragraph)
            } else {
                cell.configure(type: .moment)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        if collectionView == tabCollectionView {
            isTabScrolling = true
            viewModel.setPage(index: indexPath.item)
            
            contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self ] in
                self?.isTabScrolling = false
            }
        }
    }
}
