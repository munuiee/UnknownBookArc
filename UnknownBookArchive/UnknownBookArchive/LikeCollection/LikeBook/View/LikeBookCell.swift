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
        contentView.layer.borderColor = UIColor(red: 0.90196, green: 0.90196, blue: 0.90196, alpha: 1.0).cgColor
        
        
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(imageView)
        
        imageView.image = UIImage(systemName: "book")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with book: Book) {
        imageView.image = UIImage(systemName: "book")

           // 그 다음 커버 이미지가 있으면 덮어쓰기
           if let data = book.coverImage,
              let image = UIImage(data: data) {
               imageView.image = image
           }
    }
    
    
    
}
