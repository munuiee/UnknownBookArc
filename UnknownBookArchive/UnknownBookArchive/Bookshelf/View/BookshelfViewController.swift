// MARK: 책장 뷰컨트롤러

import UIKit
import SnapKit

final class BookshelfViewController: UIViewController {

    private let viewModel = BookshelfViewModel()
    
    // 보여줄 책 목록
    private var displayedBooks: [BookshelfBook] = []

//    // 갤러리 모드 on/ off
//    private var isGalleryMode: Bool = false
    
    private var selectedCategoryIndex: Int = 0

    // 상단 바
    private let topBarView: UIView = UIView()

    // 책장 타이틀
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "책장"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

//    // 갤러리모드 전환 버튼
//    private let galleryButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
//        btn.tintColor = .label
//        return btn
//    }()

    // 검색창
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .gray50
        tf.layer.cornerRadius = 12
        tf.font = .regularFont(ofSize: 16)
        tf.borderStyle = .none

        tf.attributedPlaceholder = NSAttributedString(
            string: "책 제목 검색",
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont.regularFont(ofSize: 16)
            ]
        )

        // 돋보기 아이콘
        let left = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.frame = CGRect(x: 10, y: 8, width: 18, height: 18)
        icon.tintColor = .gray600
        left.addSubview(icon)
        tf.leftView = left
        tf.leftViewMode = .always

        // X 버튼
        let right = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        let clearButton = UIButton(type: .system)
        clearButton.frame = CGRect(x: 6, y: 6, width: 22, height: 22)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .darkGray
        clearButton.addTarget(self, action: #selector(clearSearchText), for: .touchUpInside)
        right.addSubview(clearButton)
        tf.rightView = right
        tf.rightViewMode = .whileEditing

        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return tf
    }()

    // 카테고리 스크롤
    private let categoryScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false // 세로 스크롤바 제거
        scroll.alwaysBounceVertical = false         // 세로 바운스 제거
        scroll.bounces = false                      // 튐 방지
        scroll.isScrollEnabled = true               // 가로 스크롤만 허용
        return scroll
    }()


    private var categoryButtons: [UIButton] = []

    // 카테고리 버튼 StackView
    private lazy var categoryStackView: UIStackView = {
        let categories = [
            "전체", "경제", "사회", "과학", "문학", "에세이",
            "역사", "예술", "인문학", "자기계발", "어린이", "해외도서"
        ]

        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8

        // 카테고리 버튼 디자인
        categories.enumerated().forEach { index, title in
            var config = UIButton.Configuration.bordered()
            config.title = title
            var attributed = AttributedString(title)
            attributed.font = UIFont.mediumFont(ofSize: 14)

            config.attributedTitle = attributed
            
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
            config.baseForegroundColor = .black
            config.cornerStyle = .medium
            
            let btn = UIButton(configuration: config)
            btn.tag = index
            
            btn.layer.cornerRadius = 8
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.gray100.cgColor
            btn.clipsToBounds = true
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.heightAnchor.constraint(equalToConstant: 32).isActive = true
            btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 61).isActive = true

            
            
            btn.configurationUpdateHandler = { [weak self] button in
                guard let self = self else { return }
                let isSelected = button.tag == self.selectedCategoryIndex

                if isSelected {
                    // 선택됨
                    button.configuration?.baseBackgroundColor = .primaryBlue50
                    button.configuration?.baseForegroundColor = .primaryBlue500
                    button.layer.borderColor = UIColor.primaryBlue500.cgColor
                } else {
                    // 비선택
                    button.configuration?.baseBackgroundColor = .white
                    button.configuration?.baseForegroundColor = .gray300
                    button.layer.borderColor = UIColor.gray100.cgColor
                }
            }

            
            btn.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            
            categoryButtons.append(btn)
            sv.addArrangedSubview(btn)
        }

        return sv
    }()

    // 책 목록 테이블
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        return tv
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHierarchy()
        setupConstraints()
        setupTableView()
        bindViewModel()
        updateCategoryUI(selectedIndex: 0)
        
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(reloadBooks),
                name: .bookUpdated,
                object: nil
            )

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reloadBooks),
                name: .bookDeleted,
                object: nil
            )
        }

        @objc private func reloadBooks() {
            viewModel.loadInitialData()
        

//        galleryButton.addTarget(self, action: #selector(toggleDisplayMode), for: .touchUpInside)
    }

    // 뷰 계층 구성
    private func setupHierarchy() {
        view.addSubview(topBarView)
        topBarView.addSubview(titleLabel)
//        topBarView.addSubview(galleryButton)

        view.addSubview(searchTextField)
        view.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        view.addSubview(tableView)
    }

    // MARK: 레이아웃 설정
    private func setupConstraints() {

        topBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }

        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(32)
        }

//        galleryButton.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(20)
//            $0.width.height.equalTo(24)
//        }
        
        

        searchTextField.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(46)
        }

        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(34)
        }

        categoryStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(categoryScrollView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // 테이블뷰 설정
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            BookshelfTableViewCell.self,
            forCellReuseIdentifier: BookshelfTableViewCell.identifier
        )
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] books in
            self?.displayedBooks = books
            self?.tableView.reloadData()
        }
        viewModel.loadInitialData()
    }

    // 검색창 변경
    @objc private func textFieldDidChange() {
        viewModel.updateSearch(text: searchTextField.text ?? "")
    }

    // X버튼 클릭 시 검색어 초기화
    @objc private func clearSearchText() {
        searchTextField.text = ""
        viewModel.updateSearch(text: "")
        searchTextField.resignFirstResponder()
    }

    // 카테고리 버튼 클릭
    @objc private func categoryTapped(_ sender: UIButton) {
        updateCategoryUI(selectedIndex: sender.tag)
        viewModel.updateCategory(index: sender.tag)
    }

    
    private func updateCategoryUI(selectedIndex: Int) {
        selectedCategoryIndex = selectedIndex
        categoryButtons.forEach { $0.setNeedsUpdateConfiguration()}
    }

//    // 갤러리모드 토글
//    @objc private func toggleDisplayMode() {
//        isGalleryMode.toggle()
//        galleryButton.setImage(
//            UIImage(systemName: isGalleryMode ? "list.bullet" : "photo.on.rectangle.angled"),
//            for: .normal
//        )
//        // 갤러리 모드에서 테이블뷰 숨김. 갤러리 모드 생성 예정.
//        tableView.isHidden = isGalleryMode
//    }
    
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }

}

// MARK: TableView DataSource
extension BookshelfViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return displayedBooks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BookshelfTableViewCell.identifier,
            for: indexPath
        ) as? BookshelfTableViewCell else {
            return UITableViewCell()
        }

        let book = displayedBooks[indexPath.row]
        cell.configure(model: book)
        return cell
    }
}


// MARK: TableView Delegate -> 상세 화면 이동
extension BookshelfViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = displayedBooks[indexPath.row]

        guard let coreDataBook = CoreDataManager.shared.fetchBook(uuid: selected.uuid) else {
            print("책 정보를 찾지 못했습니다.")
            return
        }

        let detailVC = BookDetailViewController(book: coreDataBook)
        detailVC.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(detailVC, animated: true)
    }
}
