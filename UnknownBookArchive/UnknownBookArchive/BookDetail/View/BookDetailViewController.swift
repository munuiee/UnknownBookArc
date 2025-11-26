
import UIKit
import SnapKit
import CoreData

class BookDetailViewController: UIViewController {
    
    var book: Book?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        displayBookInfo()

    }
    private func configureUI() {
        view.backgroundColor = .white
        [
            titleLabel, authorLabel
        ].forEach { view.addSubview($0) }
    }
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    private func displayBookInfo() {
        guard let bookData = book else {
            titleLabel.text = "책 정보를 불러올 수 없습니다"
            return
        }
        titleLabel.text = bookData.title
        authorLabel.text = bookData.author
    }


}
