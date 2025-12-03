//
//  BookshelfTableViewCell.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/25/25.
//

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
            view.layer.cornerRadius = 12
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.systemGray5.cgColor
            return view
        }()

    // 책 표지
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    // 저자
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    // 독서 상태 라벨
    private let stateLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.inset = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.textColor = .stateSeletedTextColor
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
            $0.top.equalTo(cardView).offset(12)
            $0.leading.equalTo(cardView).offset(12)
            $0.width.equalTo(70)
            $0.height.equalTo(104)
            $0.bottom.lessThanOrEqualTo(cardView).inset(12)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(cardView).inset(12)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
        }

        stateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(42)
            $0.leading.equalTo(authorLabel)
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
                stateLabel.backgroundColor = .readingSelected
            case "중단":
                stateLabel.backgroundColor = .pausedSelected
            case "완독":
                stateLabel.backgroundColor = .finishedSelected
            case "읽을 예정":
                stateLabel.backgroundColor = .scheduledSelected
            default:
                stateLabel.backgroundColor = UIColor.systemGray4
            }

        } else {
            stateLabel.text = ""
            stateLabel.backgroundColor = .clear
        }
    }
}
