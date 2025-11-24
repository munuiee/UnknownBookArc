// MARK: - 저널: 문단 수집

import Foundation
import UIKit
import SnapKit

final class ParagraphViewController: UIViewController {
    
    private let viewModel = ParagraphListViewModel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionSet()
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.fetchParagraphs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchParagraphs()
    }
    
    private func collectionSet() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ParagraphCardCell.self, forCellWithReuseIdentifier: ParagraphCardCell.id)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview().offset(36)
        }
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
}

extension ParagraphViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParagraphCardCell.id, for: indexPath) as? ParagraphCardCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(
            page: viewModel.page(at: indexPath),
            text: viewModel.text(at: indexPath),
            dateText: viewModel.dateText(at: indexPath),
            liked: viewModel.liked(at: indexPath)
        )
        return cell
    }
}
