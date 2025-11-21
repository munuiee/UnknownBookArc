import UIKit
import SnapKit


class BookSearchCell: UITableViewCell {
    static let id = "BookSearchCell"
    
    private let thumnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
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
    }
    private func setConstraints() {
        thumnailImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(80)
            $0.width.equalTo(60)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumnailImage.snp.trailing).offset(10)
            $0.top.equalToSuperview().inset(15)
        }
        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(thumnailImage.snp.trailing).offset(10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        publisherLabel.snp.makeConstraints {
            $0.leading.equalTo(thumnailImage.snp.trailing).offset(10)
            $0.top.equalTo(authorLabel.snp.bottom).offset(5)

        }
    }
    func setData(item: BookItem) {
        self.titleLabel.text = item.title
        self.authorLabel.text = item.author
        self.publisherLabel.text = item.publisher
        
        if let imageURL = URL(string: item.cover) {
            self.thumnailImage.image = nil
            
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    print("이미지 불러오기 실패")
                    return
                }
                DispatchQueue.main.async {
                    self?.thumnailImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
