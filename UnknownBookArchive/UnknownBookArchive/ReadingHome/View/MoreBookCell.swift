//
//  MoreBookCell.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 12/2/25.
//

import UIKit
import SnapKit

final class MoreBookCell: UITableViewCell {
    
    static let identifier = "MoreBookCell"
    
    // MARK: - UI 요소
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let menuButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: UI 설정
    private func setupUI() {
        
        // 썸네일
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 6
        thumbnailImageView.backgroundColor = .systemGray5
        
        // 제목
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        
        // 작가
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .gray
        
    }
    
    
    // MARK: 레이아웃
    private func setupLayout() {
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(menuButton)
        
        // 썸네일
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(73)
            $0.height.equalTo(108)
        }
        
        // 메뉴 버튼
        menuButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.width.height.equalTo(24)
        }
        
        // 제목
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.equalTo(menuButton.snp.leading).offset(-12)
        }
        
        // 작가
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(titleLabel)
        }
    }
    
    
    // MARK: 데이터 적용
    func configure(with book: Book) {
        
        if let data = book.coverImage,
           let image = UIImage(data: data) {
            thumbnailImageView.image = image
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
    }
}
