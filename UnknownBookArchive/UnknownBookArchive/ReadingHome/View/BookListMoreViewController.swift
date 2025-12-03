// MARK: 메인화면 더보기 페이지

import UIKit
import SnapKit

final class BookListMoreViewController: UIViewController {
    
    // MARK: - Properties
    private var books: [Book] = []
    var listTitle: String = ""
    
    private let customNavBar = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupTableView()
        setupLayout()
        
        // 책 삭제 알림
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadAfterDelete),
            name: .bookDeleted,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadBooks()  // 항상 최신 데이터 불러오기
    }
    
    
    // MARK: - Load Books from CoreData
    private func loadBooks() {
        let allBooks = CoreDataManager.shared.fetchAllBooks()
        
        books = allBooks.filter { book in
            switch listTitle {
            case "읽는 중인 책":
                return book.readingState == "읽는 중"
            case "읽을 예정인 책", "읽을 예정 책":
                return book.readingState == "읽을 예정"
            case "잠시 멈춘 책":
                return book.readingState == "중단"
            case "완독한 책", "완독 책":
                return book.readingState == "완독"
            default:
                return false
            }
        }
        
        tableView.reloadData()
    }
    
    @objc private func reloadAfterDelete() {
        loadBooks()
    }
    
    
    // MARK: - Custom Navigation Bar
    private func setupNavigationBar() {
        view.addSubview(customNavBar)
        customNavBar.backgroundColor = .systemBackground
        
        customNavBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        // 뒤로가기 버튼
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        // 타이틀
        titleLabel.text = listTitle
        titleLabel.font = UIFont.semiBoldFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        customNavBar.addSubview(backButton)
        customNavBar.addSubview(titleLabel)
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()    // 가운데 정렬
        }
    }
    
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - TableView
    private func setupTableView() {
        tableView.register(MoreBookCell.self, forCellReuseIdentifier: MoreBookCell.identifier)
        tableView.rowHeight = 124
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(customNavBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}



// MARK: - UITableView DataSource / Delegate
extension BookListMoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MoreBookCell.identifier,
            for: indexPath
        ) as! MoreBookCell
        
        let book = books[indexPath.row]
        cell.configure(with: book)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let book = books[indexPath.row]
        let detailVC = BookDetailViewController(book: book)
        detailVC.book = book
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
