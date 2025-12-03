// MARK: 좋아요 한 문단 수집 섹션

import Foundation
import SnapKit
import UIKit

final class LikeParagraphCardCell: UICollectionViewCell {
    static let id = "LikeParagraphCardCell"
    
    
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    var onLikeTapped: (() -> Void)?
    
    private let topStack = UIStackView()
    private let infoStack = UIStackView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let multiButton = UIButton(type: .system)
    
    private let separatorView = UIView()
    private let pageLabel = UILabel()
    private let sententceLabel = UILabel()
    
    private let bottomStack = UIStackView()
    private let dateLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topStackUI()
        bottomStackUI()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
    }
    
    
    private func topStackUI() {
        [titleLabel, multiButton].forEach { infoStack.addArrangedSubview($0) }
        contentView.addSubview(topStack)
        
        [infoStack, authorLabel].forEach { topStack.addArrangedSubview($0)}
        
        
        titleLabel.font = UIFont.semiBoldFont(ofSize: 14)
        titleLabel.textColor = UIColor.color676565
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        authorLabel.font = UIFont.mediumFont(ofSize: 12)
        authorLabel.textColor = UIColor.colorB4B2B2
        authorLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        let menuEdit = UIAction(
            title: "문단 수정",
            image: UIImage(named: "menuEdit")
        ) { [weak self] _ in
            self?.onEditTapped?()
        }
        
        let menuDelete = UIAction(
            title: "문단 삭제",
            image: UIImage(named: "menuDelete"),
        ) { [weak self] _ in
            self?.onDeleteTapped?()
        }
        
        
        multiButton.menu = UIMenu(children: [menuEdit, menuDelete])
        multiButton.showsMenuAsPrimaryAction = true
        multiButton.setImage(UIImage(named: "journalMultiB"), for: .normal)
        multiButton.imageView?.contentMode = .scaleAspectFit
        multiButton.tintColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        multiButton.setContentHuggingPriority(.required, for: .horizontal)
        multiButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        
        infoStack.axis = .horizontal
        infoStack.distribution = .fill
        infoStack.spacing = 8
        infoStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.bottom.equalTo(authorLabel.snp.top).offset(-1)
        }
        
        
        topStack.axis = .vertical
        topStack.spacing = 2
        topStack.distribution = .fill
        topStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(20)
        }
        
    }
    
    private func bottomStackUI() {
        contentView.addSubview(bottomStack)
        [dateLabel, likeButton].forEach { bottomStack.addArrangedSubview($0) }
        
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        
        dateLabel.font = UIFont.regularFont(ofSize: 12)
        dateLabel.textColor = UIColor(red: 0.705, green: 0.699, blue: 0.699, alpha: 1)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        likeButton.setImage(image, for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.contentHorizontalAlignment = .fill
        likeButton.contentVerticalAlignment = .fill
        likeButton.tintColor = UIColor(red: 180/255, green: 178/255, blue: 178/255, alpha: 1.0)
        likeButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        applyLiked(false)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        bottomStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
    }
    
    private func configureUI() {
        [pageLabel, separatorView, sententceLabel].forEach { contentView.addSubview($0) }
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor
        contentView.clipsToBounds = true
        
        
        separatorView.backgroundColor = .systemGray5
        separatorView.snp.makeConstraints {
            $0.top.equalTo(topStack.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        pageLabel.font = UIFont.mediumFont(ofSize: 14)
        pageLabel.textColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        pageLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        sententceLabel.textColor = UIColor(red: 0.101, green: 0.099, blue: 0.099, alpha: 1)
        sententceLabel.numberOfLines = 0
        sententceLabel.lineBreakMode = .byWordWrapping
        sententceLabel.textColor = UIColor(red: 26/255, green: 25/255, blue: 25/255, alpha: 1.0)
        sententceLabel.snp.makeConstraints {
            $0.top.equalTo(pageLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualTo(bottomStack.snp.top).offset(-12)
        }
    }
    
    @objc private func likeButtonTapped() {
        onLikeTapped?()
    }
    
    func applyLiked(_ liked: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let imageName = liked ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName, withConfiguration: config)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = liked
        ? UIColor(red: 21/255, green: 37/255, blue: 85/255, alpha: 1.0)
        : UIColor(red: 180/255, green: 178/255, blue: 178/255, alpha: 1.0)
    }
    
    
    func configure(page: String, text: String, dateText: String, liked: Bool, bookTitle: String? = nil, bookAuthor: String? = nil) {
        
        titleLabel.isHidden = false
           authorLabel.isHidden = false
        pageLabel.text = "\(page)p"
        dateLabel.text = dateText
        
        if let t = bookTitle, !t.isEmpty {
            titleLabel.isHidden = false
            titleLabel.text = t
        } else {
            titleLabel.isHidden = true
            titleLabel.text = nil
        }
        
        if let a = bookAuthor, !a.isEmpty {
            authorLabel.isHidden = false
            authorLabel.text = a
        } else {
            authorLabel.isHidden = true
            authorLabel.text = nil
        }
        
        
        let font = UIFont.regularFont(ofSize: 14)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 21.7
        paragraphStyle.maximumLineHeight = 21.7
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: 0.20,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor(red: 26/255, green: 25/255, blue: 25/255, alpha: 1)
        ]
        
        sententceLabel.attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        applyLiked(liked)
    }
    
    
    
}


