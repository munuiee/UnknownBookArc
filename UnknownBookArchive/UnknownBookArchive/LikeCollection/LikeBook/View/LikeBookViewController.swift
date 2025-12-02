import Foundation
import SnapKit
import UIKit

final class LikeBookViewController: UIViewController {
    
    private let viewModel = LikeBookViewModel()
    private var displayLikeBooks: [LikeBooks] = []
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionSetup()
        view.backgroundColor = UIColor(named: "backgroundColor")
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        // viewModel.loadLikeBooksData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchLikeBooks()
        collectionView.reloadData()
    }
    
    
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/3.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 20,
            bottom: 16,
            trailing: 20
        )
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    private func collectionSetup() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        collectionView.register(LikeBookCell.self, forCellWithReuseIdentifier: LikeBookCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
}

extension LikeBookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.likedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt:", indexPath.item)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeBookCell.id, for: indexPath) as? LikeBookCell else {
            return UICollectionViewCell()
        }
        
        //let book = SampleDataSource.books[indexPath.item]
        let book = viewModel.likedBooks[indexPath.item]
        cell.configure(with: book)
        
        cell.onLikeTapped = { [weak self, weak cell] in
            guard
                let self = self,
                let cell = cell,
                let indexPath = collectionView.indexPath(for: cell)
            else { return }
            
            self.viewModel.toggleLikeBook(at: indexPath.item)
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = viewModel.likedBooks[indexPath.item]
        let detailVC = BookDetailViewController(book: book)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
