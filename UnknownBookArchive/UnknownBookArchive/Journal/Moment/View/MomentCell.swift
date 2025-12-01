// MARK: - 저널 '찰나의 기록' 페이지 컬렉션뷰셀

import Foundation
import SnapKit
import UIKit

final class MomentCell: UICollectionViewCell {
    static let id = "MomentCell"
    
    var editTapped: (() -> Void)?
    var deleteTapped: (() -> Void)?
    

    
    private let vStack = UIStackView()
    private let mButton = UIButton(type: .system)
    private let mainText = UILabel()
    
    private let separatorView = UIView()
    
    private let bottomStack = UIStackView()
    private let timeLabel = UILabel()
    private let pageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor
        contentView.clipsToBounds = true
        
        
        separatorUI()
        mainUI()
        bottomStackUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func separatorUI() {
        contentView.addSubview(separatorView)
        separatorView.backgroundColor = .systemGray5
        separatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalToSuperview().offset(18)
           // $0.bottom.equalTo(vStack.snp.top).offset(10)
        }
    }

    
    private func mainUI() {
        contentView.addSubview(vStack)
        [mButton, mainText].forEach { vStack.addArrangedSubview($0) }
        
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
        vStack.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            // $0.centerX.equalToSuperview()
        }
     
//        let menuEdit = UIAction(
//            title: "기록 수정",
//            image: UIImage(named: "menuEdit")
//        ) { [weak self] _ in
//            self?.editTapped?()
//        }
        
        let menuDelete = UIAction(
            title: "기록 삭제",
            image: UIImage(named: "menuDelete"),
        ) { [weak self] _ in
            self?.deleteTapped?()
        }
        
        mButton.menu = UIMenu(children: [menuDelete])
        mButton.showsMenuAsPrimaryAction = true
        mButton.setImage(UIImage(named: "journalMultiB"), for: .normal)
        mButton.imageView?.contentMode = .scaleAspectFit
        mButton.contentHorizontalAlignment = .right
        mButton.tintColor = UIColor(red: 103/255, green: 101/255, blue: 101/255, alpha: 1.0)
        mButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }

        mainText.textColor = UIColor(red: 0.101, green: 0.099, blue: 0.099, alpha: 1)
        mainText.numberOfLines = 0
        mainText.lineBreakMode = .byWordWrapping
        mainText.textColor = UIColor(red: 26/255, green: 25/255, blue: 25/255, alpha: 1.0)
    }
    

    
    private func bottomStackUI() {
        contentView.addSubview(bottomStack)
        [timeLabel, pageLabel].forEach { bottomStack.addArrangedSubview($0) }
        
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        
        timeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = UIColor(red: 0.705, green: 0.699, blue: 0.699, alpha: 1)
        pageLabel.font = .systemFont(ofSize: 12, weight: .regular)
        pageLabel.textColor = UIColor(red: 0.404, green: 0.396, blue: 0.396, alpha: 1.0)

        bottomStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.greaterThanOrEqualTo(vStack.snp.bottom).offset(8)
        }
        
    }

  
    
    
    func configure(mPage: String, mText: String, mDate: String, mTime: String) {
        pageLabel.text = "\(mPage)p"
        timeLabel.text = mTime
        
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
        
        mainText.attributedText = NSAttributedString(
            string: mText,
            attributes: attributes
        )
        
    }
    
    
    
}


