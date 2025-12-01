
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard
import CoreData

class BookInfoViewController: UIViewController {
    
    var viewModel = BookInfoViewModel()
    var book: Book?
    var bookUUID: String?
    
    let disposeBag = DisposeBag()
    var selectedStateButton: BaseButton?
    var selectedFormatButton: BaseButton?
    
    private let tags: [BookTag] = BookTag.allCases
    
    private let topView = TopView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 책 표지
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private let plusIconImage: UIImageView = {
        let imageView = UIImageView()
        let plusConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let plusImage = UIImage(systemName: "plus.circle", withConfiguration: plusConfig)
        imageView.image = plusImage
        imageView.tintColor = UIColor(red: 0.705, green: 0.699, blue: 0.699, alpha: 1)
        return imageView
    }()
    
    // 독서 상태 UI
    private let stateStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 8
        stView.distribution = .fillEqually
        stView.alignment = .center
        return stView
    }()
    private let readingButton = BaseButton()
    private let pausedButton = BaseButton()
    private let finishedButton = BaseButton()
    private let scheduledButton = BaseButton()
    
    // 책 유형 UI
    private let bookFormatStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 12
        stView.distribution = .equalSpacing
        stView.alignment = .center
        return stView
    }()
    private let paperButton = BaseButton()
    private let ebookButton = BaseButton()
    
    // 책 정보 텍스트필드
    private let textFieldStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .vertical
        stView.spacing = 8
        stView.alignment = .fill
        return stView
    }()
    private let titleTextField = BaseTextField()
    private let authorTextField = BaseTextField()
    private let publisherTextField = BaseTextField()
    
    // 독서 진행도 UI
    private let progressStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 12
        stView.alignment = .center
        return stView
    }()
    private let pageTextField = BaseTextField()
    private let totalPageTextField = BaseTextField()
    private let percentTextField = BaseTextField()
    
    private let toggleButton = ToggleButton()
    
    private let inputStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 8
        stView.distribution = .fillEqually
        stView.alignment = .fill
        return stView
    }()
    // page,percent 상태관리
    private var isPageMode = true
    
    // 시작, 종료 스택뷰
    private let dateStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.distribution = .equalSpacing
        stView.alignment = .fill
        return stView
    }()
    // 시작일, 종료일 버튼
    private let startDateButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    private let endDateButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    // 날짜 입력 받으면 문자열로 변환
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // 태그 버튼 스택뷰
    private let tagLine1StackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 7.5
        stView.distribution = .equalSpacing
        stView.alignment = .center
        return stView
    }()
    private let tagLine2StackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 7.5
        stView.distribution = .equalSpacing
        stView.alignment = .center
        return stView
    }()
    private let tagLine3StackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 7.5
        stView.distribution = .fillProportionally
        stView.alignment = .leading
        return stView
    }()
    
    // 태그 버튼
    private let tagButton0 = TagButton(type: .custom)
    private let tagButton1 = TagButton(type: .custom)
    private let tagButton2 = TagButton(type: .custom)
    private let tagButton3 = TagButton(type: .custom)
    private let tagButton4 = TagButton(type: .custom)
    private let tagButton5 = TagButton(type: .custom)
    private let tagButton6 = TagButton(type: .custom)
    private let tagButton7 = TagButton(type: .custom)
    private let tagButton8 = TagButton(type: .custom)
    private let tagButton9 = TagButton(type: .custom)
    private let tagButton10 = TagButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setConstraints()
        bind()
        keyboardDismiss()
        setupRxKeyboard()
        loadBookDataForEdit()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        scrollView.backgroundColor = .basicBackground
        [topView, scrollView ].forEach { view.addSubview($0) }
        [contentView].forEach { scrollView.addSubview($0) }
        [
            coverImageView, stateStackView, bookFormatStackView, textFieldStackView, progressStackView, dateStackView, tagLine1StackView, tagLine2StackView, tagLine3StackView
        ].forEach { contentView.addSubview($0) }
        
        [plusIconImage].forEach { coverImageView.addSubview($0) }
        [readingButton, pausedButton, finishedButton, scheduledButton]
            .forEach { stateStackView.addArrangedSubview($0) }
        [paperButton, ebookButton].forEach { bookFormatStackView.addArrangedSubview($0) }
        [titleTextField, authorTextField, publisherTextField].forEach { textFieldStackView.addArrangedSubview($0) }
        
        [inputStackView, toggleButton].forEach { progressStackView.addArrangedSubview($0) }
        [startDateButton, endDateButton].forEach { dateStackView.addArrangedSubview($0) }
        [pageTextField, totalPageTextField].forEach { inputStackView.addArrangedSubview($0) }
        
        setupStateButtons()
        setupBookFormatButtons()
        setupTextField()
        setupProgressUI()
        setupTopView()
        setupDateButtons()
        setupTagButtons()
    }
    
    private func setConstraints() {
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        coverImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(170)
        }
        plusIconImage.snp.makeConstraints {
            $0.center.equalTo(coverImageView.snp.center)
        }
        
        stateStackView.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        bookFormatStackView.snp.makeConstraints {
            $0.top.equalTo(stateStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(bookFormatStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        toggleButton.snp.makeConstraints {
            $0.width.equalTo(51)
        }
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(progressStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        startDateButton.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
        endDateButton.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
        tagLine1StackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        tagLine2StackView.snp.makeConstraints {
            $0.top.equalTo(tagLine1StackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        tagLine3StackView.snp.makeConstraints {
            $0.top.equalTo(tagLine2StackView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func bind() {
        let stateButtons: [BaseButton] = [readingButton, pausedButton, finishedButton, scheduledButton]
        let formatButtons: [BaseButton] = [paperButton, ebookButton]
        
        topView.backButtonTap
            .bind { [weak self] in
                guard let self = self else { return }
                print("백버튼 눌림")
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        topView.rightButtonTap
            .bind { [weak self] in
                guard let self = self else { return }
                saveBookInfo()
                print("저장 버튼 눌림")
            }
            .disposed(by: disposeBag)
        // MARK: ViewModel Output 바인딩
        viewModel.title
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.author
            .bind(to: authorTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.publisher
            .bind(to: publisherTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.coverImageUrl
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] urlString in
                if let urlString = urlString, let url = URL(string: urlString) {
                    print("표지 이미지 URL: \(url)")
                    self?.plusIconImage.isHidden = true
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, let image = UIImage(data: data), error == nil else {
                            DispatchQueue.main.async {
                                self?.coverImageView.image = nil
                                self?.plusIconImage.isHidden = false
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            self?.coverImageView.image = image
                        }
                    }.resume()
                } else {
                    self?.coverImageView.image = nil
                    self?.plusIconImage.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        stateButtons.forEach { button in
            button.rx.tap
                .bind { [weak self] in
                    guard let self = self else { return }
                    self.handleStateButtonTap(button)
                }
                .disposed(by: disposeBag)
        }
        formatButtons.forEach { button in
            button.rx.tap
                .bind { [weak self] in
                    guard let self = self else { return }
                    self.handleFormatButtonTap(button)
                }
                .disposed(by: disposeBag)
        }
        toggleButton.rx.controlEvent(.valueChanged)
            .bind { [weak self] in
                self?.handleToggleTap()
            }
            .disposed(by: disposeBag)
        startDateButton.rx.tap
            .bind {
                print("시작일 버튼 눌림")
                self.openCalendar(sourceButton: self.startDateButton) { selectedDate in
                    self.startDateButton.setTitle(selectedDate, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        endDateButton.rx.tap
            .bind {
                print("종료일 버튼 눌림")
                self.openCalendar(sourceButton: self.endDateButton) { selectedDate in
                    self.endDateButton.setTitle(selectedDate, for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func handleStateButtonTap(_ sender: BaseButton) {
        if selectedStateButton != sender {
            selectedStateButton?.isSelected = false
            sender.isSelected = true
            selectedStateButton = sender
            print("\(sender.title(for: .normal)!) 상태가 선택되었습니다.")
        }
    }
    private func handleFormatButtonTap(_ sender: BaseButton) {
        if selectedFormatButton != sender {
            selectedFormatButton?.isSelected = false
            sender.isSelected = true
            selectedFormatButton = sender
            print("\(sender.title(for: .normal)!) 유형이 선택되었습니다.")
        }
    }
    private func handleToggleTap() {
        let isPageMode = toggleButton.isPageMode
        
        inputStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if isPageMode {
            [pageTextField, totalPageTextField].forEach { inputStackView.addArrangedSubview($0) }
            inputStackView.distribution = .fillEqually
            print("페이지 입력 모드")
        } else {
            inputStackView.addArrangedSubview(percentTextField)
            inputStackView.distribution = .fill
            print("퍼센트 입력 모드")
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: 키보드 가림 방지
    private func setupRxKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else { return }
                let inset = keyboardVisibleHeight
                
                self.scrollView.contentInset.bottom = inset
                self.scrollView.verticalScrollIndicatorInsets.bottom = inset
                
                if inset > 0 {
                    let responder = self.findFirstResponder(in: self.contentView)
                    
                    if let textField = responder as? UITextField {
                        let rectInScrollView = self.contentView.convert(textField.frame, to: self.scrollView)
                        let visibleBottom = self.scrollView.bounds.height - inset
                        let targetY = rectInScrollView.maxY + 10
                        
                        if targetY > visibleBottom {
                            let offset = CGPoint(x: 0, y: targetY - visibleBottom)
                            self.scrollView.setContentOffset(offset, animated: true)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func findFirstResponder(in view: UIView) -> UIResponder? {
        if view.isFirstResponder {
            return view
        }
        for subview in view.subviews {
            if let responder = findFirstResponder(in: subview) {
                return responder
            }
        }
        return nil
    }
    
    @objc
    private func tagButtonTapped(_ sender: TagButton) {
        sender.isSelected.toggle()
        
        let tagName = tags[sender.tag].rawValue
        if sender.isSelected {
            print("\(tagName) 태그 선택됨")
        } else {
            print("\(tagName) 태그 선택 해제됨")
        }
    }
    
    // MARK: UI setup 함수들
    private func setupTopView() {
        let saveConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let saveImage = UIImage(systemName: "text.page", withConfiguration: saveConfig)
        topView.configure(title: "", rightButtonImage: saveImage)
    }
    
    private func setupStateButtons() {
        // 1. 읽는 중 버튼
        readingButton.configure(
            title: "읽는 중",
            backgroundColor: .stateDefaultBGColor,
            titleColor: .stateDefaultTextColor,
            borderColor: .stateDefaultBorderColor,
            selectedBgColor: .readingSelected,
            selectedTitleColor: .stateSeletedTextColor
        )
        
        // 2. 중단 버튼
        pausedButton.configure(
            title: "중단",
            backgroundColor: .stateDefaultBGColor,
            titleColor: .stateDefaultTextColor,
            borderColor: .stateDefaultBorderColor,
            selectedBgColor: .pausedSelected,
            selectedTitleColor: .stateSeletedTextColor
        )
        
        // 3. 완독 버튼
        finishedButton.configure(
            title: "완독",
            backgroundColor: .stateDefaultBGColor,
            titleColor: .stateDefaultTextColor,
            borderColor: .stateDefaultBorderColor,
            selectedBgColor: .finishedSelected,
            selectedTitleColor: .stateSeletedTextColor
        )
        
        // 4. 읽을 예정 버튼
        scheduledButton.configure(
            title: "읽을 예정",
            backgroundColor: .stateDefaultBGColor,
            titleColor: .stateDefaultTextColor,
            borderColor: .stateDefaultBorderColor,
            selectedBgColor: .scheduledSelected,
            selectedTitleColor: .stateSeletedTextColor
        )
    }
    private func setupBookFormatButtons() {
        // 1. 종이책 버튼
        paperButton.configure(
            title: "종이책",
            backgroundColor: .formatDefaultBGColor,
            titleColor: .formatDefaultTextColor,
            borderColor: .formatDefaultBorderColor,
            selectedBgColor: .paperBGColor,
            selectedTitleColor: .paperTextColor
        )
        
        // 2. 전자책 버튼
        ebookButton.configure(
            title: "전자책",
            backgroundColor: .formatDefaultBGColor,
            titleColor: .formatDefaultTextColor,
            borderColor: .formatDefaultBorderColor,
            selectedBgColor: .ebookBGColor,
            selectedTitleColor: .ebookTextColor
        )
    }
    
    private func setupTextField() {
        titleTextField.configure(placeholder: "책의 제목을 입력하세요")
        authorTextField.configure(placeholder: "책의 저자를 입력하세요")
        publisherTextField.configure(placeholder: "책의 출판사를 입력하세요")
    }
    
    private func setupProgressUI() {
        pageTextField.configure(placeholder: "읽은 페이지")
        totalPageTextField.configure(placeholder: "전체 페이지")
        percentTextField.configure(placeholder: "진행률을 입력하세요")
        toggleButton.configure(initialPageMode: true)
        pageTextField.keyboardType = .numberPad
        totalPageTextField.keyboardType = .numberPad
        percentTextField.keyboardType = .numberPad
    }
    
    private func setupDateButtons() {
        // 1. 시작일 버튼 (UIButton 설정)
        startDateButton.setTitle("시작일", for: .normal)
        startDateButton.setTitleColor(UIColor(red: 0.481, green: 0.679, blue: 0.572, alpha: 1), for: .normal)
        startDateButton.backgroundColor = UIColor(red: 0.96, green: 0.98, blue: 0.96, alpha: 1)
        startDateButton.layer.borderColor = UIColor(red: 0.852, green: 0.908, blue: 0.878, alpha: 1).cgColor
        
        endDateButton.setTitle("종료일", for: .normal)
        endDateButton.setTitleColor(UIColor(red: 0.372, green: 0.495, blue: 0.848, alpha: 1), for: .normal)
        endDateButton.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.99, alpha: 1)
        endDateButton.layer.borderColor = UIColor(red: 0.855, green: 0.883, blue: 0.965, alpha: 1).cgColor
    }
    // 달력 팝업 띄우기
    private func openCalendar(sourceButton: UIButton, completion: @escaping (String) -> Void) {
        // 달력 보여줄 임시 뷰컨
        let calenderVC = UIViewController()
        calenderVC.view.backgroundColor = .white
        calenderVC.modalPresentationStyle = .popover
        calenderVC.preferredContentSize = CGSize(width: 330, height: 350)
        
        if let popover = calenderVC.popoverPresentationController {
            popover.sourceView = sourceButton
            popover.sourceRect = sourceButton.bounds
            popover.permittedArrowDirections = [.up, .down]
        }
        
        // 달력 만들기
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.tintColor = .systemBlue
        datePicker.overrideUserInterfaceStyle = .light
        
        //완료 버튼
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("완료", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        doneButton.setTitleColor(.black, for: .normal)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        
        [stackView].forEach { calenderVC.view.addSubview($0) }
        [datePicker, doneButton].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(100)
        }
        doneButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        doneButton.rx.tap
            .bind { [weak self, weak calenderVC] in
                let dateString = self?.dateFormatter.string(from: datePicker.date) ?? "시작일"
                completion(dateString)
                calenderVC?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        self.present(calenderVC, animated: true)
    }
    
    private func setupTagButtons() {
        // 모든 태그 버튼을 배열로 묶어서 설정 코드를 재사용합니다. (DRY 원칙)
        let allTagButtons: [TagButton] = [
            tagButton0, tagButton1, tagButton2, tagButton3, tagButton4,
            tagButton5, tagButton6, tagButton7, tagButton8, tagButton9,
            tagButton10
        ]
        
        for (index, button) in allTagButtons.enumerated() {
            guard index < tags.count else { continue }
            let title = tags[index].rawValue
            
            button.configure(
                title: title,
                titleColor: .stateDefaultTextColor,
                borderColor: .stateDefaultBorderColor,
                selectedBgColor: .tagSeletedBGColor,
                selectedTitleColor: .tagSeletedTextColor
            )
            
            button.tag = index
            button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
        }
        [tagButton0, tagButton1, tagButton2, tagButton3, tagButton4]
            .forEach { tagLine1StackView.addArrangedSubview($0) }
        [tagButton5, tagButton6, tagButton7, tagButton8, tagButton9]
            .forEach { tagLine2StackView.addArrangedSubview($0) }
        [tagButton10]
            .forEach { tagLine3StackView.addArrangedSubview($0) }
        
    }
    // 화면 전환용
    private func navigateToNewDetailVC(with book: Book, progressValue: Float, progressText: String) {
        let detailVC = BookDetailViewController()
        detailVC.book = book
        detailVC.hidesBottomBarWhenPushed = false
        detailVC.progressValue = progressValue
        detailVC.progressText = progressText
        
        if let navigationController = self.navigationController {
            var viewConrollers = navigationController.viewControllers
            viewConrollers.removeLast()
            viewConrollers.append(detailVC)
            navigationController.setViewControllers(viewConrollers, animated: true)
        }
    }
    
    // MARK: 코어데이터 관련 함수
    // 저장 버튼에 들어갈 함수
    private func saveBookInfo() {

        // 데이터 추출-----------------------------------------
        let coverImageData = coverImageView.image?.jpegData(compressionQuality: 0.8)
        
        let readingState = selectedStateButton?.title(for: .normal) ?? ""
        let bookFormat = selectedFormatButton?.title(for: .normal) ?? ""
        
        guard let title = titleTextField.text, !title.isEmpty else {
            print("제목필수 나중에 알럿 띄우기")
            return
        }
        let author = authorTextField.text ?? ""
        let publisher = publisherTextField.text ?? ""
       
        // 페이지 수
        let currentPage = Int32(pageTextField.text ?? "0") ?? 0
        let totalPage = Int32(totalPageTextField.text ?? "0") ?? 0

        let percentText = percentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let percent = Int32(percentText) ?? 0

        
        // 진행률 계산
        var progressValue: Float = 0.0
        var progressText: String = ""
        
        if toggleButton.isPageMode {
            if totalPage > 0 {
                progressValue = Float(currentPage) / Float(totalPage)
                progressText = "\(currentPage)/\(totalPage) P"
            } else {
                progressText = ""
            }
        } else {
            if !percentText.isEmpty {
                progressValue = Float(percent) / 100.0
                progressValue = min(max(progressValue, 0.0), 1.0)
                progressText = "\(percent)%"
            } else {
                progressText = ""
            }
        }
          
        // 시작일, 종료일 버튼 타이틀 문자열로 변환
        let startDateString = startDateButton.title(for: .normal)
        let endDateString = endDateButton.title(for: .normal)
        
        let startDate = dateFormatter.date(from: startDateString ?? "")
        let endDate = dateFormatter.date(from: endDateString ?? "")
        
        let allTagButtons: [TagButton] = [tagButton0, tagButton1, tagButton2, tagButton3, tagButton4, tagButton5, tagButton6, tagButton7, tagButton8, tagButton9, tagButton10]
        // 선택된 태그 타이틀 가져와서 콤마로 연결
        let selectedTagsString = allTagButtons
            .filter { $0.isSelected }
            .compactMap { tags[$0.tag].rawValue }
            .joined(separator: ",")
        
        
        // 코어 데이터 저장 및 수정 분기 -----------------------------------------
        var savedBook: Book?
        
        if let existingUUID = self.bookUUID {
            savedBook = CoreDataManager.shared.bookUpdate(uuid: existingUUID, title: title, author: author, publisher: publisher, readingState: readingState, bookFormat: bookFormat, selectedTags: selectedTagsString, coverImage: coverImageData, currentPage: currentPage, totalPage: totalPage, percent: percent, startDate: startDate, endDate: endDate
            )
        } else {
            let newUUID = UUID().uuidString
            savedBook = CoreDataManager.shared.bookCreate(uuid: newUUID, title: title, author: author, publisher: publisher, readingState: readingState, bookFormat: bookFormat, selectedTags: selectedTagsString, coverImage: coverImageData, currentPage: currentPage, totalPage: totalPage, percent: percent, startDate: startDate, endDate: endDate
            )
        }
        
        // 화면 전환 및 데이터 전달-----------------------------------------
        if let saveBook = savedBook {

            if self.bookUUID != nil {
                if let detailVC = self.navigationController?.viewControllers.dropLast().last as? BookDetailViewController {
                    detailVC.book = saveBook
                    detailVC.hidesBottomBarWhenPushed = false
                    detailVC.progressValue = progressValue
                    detailVC.progressText = progressText
                    
                    detailVC.reloadBookDataAndDisplay()
                    
                    self.navigationController?.popViewController(animated: true)
                } else {
                    navigateToNewDetailVC(with: saveBook, progressValue: progressValue, progressText: progressText)
                }
            } else {
                navigateToNewDetailVC(with: saveBook, progressValue: progressValue, progressText: progressText)
            }

        } else {
            print("저장 실패. 알럿 처리필요")
        }
    }
    
    private func loadBookDataForEdit() {
        guard let uuid = self.bookUUID else {
            return
        }
        if let existingBook = CoreDataManager.shared.fetchBook(uuid: uuid) {
            self.book = existingBook
            setupUIWithExistingBook(existingBook)
            print("책 정보 수정 모드: 데이터 로드 완료")
        } else {
            print("\(uuid)에 해당하는 책을 찾을 수 없습니다.")
        }
    }
    private func setupUIWithExistingBook(_ book: Book) {
        titleTextField.text = book.title
        authorTextField.text = book.author
        publisherTextField.text = book.publisher
        
        if let imageData = book.coverImage, let image = UIImage(data: imageData) {
            coverImageView.image = image
        } else {
            coverImageView.image = nil
        }
        
        if let state = book.readingState {
            let stateButtons: [BaseButton] = [readingButton, pausedButton, finishedButton, scheduledButton]
            if let targetButton = stateButtons.first(where: { $0.title(for: .normal) == state}) {
                handleStateButtonTap(targetButton)
            }
        }
        if let format = book.bookFormat {
            let formatButtons: [BaseButton] = [paperButton, ebookButton]
            if let targetButton = formatButtons.first(where: { $0.title(for: .normal) == format}) {
                handleFormatButtonTap(targetButton)
            }
        }
        pageTextField.text = (book.currentPage > 0) ? String(book.currentPage) : nil
        totalPageTextField.text = (book.totalPage > 0) ? String(book.totalPage) : nil
        percentTextField.text = (book.percent > 0) ? String(book.percent) : nil
        
        if book.totalPage > 0 && book.currentPage > 0 {
            toggleButton.isPageMode = true
        } else if book.percent > 0 {
            toggleButton.isPageMode = false
        } else {
            toggleButton.isPageMode = true
        }
        
        handleToggleTap()
        
        if let startDate = book.startDate {
            startDateButton.setTitle(dateFormatter.string(from: startDate), for: .normal)
        }
        if let endDate = book.endDate {
            endDateButton.setTitle(dateFormatter.string(from: endDate), for: .normal)
        }
        if let selectedTagsString = book.selectedTags, !selectedTagsString.isEmpty {
            let selectedTagsArray = selectedTagsString.components(separatedBy: ",")
            let allTagButtons: [TagButton] = [
                tagButton0, tagButton1, tagButton2, tagButton3, tagButton4, tagButton5, tagButton6, tagButton7, tagButton8, tagButton9, tagButton10
            ]
            
            for button in allTagButtons {
                if button.tag < tags.count {
                    let tagName = tags[button.tag].rawValue
                    button.isSelected = selectedTagsArray.contains(tagName)
                }
            }
        }
    }
    
}
