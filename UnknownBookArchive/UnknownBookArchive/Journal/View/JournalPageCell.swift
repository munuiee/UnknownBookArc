import Foundation
import UIKit
import SnapKit

enum JournalPageType {
    case paragraph    // 문단 수집
    case moment       // 찰나의 기록
}

class JournalPageCell: UICollectionViewCell {
    static let id = "JournalPageCell"

    // 임시코드
    private let placeholderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        placeholderLabel.font = .systemFont(ofSize: 15)
        placeholderLabel.textColor = .darkGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(type: JournalPageType) {
        switch type {
        case .paragraph:
            placeholderLabel.text = "문단 수집 페이지"
        case .moment:
            placeholderLabel.text = "찰나의 기록 페이지"
        }
    }
}

