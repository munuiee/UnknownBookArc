import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData


class ProgressEditViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var book: Book
    var completion: ((Book) -> Void)?
    
    // MARK: UI
    private let topView = TopView()
    private let progressStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .horizontal
        stView.spacing = 12
        stView.alignment = .center
        return stView
    }()
    
    private let toggleButton = ToggleButton()
    private let pageTextField = BaseTextField()
    private let totalPageTextField = BaseTextField()
    private let percentTextField = BaseTextField()
 
    private let inputStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 8
        st.distribution = .fillEqually
        return st
    }()
    
    init(book: Book) {
            self.book = book
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setConstraints()
        setupTopView()
        setupProgressUI()
        setupUIWithExistingBook()
        bind()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureUI() {
        [topView, progressStackView].forEach { view.addSubview($0) }
        [inputStackView, toggleButton].forEach { progressStackView.addArrangedSubview($0) }

    }
    
    private func setConstraints() {
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview()
        }
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        inputStackView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
 
        toggleButton.snp.makeConstraints {
            $0.width.equalTo(51)
            $0.height.equalTo(40)
        }
    }
    
    private func setupTopView() {
        let saveConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let saveImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: saveConfig)
        topView.configure(title: "진행률 수정", rightButtonImage: saveImage)
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
    private func bind() {
        topView.rightButtonTap
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] in
                self?.saveBookProgress()
            })
            .disposed(by: disposeBag)
        
        topView.backButtonTap
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        toggleButton.rx.controlEvent(.valueChanged)
            .bind { [weak self] in
                self?.handleToggleTap()
            }
            .disposed(by: disposeBag)
    }
    
    // 페이지, 퍼센트 모드 토글 버튼 탭
    private func handleToggleTap() {
        let isPageMode = toggleButton.isPageMode
        
        inputStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if isPageMode {
            [pageTextField, totalPageTextField].forEach { inputStackView.addArrangedSubview($0) }
            inputStackView.distribution = .fillEqually
        } else {
            inputStackView.addArrangedSubview(percentTextField)
            inputStackView.distribution = .fill
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupUIWithExistingBook() {
        toggleButton.isPageMode = book.isPageMode
        pageTextField.text = (book.currentPage > 0) ? String(book.currentPage) : nil
        totalPageTextField.text = (book.totalPage > 0) ? String(book.totalPage) : nil
        percentTextField.text = (book.percent > 0) ? String(book.percent) : nil
        handleToggleTap()
    }
    
    private func saveBookProgress() {
        let isPageMode = toggleButton.isPageMode
        // 페이지 수
        let currentPage = Int32(pageTextField.text ?? "0") ?? 0
        let totalPage = Int32(totalPageTextField.text ?? "0") ?? 0
        
        let maxPageValue: Int32 = 9999
        
        if totalPage > maxPageValue || currentPage > maxPageValue {
            showAlert(title: "페이지 입력 오류", message: "페이지 수는 9,999페이지를 초과할 수 없습니다.")
            return
        }
        
        if totalPage > 0 && currentPage > totalPage {
            showAlert(title: "페이지 입력 오류", message: "읽은 페이지가 전체 페이지보다 클 수 없습니다.")
            return
        }
        
        let percentText = percentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let percent = Int32(percentText) ?? 0
        if !percentText.isEmpty && (percent < 0 || percent > 100) {
            showAlert(title: "진행률 입력 오류", message: "0부터 100 사이의 값만 입력할 수 있습니다.")
            return
        }
        
        // CoreData 수정
        guard let exsitingUUID = self.book.uuid else {
            showAlert(title: "오류", message: "책을 찾을 수 없습니다.")
            return
        }
        self.book.isPageMode = isPageMode
        self.book.currentPage = currentPage
        self.book.totalPage = totalPage
        self.book.percent = percent
        
        let isSuccess = CoreDataManager.shared.updateProgress(uuid: exsitingUUID, isPageMode: isPageMode, currentPage: currentPage, totalPage: totalPage, percent: percent, lastModifiedDate: Date())
        if isSuccess {
            self.completion?(self.book)
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "저장 실패", message: "책 진행률 수정에 실패했습니다.")
        }

    }

}

