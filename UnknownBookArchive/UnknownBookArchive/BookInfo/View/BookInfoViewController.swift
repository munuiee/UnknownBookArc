
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

class BookInfoViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var selectedStateButton: BaseButton?
    var selectedFormatButton: BaseButton?
    
    // 태그 이름 목록
    private let tags: [BookTag] = BookTag.allCases
    //    private var tagButtons: [TagButton] = []
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
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
            $0.height.equalTo(178)
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
            .bind {
//                [weak self] in
//                guard let self = self else { return }
                print("저장 버튼 눌림")
            }
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
                print("시작일: 나중에 캘린더 추가")
            }
            .disposed(by: disposeBag)
        endDateButton.rx.tap
            .bind {
                print("종료일: 나중에 캘린더 추가")
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
}
    
