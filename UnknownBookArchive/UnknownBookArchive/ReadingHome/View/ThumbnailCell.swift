//
//  Thumbnail.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 12/1/25.
//

import UIKit
import SnapKit

final class ThumbnailCell: UICollectionViewCell {
    
    static let identifier = "ThumbnailCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
