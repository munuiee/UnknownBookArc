// MARK: 검색화면 테이블뷰셀

import UIKit
import SnapKit

class BookSearchCell: UITableViewCell {
    static let id = "BookSearchCell"
    
    private var dataTask: URLSessionDataTask?
    
    private let thumnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(red: 0.968, green: 0.974, blue: 0.992, alpha: 1).cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldFont(ofSize: 18)
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.505, green: 0.495, blue: 0.495, alpha: 1)
        label.font = UIFont.regularFont(ofSize: 14)
        return label
    }()
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.705, green: 0.699, blue: 0.699, alpha: 1)
        label.font = UIFont.regularFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        [
            thumnailImage, titleLabel, authorLabel, publisherLabel
        ].forEach { contentView.addSubview($0) }
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor(red: 0.968, green: 0.974, blue: 0.992, alpha: 1).cgColor
    }
    
    private func setConstraints() {
        thumnailImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView.snp.leading).offset(8)
            $0.top.equalTo(contentView).offset(8)
            $0.bottom.equalTo(contentView).offset(-8)
            $0.height.equalTo(108)
            $0.width.equalTo(73)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumnailImage.snp.trailing).offset(8)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-8)
            $0.top.equalToSuperview().inset(15)
        }
        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(thumnailImage.snp.trailing).offset(8)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-8)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        publisherLabel.snp.makeConstraints {
            $0.leading.equalTo(thumnailImage.snp.trailing).offset(8)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-8)
            $0.top.equalTo(authorLabel.snp.bottom).offset(5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let verticalMargin: CGFloat = 4
        let horizontalMargin: CGFloat = 0
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin))
    }
    
    func setData(item: BookItem) {
        self.titleLabel.text = item.title
        self.authorLabel.text = item.author
        self.publisherLabel.text = item.publisher
        
        self.dataTask?.cancel()
        self.thumnailImage.image = nil
        
        if let imageURL = URL(string: item.highQualityCover) {
            let newTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if let error = error as? URLError, error.code == .cancelled {
                    return
                }
                guard let data = data, error == nil else {
                    print("이미지 불러오기 실패: \(error?.localizedDescription ?? "알 수 없는 에러")")
                    return
                }
                DispatchQueue.main.async {
                    self?.thumnailImage.image = UIImage(data: data)
                }
                self?.dataTask = nil
                
            }
            self.dataTask = newTask
            newTask.resume()
        } else {
            self.dataTask = nil
        }
    }
}
