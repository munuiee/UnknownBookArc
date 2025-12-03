// MARK: 메인화면 더보기 테이블뷰셀

import UIKit
import SnapKit

final class MoreBookCell: UITableViewCell {
    
    static let identifier = "MoreBookCell"
    
    // MARK: - UI 요소
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()

    
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
        titleLabel.font = UIFont.semiBoldFont(ofSize: 18)
        titleLabel.textColor = UIColor(red: 0.043, green: 0.078, blue: 0.176, alpha: 1.0)
        
        // 작가
        authorLabel.font = UIFont.mediumFont(ofSize: 14)
        authorLabel.textColor = UIColor(red: 0.506, green: 0.494, blue: 0.494, alpha: 1.0)

    }
    
    
    // MARK: 레이아웃
    private func setupLayout() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(73)
            $0.height.equalTo(108)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(20)   
        }
        
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
