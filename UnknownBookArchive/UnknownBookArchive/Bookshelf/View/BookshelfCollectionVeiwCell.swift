import UIKit
import SnapKit

final class BookshelfCollectionVeiwCell: UICollectionViewCell {
    static let id = "BookshelfCollectionVeiwCell"
    
    private let imageView = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor(red: 0.90196, green: 0.90196, blue: 0.90196, alpha: 1.0).cgColor
        
        
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(imageView)
        
        // imageView.image = UIImage(systemName: "book")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray50
        imageView.layer.cornerRadius = 8
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with book: BookshelfBook) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        imageView.preferredSymbolConfiguration = config
        imageView.tintColor = .gray100
        imageView.contentMode = .center

        imageView.image = UIImage(systemName: "book.closed.fill")

        if let data = book.coverImageData,
           let image = UIImage(data: data) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    
    
}
