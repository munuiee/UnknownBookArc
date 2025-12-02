//
//  BookshelfTableViewCell.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/25/25.
//

import UIKit
import SnapKit

final class BookshelfTableViewCell: UITableViewCell {

    static let identifier = "BookshelfTableViewCell"

    // 책 정보 담은 카드 모양 View
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()

    // 책 표지 이미지 자리
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    // 책 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    // 저자
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 뷰 계층 구성
    private func setupHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(authorLabel)
    }

    // 레이아웃
    private func setupConstraints() {

        // 카드
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }

        // 책 이미지
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(cardView).offset(12)
            $0.leading.equalTo(cardView).offset(12)
            $0.width.equalTo(70)
            $0.height.equalTo(104)
            $0.bottom.lessThanOrEqualTo(cardView).inset(12)
        }

        // 제목
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)   // 🔥 핵심 포인트
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(cardView).inset(12)
        }

        // 저자
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }

    func configure(title: String, author: String, image: UIImage? = nil) {
        titleLabel.text = title
        authorLabel.text = author
        thumbnailImageView.image = image
    }
}
