// MARK: 마이페이지

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MessageUI

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    
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
        bind()
        setupActions()
        bindTouchEvents()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.fetchMonthCompletedCount()
        viewModel.fetchYearCompletedCount()
    }
    
    
    
    // MARK: bind함수
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
    
    // ---------------------------------------
    // MARK: 버튼 클릭 시 배경색 변경되는 효과
    private func bindTouchEvents() {
        [
            myPageView.shareButton,
            myPageView.reviewButton,
            myPageView.communicationButton
        ].forEach {
            bindTouchEvents(for: $0)
        }
    }
    
    private func bindTouchEvents(for button: UIButton) {
        
        // 터치 다운 (손가락 닿은 순간)
        button.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.buttonTouchDown(button)
            })
            .disposed(by: disposeBag)
        
        // 터치 업 (눌렀다가 뗀 순간 — 탭 완료되었을 때)
        button.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel])
            .subscribe(onNext: { [weak self] in
                self?.buttonTouchUp(button)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupActions() {
        // 추천버튼 클릭
        myPageView.shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleShareTap()
            })
            .disposed(by: disposeBag)
        
        // 리뷰버튼 클릭
        myPageView.reviewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleReviewTap()
            })
            .disposed(by: disposeBag)
        
        // 메일버튼 클릭
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

    // 추천 버튼 클릭시 모달 뷰
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

        // 1) 애플 메일 계정 연결되어 있으면 → 모달로 띄우기 (그대로 유지)
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

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        controller.dismiss(animated: true)
    }
}
