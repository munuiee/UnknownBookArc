// MARK: 좋아요 한 책 컬렉션뷰셀

import Foundation
import UIKit
import SnapKit

final class LikeBookCell: UICollectionViewCell {
    static let id = "LikeBookCell"
    
    private let imageView = UIImageView()
    
    var onLikeTapped: (() -> Void)?
    
    
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
        contentView.dynamicBorder = UIColor.thumbnailBorderColor
        
        
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(imageView)
        
        // imageView.image = UIImage(systemName: "book")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .thumbnailBackgroundColor
        imageView.layer.cornerRadius = 8
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with book: Book) {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        imageView.preferredSymbolConfiguration = config
        imageView.tintColor = .thumbnailBackgroundColor
        imageView.contentMode = .center    // 아이콘 중앙 배치

        imageView.image = UIImage(systemName: "book.closed.fill")

        if let data = book.coverImage,
           let image = UIImage(data: data) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill   // 실제 커버 이미지 들어오면 다시 fill
        }
    }
    
    
    
}
