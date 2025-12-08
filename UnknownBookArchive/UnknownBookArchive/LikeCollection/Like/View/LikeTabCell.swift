// MARK: 좋아요 상단탭 컬렉션뷰셀

import Foundation
import UIKit
import SnapKit

final class LikeTabCell: UICollectionViewCell {
    static let id = "LikeTabCell"

    private let titleLabel = UILabel()

    // 라벨이 선택되면 폰트 스타일 변경
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected
            ? UIColor.primaryBlue800
            : UIColor.gray300
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.semiBoldFont(ofSize: 16)
        titleLabel.textColor = .gray300
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

