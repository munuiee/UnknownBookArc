import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BookSearchViewController: UIViewController {
    
    let viewModel = BookSearchViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: UI요소
    private let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "책 제목, 저자를 검색하세요"
        sb.backgroundImage = UIImage()
        sb.barTintColor = .white
        sb.backgroundColor = .white
        sb.searchTextField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        sb.searchTextField.textColor = .black
        sb.searchTextField.tintColor = .black
        sb.searchTextField.leftView?.tintColor = .gray
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "책 제목, 저자를 검색하세요",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        if let clearImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal) {
            sb.setImage(clearImage, for: .clear, state: .normal)
        }
            return sb
    }()
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.register(BookSearchCell.self, forCellReuseIdentifier: BookSearchCell.id)
        tv.rowHeight = 100
       return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureUI()
        setConstraints()
        bind()
    }
     // 내비게이션바 아이템 추가
    private func setupNavigationBar() {
        self.navigationItem.title = "책 추가하기"
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            searchBar, tableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        // 백버튼 메인화면에 연결 필요
//        backButton.rx.tap
//            .subscribe()

        searchBar.rx.searchButtonClicked
                    .withLatestFrom(searchBar.rx.text.orEmpty)
                    .bind(onNext: { [weak self] text in
                        self?.viewModel.search(query: text)
                        self?.searchBar.resignFirstResponder()
                    })
                    .disposed(by: disposeBag)

            viewModel.bookList
                .bind(to: tableView.rx.items(cellIdentifier: BookSearchCell.id, cellType: BookSearchCell.self)) { index, item, cell in
                    cell.setData(item: item)
                }
                .disposed(by: disposeBag)
        }

}
