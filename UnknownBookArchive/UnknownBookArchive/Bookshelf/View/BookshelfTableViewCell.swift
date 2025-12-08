// MARK: 책장 테이블뷰셀

import UIKit
import SnapKit


class PaddingLabel: UILabel {
    var inset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + inset.left + inset.right,
            height: size.height + inset.top + inset.bottom
        )
    }
}

final class BookshelfTableViewCell: UITableViewCell {

    static let identifier = "BookshelfTableViewCell"

    // 카드 뷰
    private let cardView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.primaryBlue50.cgColor
            return view
        }()

    // 책 표지
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.primaryBlue50.cgColor
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBoldFont(ofSize: 18)
        label.textColor = .primaryBlue900
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    // 저자
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumFont(ofSize: 14)
        label.textColor = .gray500
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    // 독서 상태 라벨
    private let stateLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.inset = UIEdgeInsets(top: 4, left: 11.5, bottom: 4, right: 11.5)
        label.font = .mediumFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textColor = .gray500
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(authorLabel)
        cardView.addSubview(stateLabel)
    }

    private func setupConstraints() {
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(cardView).offset(8)
            $0.leading.equalTo(cardView).offset(8)
            $0.width.equalTo(73)
            $0.height.equalTo(108)
            $0.bottom.lessThanOrEqualTo(cardView).inset(8)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(cardView).inset(8)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
        }

        stateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(32)
            $0.leading.equalTo(authorLabel)
            $0.width.equalTo(70)
            $0.height.equalTo(27)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    func configure(model: BookshelfBook) {
        titleLabel.text = model.title
        authorLabel.text = model.author

        // 표지
        if let data = model.coverImageData,
           let image = UIImage(data: data) {
            thumbnailImageView.image = image
        } else {
            thumbnailImageView.image = nil
        }

        // 독서 상태
        if let state = model.readingState, !state.isEmpty {
            stateLabel.text = state 
            
            switch state {
            case "읽는 중":
                stateLabel.backgroundColor = .tertiaryGreen100
                stateLabel.textColor = .tertialryGreen700
            case "중단":
                stateLabel.backgroundColor = .colorFEDCDD
                stateLabel.textColor = .colorA40509
            case "완독":
                stateLabel.backgroundColor = .primaryBlue100
                stateLabel.textColor = .primaryBlue700
            case "읽을 예정":
                stateLabel.backgroundColor = .colorFBF0CB
                stateLabel.textColor = .colorB9920E
            default:
                stateLabel.backgroundColor = UIColor.systemGray4
            }

        } else {
            stateLabel.text = ""
            stateLabel.backgroundColor = .clear
        }
    }
}
