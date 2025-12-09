import Foundation
import UIKit
import SnapKit

final class MomentView: UIView {
    
    let chatView = UIView()
    let buttonView = UIView()
    let inputPage = UITextField()
    let inputText = UITextView()
    let sendButton = UIButton()
    let inputContainer = UIView()
    let separatorView = UIView()
    let textPlaceholderLabel = UILabel()
    let maxTextViewHeight: CGFloat = 132
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    // 높이 제약
    var inputTextHeightConstraint: Constraint?
    var chatViewBottomConstraint: Constraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        inputTextUI()
        collectionSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func collectionSet() {
        addSubview(collectionView)
        
        
        // 헤더 등록
        collectionView.register(
            DateHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DateHeaderView.id
        )
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(chatView.snp.top)
        }
        
        collectionView.backgroundColor = .white
    }
    
    
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 0,
            bottom: 20,
            trailing: 0
        )
        section.interGroupSpacing = 16
        
        // 섹션 헤더 (날짜 바)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .absolute(152),
            heightDimension: .estimated(32)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 4, trailing: 0)
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - 아래 입력창 UI
    
    private func inputTextUI() {
        addSubview(chatView)
        [inputContainer, buttonView].forEach { chatView.addSubview($0) }
        buttonView.addSubview(sendButton)
        
        chatView.backgroundColor = .white
        chatView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.snp.bottom).constraint
            chatViewBottomConstraint = $0.bottom.equalTo(self.snp.bottom).constraint
        }
        
        buttonView.backgroundColor = .white
        buttonView.layer.cornerRadius = 21
        buttonView.layer.masksToBounds = false
        
        buttonView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        buttonView.layer.shadowOpacity = 1
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 8)
        buttonView.layer.shadowRadius = 32
        
        buttonView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(42)
            $0.width.height.equalTo(42)
        }
        
        
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "arrow.up", withConfiguration: config)
        sendButton.setImage(image, for: .normal)
        sendButton.tintColor = UIColor(red: 0.10196, green: 0.09804, blue: 0.09804, alpha: 1.0)
        sendButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        inputContainer.backgroundColor = .clear
        inputContainer.layer.cornerRadius = 8
        inputContainer.layer.masksToBounds = false
        inputContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        inputContainer.layer.shadowOpacity = 1
        inputContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
        inputContainer.layer.shadowRadius = 32
        inputContainer.snp.makeConstraints {
            $0.width.equalTo(285)
            $0.height.greaterThanOrEqualTo(76)
            $0.height.lessThanOrEqualTo(172) // 132 + 40 (대략)
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(buttonView.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().inset(42)
        }
        
        
        let blurBackgroundView = UIView()
        blurBackgroundView.layer.cornerRadius = 10
        blurBackgroundView.clipsToBounds = true
        
        inputContainer.addSubview(blurBackgroundView)
        blurBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blurBackgroundView.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 블랙 10% 오버레이
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        blurBackgroundView.addSubview(dimView)
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let whiteContentView = UIView()
        whiteContentView.backgroundColor = .white
        whiteContentView.layer.cornerRadius = 10
        whiteContentView.layer.masksToBounds = true
        
        inputContainer.addSubview(whiteContentView)
        whiteContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 블러보다 위에 오게
        inputContainer.bringSubviewToFront(whiteContentView)
        
        
        
        
        [inputPage, separatorView, inputText].forEach { whiteContentView.addSubview($0) }
        
        inputPage.placeholder = "책의 페이지를 기록해 주세요"
        inputPage.font = UIFont.regularFont(ofSize: 14)
        inputPage.textColor = .gray300
        inputPage.keyboardType = .numberPad
        inputPage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(24)
        }
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        inputPage.leftView = padding
        inputPage.leftViewMode = .always
        
        
        
        
        // 가운데 선
        separatorView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(inputPage.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(0.5)
        }
        
        // 아래 본문 입력
        inputText.backgroundColor = .white
        inputText.font = UIFont.regularFont(ofSize: 14)
        inputText.isScrollEnabled = true
        inputText.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 6, right: 4)
        
        inputText.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(6)
            inputTextHeightConstraint = $0.height.equalTo(36).constraint
        }
        
        
        
        textPlaceholderLabel.text = "내용을 입력하세요."
        textPlaceholderLabel.textColor = UIColor(named: "placeholderColor")
        textPlaceholderLabel.font = UIFont.regularFont(ofSize: 13.8)
        inputText.addSubview(textPlaceholderLabel)
        textPlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(7.5)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }
    
}
