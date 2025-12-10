import Foundation
import UIKit
import SnapKit

final class ParagraphView: UIView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        collectionSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func collectionSet() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalToSuperview().offset(36)
        }
        collectionView.backgroundColor = .backgroundModeColor
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
