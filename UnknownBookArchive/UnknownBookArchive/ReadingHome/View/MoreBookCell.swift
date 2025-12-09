// MARK: 메인화면 더보기 테이블뷰셀

import UIKit
import SnapKit

final class MoreBookCell: UITableViewCell {
    
    static let identifier = "MoreBookCell"
    
    // MARK: - UI 요소
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.primaryBlue50.cgColor
        return view
    }()
    
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: UI 설정
    private func setupUI() {
        
        // 카드뷰 안에 추가
        contentView.addSubview(cardView)
        
        // 썸네일
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.borderWidth = 1
        thumbnailImageView.layer.borderColor = UIColor.primaryBlue50.cgColor
        thumbnailImageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        // 제목
        titleLabel.font = UIFont.semiBoldFont(ofSize: 18)
        titleLabel.textColor = UIColor(red: 0.043, green: 0.078, blue: 0.176, alpha: 1.0)
        titleLabel.numberOfLines = 1
        
        // 작가
        authorLabel.font = UIFont.mediumFont(ofSize: 14)
        authorLabel.textColor = UIColor(red: 0.506, green: 0.494, blue: 0.494, alpha: 1.0)
        authorLabel.numberOfLines = 1
        
        [thumbnailImageView, titleLabel, authorLabel].forEach {
            cardView.addSubview($0)
        }
    }
    
    
    // MARK: 레이아웃
    private func setupLayout() {
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        // 썸네일
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(cardView).offset(8)
            $0.leading.equalTo(cardView).offset(8)
            $0.width.equalTo(73)
            $0.height.equalTo(108)
            $0.bottom.lessThanOrEqualTo(cardView).inset(8)
        }
        
        // 제목 
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top).offset(4)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(cardView).inset(8)
        }
        
        // 작가
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
    
    
    // MARK: 데이터 적용
    func configure(with book: Book) {
        
        if let data = book.coverImage,
           let image = UIImage(data: data) {
            thumbnailImageView.image = image
        } else {
            thumbnailImageView.image = nil
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
    }
}
