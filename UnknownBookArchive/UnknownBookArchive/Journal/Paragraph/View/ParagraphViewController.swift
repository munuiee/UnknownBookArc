// MARK: - 저널: 문단 수집

import Foundation
import UIKit
import SnapKit

final class ParagraphViewController: UIViewController {
    
    private let viewModel: ParagraphListViewModel
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    private let book: Book
    
    init(book: Book) {
        self.book = book
        self.viewModel = ParagraphListViewModel(book: book)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionSet()
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.fetchParagraphs()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchParagraphs()
        collectionView.reloadData()
    }


    
    private func collectionSet() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ParagraphCardCell.self, forCellWithReuseIdentifier: ParagraphCardCell.id)
        collectionView.layer.borderColor = UIColor.colorE6E6E6.cgColor
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview().offset(36)
        }
        collectionView.backgroundColor = .white
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


// MARK: 문단 수집 수정 및 삭제
extension ParagraphViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParagraphCardCell.id, for: indexPath) as? ParagraphCardCell else {
            return UICollectionViewCell()
        }
        
        let journal = viewModel.journal(at: indexPath)
        
        cell.onEditTapped = { [weak self] in
            guard let self = self else { return }
                        
            let editVC = JournalEditViewController(journal: journal, book: self.book, type: "문단 수집")
            editVC.journal = journal
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        
        cell.onDeleteTapped = { [weak self] in
            guard let self = self else { return }
            
            let alert = UIAlertController(title: "문단 삭제", message: "이 문단을 삭제할까요?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.viewModel.delete(at: indexPath)
            })
            self.present(alert, animated: true)
        }
        
        cell.onLikeTapped = { [weak self, weak cell] in
            guard
                let self = self,
                let cell = cell,
                let indexPath = collectionView.indexPath(for: cell)
            else { return }
            
            self.viewModel.toggleLike(at: indexPath.item)
            self.collectionView.reloadItems(at: [indexPath])
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
