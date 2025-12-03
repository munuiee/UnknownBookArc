// MARK: 책 상세화면

import UIKit
import SnapKit
import CoreData
import RxSwift
import RxCocoa

class BookDetailViewController: UIViewController {
    
    
    let disposeBag = DisposeBag()
    var book: Book?
    var bookUUID: String?
    
    var onLikeBookTapped: (() -> Void)?
    
    private let viewModel = BookDetailViewModel()
    private let topView = TopView()
    private let contentView = UIView()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let coreDataManager = CoreDataManager.shared
    private var context: NSManagedObjectContext {
        coreDataManager.persistentContainer.viewContext
    }
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // 전체 정보들을 담을 메인 스택 뷰
    private let infoStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .vertical
        stView.spacing = 10
        stView.alignment = .fill
        stView.distribution = .fill
        return stView
    }()
    
    // 상태, 책 포맷 스택뷰
    private let stateFormatStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 12
        stView.alignment = .leading
        return stView
    }()
    private let formatSpacer = UIView()
    private let stateButton = BaseButton()
    private let formatButton = BaseButton()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.semiBoldFont(ofSize: 18)
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.mediumFont(ofSize: 14)
        return label
    }()
    
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.mediumFont(ofSize: 14)
        return label
    }()
    
    // 진행률 스택뷰
    private let progressStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .vertical
        stView.spacing = 5
        return stView
    }()
    
    // 진행률
    private let progressLable: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.mediumFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = UIColor(red: 0.903, green: 0.901, blue: 0.901, alpha: 1)
        progressView.progressTintColor = .primaryColor
        progressView.progress = 0.1
        return progressView
    }()
    
    // 시작, 종료 스택뷰
    private let dateStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.distribution = .fill
        stView.alignment = .fill
        return stView
    }()
    
    private let dateSpacer = UIView()
    
    // 시작일, 종료일
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.textColor = UIColor(red: 0.481, green: 0.679, blue: 0.572, alpha: 1)
        label.layer.borderColor = UIColor(red: 0.852, green: 0.908, blue: 0.878, alpha: 1).cgColor
        label.textAlignment = .center
        label.font = UIFont.mediumFont(ofSize: 12)
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(red: 0.855, green: 0.883, blue: 0.965, alpha: 1).cgColor
        label.textColor = UIColor(red: 0.372, green: 0.495, blue: 0.848, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.mediumFont(ofSize: 12)
        return label
    }()
    
    private let leadingDatePusher = UIView()
    
    private let tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7.5
        stackView.alignment = .leading
        return stackView
    }()
    
    // 하단 좋아요, 저널 보기 버튼
    private let bottomButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 0.968, green: 0.974, blue: 0.992, alpha: 1)
        let normalImage = UIImage(systemName: "heart")
        button.setImage(normalImage, for: .normal)
        let selectedImage = UIImage(systemName: "heart.fill")
        button.setImage(selectedImage, for: .selected)
        button.tintColor = .primaryColor
        return button
    }()
    
    private let journalButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primaryColor
        button.setTitle("저널 보기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.semiBoldFont(ofSize: 18)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()

        setupRightTopMenu()
        bind()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadBookData()
        displayBookInfo()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        
        [topView, contentView].forEach { view.addSubview($0) }
        
        [coverImageView, infoStackView, bottomButtonStackView].forEach { contentView.addSubview($0) }
        
        [stateFormatStackView, titleLabel, authorLabel, publisherLabel, progressStackView, dateStackView, tagsStackView].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        infoStackView.setCustomSpacing(20, after: stateFormatStackView) // 상태 - 제목 사이
        infoStackView.setCustomSpacing(16, after: progressStackView)    // 진행률 - 날짜 사이
        infoStackView.setCustomSpacing(20, after: dateStackView)        // 날짜 - 태그 사이
        
        // 내부 스택뷰 구성
        [stateButton, formatButton, formatSpacer].forEach { stateFormatStackView.addArrangedSubview($0) }
        [progressLable, progressBar].forEach { progressStackView.addArrangedSubview($0) }
        [leadingDatePusher,startDateLabel, dateSpacer, endDateLabel].forEach { dateStackView.addArrangedSubview($0) }
        [likeButton, journalButton].forEach { bottomButtonStackView.addArrangedSubview($0) }
        
        leadingDatePusher.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leadingDatePusher.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        dateSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateSpacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setConstraints() {
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        coverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(178)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(bottomButtonStackView.snp.top).offset(-20)
        }
        
        stateFormatStackView.snp.makeConstraints {
            $0.height.equalTo(32)
        }

        startDateLabel.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
        endDateLabel.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
        
        // 하단 버튼
        bottomButtonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            $0.height.equalTo(52)
        }
        likeButton.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalToSuperview()
        }
        journalButton.snp.makeConstraints {
            $0.height.equalToSuperview()
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
        // 저널 보기 버튼
        journalButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      let bookToJournal = self.book else { return }
                let journalVC = JournalViewController(book: bookToJournal)
                journalVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(journalVC, animated: true)
            }
            .disposed(by: disposeBag)
        // 좋아요 버튼
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self, let book = self.book else { return }
                
                self.viewModel.toggleLike(for: book)
                self.likeButton.isSelected = book.liked

            })
            .disposed(by: disposeBag)
    }
    
    // MARK: 책 정보 표시
    private func displayBookInfo() {
        guard let bookData = book else {
            print("BookDetailVC: Book이 없음")
            return
        }
        setupUIWithBook(bookData)
    }
    // 장르 태그 추가
    private func setupDetailTags(tagsString: String?) {
        guard let tagsString = tagsString, !tagsString.isEmpty else { return }
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        

        let tagNames = tagsString.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        for tagName in tagNames {
            let tagButton = TagButton(type: .custom)
            
            tagButton.configure(
                title: tagName,
                titleColor: .tagSeletedTextColor,
                borderColor: .tagSeletedBoarderColor,
                selectedBgColor: .tagSeletedBGColor,
                selectedTitleColor: .tagSeletedTextColor
            )
            tagButton.isSelected = true
            
            tagsStackView.addArrangedSubview(tagButton)
        }
        let spacer = UIView()
        tagsStackView.addArrangedSubview(spacer)
    }
    
    // MARK: 데이터 새로고침 (외부 호출 용)
    func reloadBookDataAndDisplay() {
        loadBookData()
    }
    
    // MARK: TopView 오른쪽 버튼 설정
    private func setupRightTopMenu() {
        // 수정
        let menuEdit = UIAction(title: "책 정보 수정", image: UIImage(systemName: "pencil")
        ) { [weak self] _ in
            self?.editBookInfo()
        }
        // 삭제
        let menuDelete = UIAction(title: "책 삭제", image: UIImage(systemName: "trash")
        ) { [weak self] _ in
            self?.showDeleteAlert()
        }
        topView.rightButton.menu = UIMenu(children: [menuEdit, menuDelete])
        topView.rightButton.showsMenuAsPrimaryAction = true
        topView.rightButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        topView.rightButton.tintColor = .black
    }
    
    // MARK: 수정 및 삭제 기능 함수
    private func editBookInfo() {
        guard let bookUUID = self.book?.uuid else {
            print("책 정보가 없거나 UUID가 유효하지 않습니다.")
            return
        }
        let bookInfoVC = BookInfoViewController()
        bookInfoVC.bookUUID = bookUUID
        self.navigationController?.pushViewController(bookInfoVC, animated: true)
    }
    private func deletedBook() {
        guard let bootToDelete = self.book, let bookUUID = bootToDelete.uuid else {
            print("삭제할 책이 없습니다.")
            return
        }
        CoreDataManager.shared.deleteBook(uuid: bookUUID) { success in
            DispatchQueue.main.async { [weak self] in
                if success {
                    print("책 정보 삭제 성공")
                    
                    // 책 삭제 시 메인화면에서도 사라지게 하는 코드
                    NotificationCenter.default.post(name: .bookDeleted, object: nil)

                    self?.navigationController?.popViewController(animated: true)
                } else {
                    print("책 정보 삭제 실패")
                }
            }
        }
    }
    private func loadBookData() {
        guard let uuid = self.bookUUID else {
            print("책 정보를 불러올 수 없습니다.")
            return
        }
        if let existingBook = CoreDataManager.shared.fetchBook(uuid: uuid) {
            self.book = existingBook
            setupUIWithBook(existingBook)
            print("상세화면 데이터 로드 완료")
        } else {
            print("상세화면 데이터 로드 실패")
        }
    }
    // MARK: 책 상세 정보 셋업
    private func setupUIWithBook(_ bookData: Book) {
        if let imageData = book?.coverImage, let image = UIImage(data: imageData) {

            coverImageView.image = image
        } else {
            coverImageView.image = nil
        }
        
        
        // 상태 버튼 처리
        if let state = book?.readingState, !state.isEmpty {
            stateFormatStackView.isHidden = false
            stateButton.isHidden = false
            
            var selectedBgColor: UIColor?
            var selectedBoarderColor: UIColor?
            
            switch state {
            case "읽는 중":
                selectedBgColor = .colorD9E8E0
                selectedBoarderColor = .colorD9E8E0
            case "중단":
                selectedBgColor = .colorFEDCDD
                selectedBoarderColor = .colorFEDCDD
            case "완독":
                selectedBgColor = .colorDAE1F6
                selectedBoarderColor = .colorDAE1F6
            case "읽을 예정":
                selectedBgColor = .colorFBF0CB
                selectedBoarderColor = .colorFBF0CB
            default:
                stateButton.isHidden = true
                return
            }
            stateButton.configure(title: state, backgroundColor: .stateDefaultBGColor, titleColor: .stateDefaultTextColor, borderColor: selectedBoarderColor ?? .stateDefaultBorderColor, selectedBgColor: selectedBgColor ?? .clear, selectedTitleColor: .stateSeletedTextColor)
            stateButton.isSelected = true
            stateButton.isUserInteractionEnabled = false
        } else {
            stateButton.isHidden = true
        }
        
        // 책 포맷 버튼
        if let format = bookData.bookFormat, !format.isEmpty {
            stateFormatStackView.isHidden = false
            formatButton.isHidden = false
            
            var selectedBgColor: UIColor?
            var selectedTitleColor: UIColor?
            
            switch format {
            case "종이책":
                selectedBgColor = .colorD9E6ED
                selectedTitleColor = .color3F7088
            case "전자책":
                selectedBgColor = .colorD9E6ED
                selectedTitleColor = .color3F7088
            default:
                formatButton.isHidden = true
                return
            }
            
            formatButton.configure(
                title: format,
                backgroundColor: .formatDefaultBGColor,
                titleColor: .formatDefaultTextColor,
                borderColor: .formatDefaultBorderColor,
                selectedBgColor: selectedBgColor ?? .clear,
                selectedTitleColor: selectedTitleColor ?? .black
            )
            formatButton.isSelected = true
            formatButton.isUserInteractionEnabled = false
            
        } else {
            formatButton.isHidden = true
        }
        
        stateFormatStackView.isHidden = stateButton.isHidden && formatButton.isHidden
        
        // 책 제목 (필수로 받음)
        titleLabel.text = bookData.title
        
        // 저자
        if let author = bookData.author, !author.isEmpty {
            authorLabel.text = author
            authorLabel.isHidden = false
        } else {
            authorLabel.isHidden = true
        }
        // 출판사
        if let publisher = bookData.publisher, !publisher.isEmpty {
            publisherLabel.text = publisher
            publisherLabel.isHidden = false
        } else {
            publisherLabel.isHidden = true
        }
        
        // 진행률
        let progress = calculateProgress(book: bookData)
        let hasProgressData = !progress.text.isEmpty
        
        progressStackView.isHidden = !hasProgressData
        
        if hasProgressData {
            progressLable.text = progress.text
            progressBar.setProgress(progress.value, animated: false)
            } else {
                progressLable.text = ""
                progressBar.progress = 0.0
            }

        // 시작일, 종료일
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter
        }()
        
        if let startDate = bookData.startDate {
            startDateLabel.text = dateFormatter.string(from: startDate)
            startDateLabel.isHidden = false
        } else {
            startDateLabel.text = ""
            startDateLabel.isHidden = true
        }
        if let endDate = bookData.endDate {
            endDateLabel.text = dateFormatter.string(from: endDate)
            endDateLabel.isHidden = false
        } else {
            endDateLabel.text = ""
            endDateLabel.isHidden = true
        }
        
        let hasStartDate = (bookData.startDate != nil)
        let hasEndDate = (bookData.endDate != nil)
        
        let onlyEndDate = !hasStartDate && hasEndDate
        
        leadingDatePusher.isHidden = !onlyEndDate
        dateSpacer.isHidden = onlyEndDate
        
        let shouldHideDateStack = !hasStartDate && !hasEndDate
        dateStackView.isHidden = shouldHideDateStack
        
        if let tagsString = bookData.selectedTags, !tagsString.isEmpty {
            setupDetailTags(tagsString: tagsString)
            tagsStackView.isHidden = false
        } else {
            tagsStackView.isHidden = true
        }
        view.layoutIfNeeded()
        
        likeButton.isSelected = bookData.liked
    }
    
    // 진행률 계산
    private func calculateProgress(book: Book) -> (value: Float, text: String) {
        let currentPage = book.currentPage
        let totalPage = book.totalPage
        let percent  = book.percent
        
        let lastSelectedIsPageMode = book.isPageMode
        

        var progressValue: Float = 0.0
        var progressText: String = ""
        if lastSelectedIsPageMode {
            if totalPage > 0 {
                progressValue = Float(currentPage) / Float(totalPage)
                progressText = "\(currentPage)/\(totalPage) P"
            } else {
                progressText = ""
            }
        } else {
            if percent > 0 {
                progressValue = Float(percent) / 100.0
                progressValue = min(max(progressValue, 0.0), 1.0)
                progressText = "\(percent)%"
            } else {
                progressText = ""

            }
        }
        return (value: progressValue, text: progressText)
    }


    private func showDeleteAlert() {
        showConfirmAlert(title: "책 정보 삭제", message: "이 책의 모든 정보와 저널 기록이 삭제됩니다. 정말 삭제하시겠습니까?", confirmTitle: "삭제"
        ) { [weak self] in
            self?.deletedBook()
        }
    }
}
