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
    private let copyButton = UIButton(type: .system)
    
    private let separatorView = UIView()
    private let pageLabel = UILabel()
    private let sententceLabel = UILabel()
    
    private let bottomStack = UIStackView()
    private let dateLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    
    private var currentText: String = ""
    
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
        [titleLabel, copyButton, multiButton].forEach { infoStack.addArrangedSubview($0) }
        contentView.addSubview(topStack)
        
        [infoStack, authorLabel].forEach { topStack.addArrangedSubview($0)}
        
        
        titleLabel.font = UIFont.semiBoldFont(ofSize: 14)
        titleLabel.textColor = .likedTitleColor
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        authorLabel.font = UIFont.mediumFont(ofSize: 12)
        authorLabel.textColor = .likedAuthorColor
        authorLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        copyButton.setImage(UIImage(systemName: "document.on.document"), for: .normal)
        copyButton.tintColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        copyButton.addTarget(self, action: #selector(journalCopyTapped), for: .touchUpInside)
        copyButton.snp.makeConstraints {
            $0.width.height.equalTo(18)
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
        multiButton.tintColor = .paragraphPageAndMultiButtonTextColor
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
        dateLabel.textColor = .likedDateColor
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        likeButton.setImage(image, for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.contentHorizontalAlignment = .fill
        likeButton.contentVerticalAlignment = .fill
        likeButton.tintColor = .paragraphLikeButtonIconColor
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
        contentView.backgroundColor = .likedCellColor
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.dynamicBorder = UIColor.likedCellBorderColor
        contentView.clipsToBounds = true
        
        
        separatorView.backgroundColor = .likedCellBorderColor
        separatorView.snp.makeConstraints {
            $0.top.equalTo(topStack.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        pageLabel.font = UIFont.mediumFont(ofSize: 14)
        pageLabel.textColor = .paragraphPageAndMultiButtonTextColor
        pageLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        sententceLabel.textColor = .paragraphTextColor
        sententceLabel.numberOfLines = 0
        sententceLabel.lineBreakMode = .byWordWrapping

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
        ? UIColor.paragraphLikeButtonIconColor
        : UIColor.paragraphUnlikeButtonIconColor
    }
    
    @objc private func journalCopyTapped() {
            UIPasteboard.general.string = currentText

            UIView.transition(with: copyButton, duration: 0.08, options: .transitionCrossDissolve) {
                self.copyButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { [weak self] in
                guard let self else { return }

                UIView.transition(with: self.copyButton, duration: 0.08, options: .transitionCrossDissolve) {
                    self.copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
                }
            }
        }
    func configure(page: String, text: String, dateText: String, liked: Bool, bookTitle: String? = nil, bookAuthor: String? = nil) {
        
        titleLabel.isHidden = false
           authorLabel.isHidden = false
        pageLabel.text = "\(page)p"
        dateLabel.text = dateText
        currentText = text

        
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
            .foregroundColor: UIColor.paragraphTextColor
        ]
        
        sententceLabel.attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        applyLiked(liked)
    }
    
    
    
}


