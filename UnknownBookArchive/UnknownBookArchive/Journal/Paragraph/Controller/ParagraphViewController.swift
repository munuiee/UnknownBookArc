// MARK: - 저널: 문단 수집

import Foundation
import UIKit
import SnapKit

final class ParagraphViewController: UIViewController {
    private let paragraphView = ParagraphView()
    private let viewModel: ParagraphListViewModel
    private let book: Book
    
    init(book: Book) {
        self.book = book
        self.viewModel = ParagraphListViewModel(book: book)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = paragraphView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        paragraphView.collectionView.delegate = self
        paragraphView.collectionView.dataSource = self
        viewModel.onUpdate = { [weak self] in
            self?.paragraphView.collectionView.reloadData()
        }
        viewModel.fetchParagraphs()
        paragraphView.collectionView.register(ParagraphCardCell.self, forCellWithReuseIdentifier: ParagraphCardCell.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchParagraphs()
        paragraphView.collectionView.reloadData()
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
            self.paragraphView.collectionView.reloadItems(at: [indexPath])
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
