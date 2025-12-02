//
//  MoreBookTableCell.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 12/2/25.
//

import UIKit
import SnapKit

final class MoreBookTableCell: UITableViewCell {
    
    static let identifier = "MoreBookTableCell"
    
    let coverImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        selectionStyle = .none
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 6
        coverImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        
        authorLabel.font = .systemFont(ofSize: 13)
        authorLabel.textColor = .darkGray
    }
    
    
    private func setupLayout() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        coverImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(73)
            $0.height.equalTo(108)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(coverImageView)
            $0.leading.equalTo(coverImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(titleLabel)
        }
    }
    
    
    func configure(with book: Book) {
        if let data = book.coverImage,
           let image = UIImage(data: data) {
            coverImageView.image = image
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
    }
}
