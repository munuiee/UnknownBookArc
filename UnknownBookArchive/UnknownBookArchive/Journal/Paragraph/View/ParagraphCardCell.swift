// MARK: - 저널 '문단수집' 페이지 컬렉션뷰셀

import Foundation
import SnapKit
import UIKit

final class ParagraphCardCell: UICollectionViewCell {
    static let id = "ParagraphCardCell"
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    var onLikeTapped: (() -> Void)?
    
    private let topStack = UIStackView()
    private let pageLabel = UILabel()
    private let multiButton = UIButton(type: .system)
    private let copyButton = UIButton(type: .system)
    
    private let separatorView = UIView()
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
    
    
    private func topStackUI() {
        contentView.addSubview(topStack)
        [pageLabel, copyButton, multiButton].forEach { topStack.addArrangedSubview($0) }
        
        topStack.axis = .horizontal
        topStack.distribution = .equalSpacing
        pageLabel.font = UIFont.mediumFont(ofSize: 14)
        pageLabel.textColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        
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
        multiButton.tintColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        multiButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.left.equalTo(copyButton.snp.right).offset(4)
        }
       
        
        topStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
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
        [separatorView, sententceLabel].forEach { contentView.addSubview($0) }
        contentView.backgroundColor = .backgroundModeColor
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.dynamicBorder = UIColor.paragraphCellBorderColor
        contentView.clipsToBounds = true
        
        
        separatorView.backgroundColor = .likedCellBorderColor
        separatorView.snp.makeConstraints {
            $0.top.equalTo(topStack.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        sententceLabel.textColor = .paragraphTextColor
        sententceLabel.numberOfLines = 0
        sententceLabel.lineBreakMode = .byWordWrapping
        sententceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
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
        ? .paragraphLikeButtonIconColor
        : .paragraphUnlikeButtonIconColor
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
    func configure(page: String, text: String, dateText: String, liked: Bool) {
        currentText = text
        pageLabel.text = "\(page)p"
        dateLabel.text = dateText
        
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


