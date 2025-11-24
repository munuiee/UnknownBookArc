import Foundation
import SnapKit
import UIKit

final class ParagraphCardCell: UICollectionViewCell {
    static let id = "ParagraphCardCell"
    
    private let topStack = UIStackView()
    private let pageLabel = UILabel()
    private let multiButton = UIButton(type: .system)
    
    private let separatorView = UIView()
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
    
    
    private func topStackUI() {
        contentView.addSubview(topStack)
        [pageLabel, multiButton].forEach { topStack.addArrangedSubview($0) }
        
        topStack.axis = .horizontal
        topStack.distribution = .equalSpacing
        pageLabel.font = .systemFont(ofSize: 14, weight: .medium)
        pageLabel.textColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        

        multiButton.setImage(UIImage(named: "journalMultiB"), for: .normal)
        multiButton.imageView?.contentMode = .scaleAspectFit
        multiButton.tintColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        multiButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
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
        
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = UIColor(red: 0.705, green: 0.699, blue: 0.699, alpha: 1)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = UIColor(red: 180/255, green: 178/255, blue: 178/255, alpha: 1.0)
        likeButton.sizeToFit()
       
        
        bottomStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
 
    }
    
    private func configureUI() {
        [separatorView, sententceLabel].forEach { contentView.addSubview($0) }
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
        
        sententceLabel.textColor = UIColor(red: 0.101, green: 0.099, blue: 0.099, alpha: 1)
       // sententceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        sententceLabel.numberOfLines = 0
        sententceLabel.lineBreakMode = .byWordWrapping
        sententceLabel.textColor = UIColor(red: 26/255, green: 25/255, blue: 25/255, alpha: 1.0)
        sententceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualTo(bottomStack.snp.top).offset(-12)
        }
    }
    
    func configure(page: String, text: String, dateText: String, liked: Bool) {
        pageLabel.text = "\(page)p"
        //sententceLabel.text = text
        dateLabel.text = dateText
        
        let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
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
        
        
        let imageName = liked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}


