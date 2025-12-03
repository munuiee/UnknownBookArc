import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BookSearchViewController: UIViewController {
    
    let viewModel = BookSearchViewModel()
    let disposeBag = DisposeBag()     
    
    // MARK: UI요소
    private let topView = TopView()
    private var currentQuery: String = ""

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.backgroundImage = UIImage()
        sb.barTintColor = .white
        sb.backgroundColor = .white
        sb.searchTextField.backgroundColor = UIColor(red: 0.903, green: 0.901, blue: 0.901, alpha: 1)
        sb.searchTextField.font = .systemFont(ofSize: 16, weight: .regular)
        sb.searchTextField.tintColor = .black
        sb.searchTextField.textColor = .black
        sb.searchTextField.leftView?.tintColor = .gray
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "책 제목, 저자를 검색하세요",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.705, green: 0.699, blue: 0.699, alpha: 1)])
        if let clearImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(UIColor(red: 0.404, green: 0.396, blue: 0.396, alpha: 1), renderingMode: .alwaysOriginal) {
            sb.setImage(clearImage, for: .clear, state: .normal)
        }
            return sb
    }()
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.register(BookSearchCell.self, forCellReuseIdentifier: BookSearchCell.id)
        tv.rowHeight = 124
        tv.separatorStyle = .none
       return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopView()
        configureUI()
        setConstraints()
        bind()
        keyboardDismiss()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureUI() {

        view.backgroundColor = .white
        [
            topView, searchBar, tableView
        ].forEach { view.addSubview($0) }
        
    }
    
    private func setConstraints() {
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {

        topView.backButtonTap
            .bind { [weak self] in
                guard let self = self else { return }
                print("백버튼 눌림")
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
 
        // 검색 시작 시
        searchBar.rx.searchButtonClicked
                    .withLatestFrom(searchBar.rx.text.orEmpty)
                    .bind(onNext: { [weak self] text in
                        self?.currentQuery = text
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
        
        // MARK: 상태에 따라 UI 업데이트
        Observable.combineLatest(viewModel.viewState, viewModel.bookList) { state, items in
            return (state, items)
        }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state, items in
                guard let self = self else { return }
                var message: String = ""
                var showEmptyView: Bool = false
                var labelYOffset: CGFloat = -80
                var buttonYOffset: CGFloat = -40
                var isLeadingAlignment: Bool = false
                
                switch state {
                case .initial:
                    message = "직접 책을 추가하고 싶으신가요?"
                    showEmptyView = true
                    labelYOffset = -130
                    buttonYOffset = -65
                    isLeadingAlignment = false
                case .loading:
                    showEmptyView = false

                case .success:
                    if items.isEmpty {
                        let queryMessage = self.currentQuery.isEmpty ? "" : "'\(self.currentQuery)'"
                        message = "\(queryMessage)에 대한 검색 결과가 없습니다."
                        showEmptyView = true
                        labelYOffset = -310
                        buttonYOffset = -110
                        isLeadingAlignment = true
                    } else {
                        showEmptyView = false

                    }
                case .error:
                    message = "검색에 실패했습니다."
                    showEmptyView = true
                    labelYOffset = -104
                    buttonYOffset = -40
                    isLeadingAlignment = false
                }
                
                // UI 적용
                if showEmptyView {
                    let emptyView = self.createEmptyView(message: message, labelYOffset: labelYOffset, buttonYOffset: buttonYOffset, isLeadingAlignment: isLeadingAlignment)
                    self.tableView.backgroundView = emptyView
                    self.tableView.separatorStyle = .none
                    
                    if let addButton = emptyView.viewWithTag(999) as? UIButton {
                        addButton.rx.tap
                            .subscribe(onNext: { [weak self] in
                                self?.moveToBookInfo()
                            })
                            .disposed(by: disposeBag)
                    }
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .none
                }
            })
                .disposed(by: disposeBag)
        // 테이블 뷰 선택 애니메이션
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 테이블 뷰 셀 선택
        tableView.rx.modelSelected(BookItem.self)
            .subscribe(onNext: { [weak self] bookItem in
                self?.tableView.deselectRow(at: self?.tableView.indexPathForSelectedRow ?? IndexPath(), animated: true)
                self?.viewModel.selectBook(item: bookItem)
            })
            .disposed(by: disposeBag)
        // 중복 체크
        viewModel.bookDuplicationCheck
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item, isDuplicated in
                guard let self = self else { return }
                if isDuplicated {
                    self.showAlert(title: "알림", message: "이미 저장된 책입니다.")
                } else {
                    self.moveToBookInfo(with: item)
                }
            })
            .disposed(by: disposeBag)
        
        // 책 선택 후 화면 이동 및 데이터 전달
        viewModel.selectedBookItem
            .subscribe(onNext: { [weak self] bookItem in
                guard let self = self else { return }
                print("선택된 책: \(bookItem.title)")
                let bookInfoVC = BookInfoViewController()
                let bookInfoVM = BookInfoViewModel()
                bookInfoVC.viewModel = bookInfoVM
                bookInfoVM.initialBookItem.onNext(bookItem)
                bookInfoVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(bookInfoVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // MARK: 페이지네이션
        // 스크롤 위치 감지
        tableView.rx.contentOffset
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                let frameHeight = self.tableView.frame.height
                let isNearBottom = offsetY > contentHeight - frameHeight - 100
                return isNearBottom
            }
            // 스크롤 조건 검사
            .withLatestFrom(viewModel.isLoading.asObservable()) { isNearBottom, isLoading in
                return isNearBottom && !isLoading
            }
            .withLatestFrom(viewModel.canLoadMore.asObservable()) { shouldLoad, canLoadMore in
                return shouldLoad && canLoadMore
            }
            // 페이지네이션 검색 요청
            .filter { $0 }
            .map { [weak self] _ -> (query: String, page: Int) in
                let nextPageIndex = (self?.viewModel.currentPage.value ?? 0) + 1
                self?.viewModel.currentPage.accept(nextPageIndex)
                return (query: self?.currentQuery ?? "", page: nextPageIndex)
            }
            .subscribe(onNext: { [weak self] request in
                guard let self = self else { return }
                print("다음 페이지 로드 요청: \(request.page)페이지")
                self.viewModel.search(query: request.query, page: request.page)
            })
            .disposed(by: disposeBag)

        }
    
    // MARK: 검색 전, 검색 실패 시 화면
    private func createEmptyView(message: String, showButton: Bool = true, labelYOffset: CGFloat, buttonYOffset: CGFloat, isLeadingAlignment: Bool = false) -> UIView {
        let containerView = UIView()


        let label = UILabel()
        label.text = message
        label.textColor = UIColor(red: 0.404, green: 0.396, blue: 0.396, alpha: 1)
        label.textAlignment = .center
        label.textAlignment = isLeadingAlignment ? .left : .center
        containerView.addSubview(label)
        
        label.snp.makeConstraints {
            if isLeadingAlignment {
                $0.leading.equalToSuperview().offset(15)
                $0.trailing.lessThanOrEqualToSuperview().offset(-20)
            } else {
                $0.centerX.equalToSuperview()
            }
            $0.centerY.equalToSuperview().offset(labelYOffset)
        }

        if showButton {
            let button = UIButton()
            button.tag = 999
            button.backgroundColor = .primaryColor
            button.setTitle("직접 책 추가하기", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            button.layer.cornerRadius = 8
            
            containerView.addSubview(button)
            button.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(buttonYOffset)
                $0.height.equalTo(52)
                $0.leading.trailing.equalToSuperview().inset(80)
            }
        }
        
     return containerView
    }
    
    private func setupTopView() {
        topView.configure(title: "책 추가하기", rightButtonImage: nil)
    }
    
    // MARK: 상세화면으로 이동
    // 셀 클릭 후 이동
    private func moveToBookInfo(with bookItem: BookItem) {
        let bookInfoVC = BookInfoViewController()
        let bookInfoVM = BookInfoViewModel()
        bookInfoVC.viewModel = bookInfoVM
        bookInfoVM.initialBookItem.onNext(bookItem)
        bookInfoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(bookInfoVC, animated: true)
    }
    // 직접추가 버튼 클릭 후 이동
    private func moveToBookInfo() {
        let emptyBookItem = BookItem.empty()
        moveToBookInfo(with: emptyBookItem)
    }
    
}
