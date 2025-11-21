import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BookSearchViewController: UIViewController {
    
    let viewModel = BookSearchViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: UI요소
    private let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
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
            $0.top.equalToSuperview().inset(112)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        // 백버튼 홈화면에 연결 필요
//        backButton.rx.tap
//            .subscribe()
        // 검색 시작 시
        searchBar.rx.searchButtonClicked
                    .withLatestFrom(searchBar.rx.text.orEmpty)
                    .bind(onNext: { [weak self] text in
                        self?.viewModel.search(query: text)
                        self?.searchBar.resignFirstResponder()
                    })
                    .disposed(by: disposeBag)

            viewModel.bookList
                .bind(to: tableView.rx.items(
                    cellIdentifier: BookSearchCell.id, cellType: BookSearchCell.self)) { index, item, cell in
                    cell.setData(item: item)
                }
                .disposed(by: disposeBag)
        // 검색 취소 시
        searchBar.rx.cancelButtonClicked
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.searchBar.text = ""
                self.searchBar.resignFirstResponder()
                self.viewModel.resetSearchState()
                self.searchBar.setShowsCancelButton(false, animated: true)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .bind(onNext: { [weak self] in
                
                self?.searchBar.setValue("취소", forKey: "cancelButtonText")
                self?.searchBar.setShowsCancelButton(true, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 상태에 따라 UI 업데이트
        Observable.combineLatest(viewModel.viewState, viewModel.bookList)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state, items in
                guard let self = self else { return }
                var message: String = ""
                var showEmptyView: Bool = false
                
                switch state {
                case .initial:
                    message = "직접 책을 추가하고 싶으신가요?"
                    showEmptyView = true
                case .loading:
                    showEmptyView = false
                case .success:
                    if items.isEmpty {
                        message = "검색 결과가 안나오시나요?"
                        showEmptyView = true
                    } else {
                        showEmptyView = false
                    }
                case .error:
                    message = "검색에 실패했습니다."
                    showEmptyView = true
                }
                
                // UI 적용
                if showEmptyView {
                    self.tableView.backgroundView = self.createEmptyView(message: message)
                    self.tableView.separatorStyle = .none
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .singleLine
                }
            })
                .disposed(by: disposeBag)
        }
    
    // MARK: 검색 전, 검색 실패 시 화면
    private func createEmptyView(message: String, showButton: Bool = true) -> UIView {
        let containerView = UIView()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = message
        label.textColor = .gray
        label.textAlignment = .center
        stackView.addArrangedSubview(label)

        if showButton {
            let button = UIButton()
            button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            button.setTitle("직접 책 추가하기", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            // 추후 버튼 이벤트 필요
            button.layer.cornerRadius = 5
            button.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.width.equalTo(198)
            }
            stackView.addArrangedSubview(button)
        }
        containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
            $0.height.equalTo(130)
            $0.width.equalToSuperview()
        }
     return containerView
    }

}
