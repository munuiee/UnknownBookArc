// MARK: 현재 읽는 책 컬렉션뷰셀

import UIKit
import SnapKit

final class CurrentReadingCell: UICollectionViewCell {
    
    static let identifier = "CurrentReadingCell"
    
    // MARK: - UI 요소
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let dateLabel = UILabel()
    let percentLabel = UILabel()
    let progressBar = UIProgressView()
    let journalButton = UIButton(type: .system)

    // 날짜 + 진행률 스택
    private let dateInfoStack: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.alignment = .center
        st.distribution = .equalSpacing
        return st
    }()
    
    // 저널 버튼 콜백
    var onJournalButtonTapped: (() -> Void)?
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()

        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI 설정
    private func setupUI() {
        
        // 썸네일
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
        
        // 제목
        titleLabel.font = UIFont.semiBoldFont(ofSize: 14)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .primaryBlue900
        
        // 지은이
        authorLabel.font = UIFont.mediumFont(ofSize: 12)
        authorLabel.textColor = UIColor.gray200
        
        // 날짜
        dateLabel.font = UIFont.mediumFont(ofSize: 12)
        dateLabel.textColor = .gray300
        
        // 퍼센트
        percentLabel.font = UIFont.boldFont(ofSize: 12)
        percentLabel.textColor = .mainPercentTextColor
        
        // 진행률 바
        progressBar.trackTintColor = .mainProgressBarBGColor
        progressBar.progressTintColor = .mainProgressBarColor
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        
        // 저널 버튼
        journalButton.setTitle("저널 보기", for: .normal)
        journalButton.backgroundColor = .mainJournalButtonColor
        journalButton.setTitleColor(.mainJournalTextColor, for: .normal)
        journalButton.titleLabel?.font = UIFont.mediumFont(ofSize: 12)
        journalButton.layer.cornerRadius = 4
        journalButton.addTarget(self, action: #selector(didTapJournal), for: .touchUpInside)
    }
    
    
    // MARK: - Layout
    private func setupLayout() {
        
        // MARK: 카드 내부 UI 추가
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateInfoStack)
        contentView.addSubview(progressBar)
        contentView.addSubview(journalButton)
        
        // 날짜 + 진행률 스택 내부에 라벨 넣기
        dateInfoStack.addArrangedSubview(dateLabel)
        dateInfoStack.addArrangedSubview(percentLabel)
        
        
        // 썸네일
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            $0.size.equalTo(CGSize(width: 97, height: 144))
        }
        
        // 제목
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        // 작가
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        // 날짜 + 진행률
        dateInfoStack.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        // 진행률 바
        progressBar.snp.makeConstraints {
            $0.top.equalTo(dateInfoStack.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(6)
        }
        
        // 저널 버튼
        journalButton.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(titleLabel)
            $0.height.equalTo(32)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 초기화해주지 않으면 다음 셀로 재사용될 때 이전 데이터가 남아버림
        thumbnailImageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        dateLabel.text = nil
        percentLabel.text = nil
        progressBar.progress = 0
    }

    
    // MARK: - 데이터 구성
    func configure(with book: Book) {
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        
        if let data = book.coverImage,
           let img = UIImage(data: data) {
            thumbnailImageView.image = img
        }
        
        // 시작 날짜
        if let startDate = book.startDate {
            let df = DateFormatter()
            df.dateFormat = "yyyy.MM.dd"
            dateLabel.text = df.string(from: startDate)
        } else {
            dateLabel.text = ""
        }
        
        // 진행률 표시
        let currentPage = Int(book.currentPage)
        let totalPage = Int(book.totalPage)
        let percent = Int(book.percent)
        
        if totalPage > 0 {
            let progress = Float(currentPage) / Float(totalPage)
            progressBar.progress = progress
            percentLabel.text = "\(currentPage)/\(totalPage) P"
        } else {
            let clamped = max(0, min(percent, 100))
            progressBar.progress = Float(clamped) / 100.0
            percentLabel.text = "\(clamped)%"
        }
    }
    
    
    // MARK: - Action
    @objc private func didTapJournal() {
        onJournalButtonTapped?()
    }
}
