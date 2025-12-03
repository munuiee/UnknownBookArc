// MARK: 좋아요 상단탭에 따른 페이지 컬렉션뷰셀

import Foundation
import UIKit
import SnapKit

enum LikePageType {
    case likeParagraph    // 좋아요 한 문단 수집
    case likeBook         // 좋아요 한 책
}

class LikePageCell: UICollectionViewCell {
    static let id = "LikePageCell"
    
    // 임시코드
    private let placeholderLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        placeholderLabel.font = UIFont.regularFont(ofSize: 15)
        placeholderLabel.textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: LikePageType) {
        switch type {
        case .likeParagraph:
            placeholderLabel.text = "좋아요 한 문단 수집 페이지"
        case .likeBook:
            placeholderLabel.text = "좋아요 한 책 페이지"
        }
    }
}

