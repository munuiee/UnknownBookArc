import Foundation
import UIKit
import SnapKit

final class JournalTabCell: UICollectionViewCell {
    static let id = "JournalTabCell"

    private let titleLabel = UILabel()

    // 라벨이 선택되면 폰트 스타일 변경
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected
            ? .boldSystemFont(ofSize: 16)
            : .systemFont(ofSize: 16)
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

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

