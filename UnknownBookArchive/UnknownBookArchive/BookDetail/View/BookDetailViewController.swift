
import UIKit
import SnapKit
import CoreData
import RxSwift
import RxCocoa

class BookDetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var book: Book?
    
    private let topView = TopView()
    private let contentView = UIView()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = true
        return imageView
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
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(red: 0.855, green: 0.883, blue: 0.965, alpha: 1).cgColor
        label.textColor = UIColor(red: 0.372, green: 0.495, blue: 0.848, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        displayBookInfo()
        bind()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        contentView.backgroundColor = .basicBackground

        [topView, contentView].forEach { view.addSubview($0) }
        [coverImageView, stateFormatStackView, titleLabel, authorLabel, publisherLabel, dateStackView, tagsStackView, bottomButtonStackView].forEach { contentView.addSubview($0) }
        [stateButton, formatButton, formatSpacer].forEach { stateFormatStackView.addArrangedSubview($0) }
        [startDateLabel, dateSpacer, endDateLabel].forEach { dateStackView.addArrangedSubview($0) }
        [likeButton, journalButton].forEach { bottomButtonStackView.addArrangedSubview($0) }
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
        coverImageView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(170)
        }
        stateFormatStackView.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }
                   
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stateFormatStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        publisherLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(publisherLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        startDateLabel.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(32)
            $0.leading.equalTo(dateStackView.snp.leading)
        }
        endDateLabel.snp.makeConstraints {
            $0.width.equalTo(88)
            $0.height.equalTo(32)
            $0.trailing.equalTo(dateStackView.snp.trailing)
        }
        tagsStackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(bottomButtonStackView.snp.top).offset(-20)
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
                guard let self = self else { return }
                let journalVC = JournalViewController()
                self.navigationController?.pushViewController(journalVC, animated: true)
            }
            .disposed(by: disposeBag)
        // 좋아요 버튼
        likeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.likeButton.isSelected.toggle()
                
                // 추후 데이터 저장 로직 필요
            })
            .disposed(by: disposeBag)
    }
    
    private func displayBookInfo() {
        guard let bookData = book else {
            print("책 정보를 불러올 수 없습니다")
            return
        }
        
        if let imageData = book?.coverImage, let image = UIImage(data: imageData) {
            coverImageView.image = image
        } else {
            coverImageView.image = nil
        }
        if let state = book?.readingState, !state.isEmpty {
            stateFormatStackView.isHidden = false
            stateButton.isHidden = false
            
            var selectedBgColor: UIColor?
            var selectedBoarderColor: UIColor?
            
            switch state {
            case "읽는 중":
                selectedBgColor = .readingSelected
                selectedBoarderColor = .readingSelected
            case "중단":
                selectedBgColor = .finishedSelected
                selectedBoarderColor = .finishedSelected
            case "완독":
                selectedBgColor = .pausedSelected
                selectedBoarderColor = .pausedSelected
            case "읽을 예정":
                selectedBgColor = .scheduledSelected
                selectedBoarderColor = .scheduledSelected
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
                    selectedBgColor = .paperBGColor
                    selectedTitleColor = .paperTextColor
                case "전자책":
                    selectedBgColor = .ebookBGColor
                    selectedTitleColor = .ebookTextColor
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
        
        dateStackView.isHidden = hasStartDate == hasEndDate
        dateStackView.isHidden = !hasStartDate && !hasEndDate
        
        if let tagsString = bookData.selectedTags, !tagsString.isEmpty {
            setupDetailTags(tagsString: tagsString)
            tagsStackView.isHidden = false
        } else {
            tagsStackView.isHidden = true
        }
        view.layoutIfNeeded()
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
    

}
