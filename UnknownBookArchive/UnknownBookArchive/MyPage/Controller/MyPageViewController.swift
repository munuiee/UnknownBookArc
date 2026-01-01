// MARK: 마이페이지 뷰컨트롤러

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MessageUI

final class MyPageViewController: UIViewController {

    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()

    private let hiddenYearField = UITextField(frame: .zero)
    private let yearPicker = UIPickerView()
    private var years: [Int] = []

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupYearPicker()
        bind()
        setupActions()
        bindTouchEvents()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        // 화면 재진입 시 선택 연도 기준으로 UI/통계 갱신
        myPageView.setSelectedYear(viewModel.selectedYear.value)
        viewModel.refresh()
    }

    // MARK: - bind
    private func bind() {
        viewModel.monthCompletedCount
            .map { String($0) }
            .bind(to: myPageView.monthCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.yearCompletedCount
            .map { String($0) }
            .bind(to: myPageView.yearCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: - Year Picker Setup
    private func setupYearPicker() {
        view.addSubview(hiddenYearField)
        hiddenYearField.isHidden = true

        let currentYear = Calendar.current.component(.year, from: Date())
        let startYear = 2025
        years = Array(startYear...currentYear).reversed()

        yearPicker.dataSource = self
        yearPicker.delegate = self
        hiddenYearField.inputView = yearPicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(donePickingYear))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flex, done]
        hiddenYearField.inputAccessoryView = toolbar

        // 기본 선택: 현재 연도
        viewModel.setSelectedYear(currentYear)
        myPageView.setSelectedYear(currentYear)

        if let idx = years.firstIndex(of: currentYear) {
            yearPicker.selectRow(idx, inComponent: 0, animated: false)
        }


        myPageView.activeTapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.hiddenYearField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)


    }

    @objc private func donePickingYear() {
        hiddenYearField.resignFirstResponder()
    }

    // ---------------------------------------
    // MARK: 버튼 클릭 시 배경색 변경되는 효과
    private func bindTouchEvents() {
        [
            myPageView.shareButton,
            myPageView.reviewButton,
            myPageView.communicationButton
        ].forEach { bindTouchEvents(for: $0) }
    }

    private func bindTouchEvents(for button: UIButton) {
        button.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.buttonTouchDown(button)
            })
            .disposed(by: disposeBag)

        button.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel])
            .subscribe(onNext: { [weak self] in
                self?.buttonTouchUp(button)
            })
            .disposed(by: disposeBag)
    }

    private func setupActions() {
        myPageView.shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleShareTap()
            })
            .disposed(by: disposeBag)

        myPageView.reviewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleReviewTap()
            })
            .disposed(by: disposeBag)

        myPageView.communicationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleMailTap()
            })
            .disposed(by: disposeBag)
    }

    private func buttonTouchDown(_ button: UIButton) {
        UIView.animate(withDuration: 0.08) {
            button.backgroundColor = .myPageButtonSelectedFillColor
            button.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    private func buttonTouchUp(_ button: UIButton) {
        UIView.animate(withDuration: 0.08) {
            button.backgroundColor = .myPageButtonSelectedAfterColor
            button.transform = .identity
        }
    }
    // ---------------------------------------

    // MARK: Share / Review / Mail

    private func handleShareTap() {
        let shareText = "가볍게 독서 기록을 남길 수 있는 '낯선책방'을 소개합니다 📚"
        let appURL = URL(string: "https://apps.apple.com/kr/app/%EB%82%AF%EC%84%A0%EC%B1%85%EB%B0%A9/id6756062952")!
        let itemSource = AppShareItemSource(appURL: appURL, messageText: shareText)
        let activityVC = UIActivityViewController(activityItems: [itemSource], applicationActivities: nil)
        activityVC.modalPresentationStyle = .pageSheet
        present(activityVC, animated: true)
    }

    private func handleReviewTap() {
        let appID = "6756062952"
        let urlString = "https://apps.apple.com/app/id\(appID)?action=write-review"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func handleMailTap() {
        let email = "jyeee0421@icloud.com"
        let subject = "[낯선책방] 문의 및 건의하기"
        let body = ""

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
            return
        }
        showNoMailAppAlert()
    }

    private func showNoMailAppAlert() {
        let alert = UIAlertController(
            title: "메일 앱을 찾을 수 없어요",
            message: "문의 메일을 보내시려면 Mail, Gmail 같은 메일 앱을 설치하거나 계정을 설정해 주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension MyPageViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(years[row])년"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = years[row]
        myPageView.setSelectedYear(year)
        viewModel.setSelectedYear(year)   
    }
}

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        controller.dismiss(animated: true)
    }
}
