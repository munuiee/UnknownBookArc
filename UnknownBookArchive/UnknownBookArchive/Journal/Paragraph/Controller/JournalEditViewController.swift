// MARK: - 저널 '문단 수집' 추가/편집 페이지

import Foundation
import SnapKit
import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import Vision
import VisionKit



final class JournalEditViewController: UIViewController, UIGestureRecognizerDelegate {
    private let journalEditView = JournalEditView()
    private let viewModel: JournalEditViewModel
    private let book: Book
    private let journalType: String
    private let disposeBag = DisposeBag()
    
    var journal: Journal?
    
    init(journal: Journal?, book: Book, type: String) {
        self.book = book
        self.journalType = type
        self.journal = journal
        self.viewModel = JournalEditViewModel(journal: journal, book: book, type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = journalEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundModeColor
        hidesBottomBarWhenPushed = true
        
        if journal == nil {
            AnalyticsManager.shared.logJournalStarted(type: "paragraph")
        }
        
        bindActions()
        bindEdit()
        bindMainFieldFocus()
        bindPageFieldFocus()
        updateSaveButtonState()
        bindTapGesture()
        bindKeyboard()
        
        viewModel.onSaved = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = [.down]
        view.addGestureRecognizer(swipe)
        
        
        if let journal = journal {
            journalEditView.pageField.text = journal.savedPage
            journalEditView.mainField.text = journal.journalText
            if let text = journal.journalText {
                journalEditView.mainPlaceholderLabel.isHidden = !text.isEmpty
            }
            updateSaveButtonState()
        }
    }
    
    
    private var didSetInitialHeight = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didSetInitialHeight else { return }
        
        didSetInitialHeight = true
        
        let safeHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let expandedHeight = min(512, safeHeight - 40)
        journalEditView.mainFieldHeightConstraint?.update(offset: expandedHeight)
    }
    
    
    
    // MARK: bind - 버튼 터치 이벤트 액션
    private func bindActions() {
        journalEditView.backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapBackButton()
            })
            .disposed(by: disposeBag)
        
        journalEditView.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.saveButtonTapped()
            })
            .disposed(by: disposeBag)
        
        journalEditView.scanButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapScanButton()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEdit() {
        Observable.combineLatest(
            journalEditView.pageField.rx.text.orEmpty,
            journalEditView.mainField.rx.text.orEmpty
        )
        .subscribe(onNext: { [weak self] page, text in
            self?.journalEditView.mainPlaceholderLabel.isHidden = !text.isEmpty
            self?.updateSaveButtonState()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        tap.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.dismissKeyboard()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.handleKeyboard(notification)
            })
            .disposed(by: disposeBag)
    }
    

    
    // MARK: 뒤로가기 버튼
    private func didTapBackButton() {
        if saveCheck() {
            let alert = UIAlertController(title: "나가기", message: "작성한 내용이 저장되지 않았어요. 나가시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "나가기", style: .destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            present(alert, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: 저장 버튼
    private func saveButtonTapped() {
        let page = journalEditView.pageField.text ?? ""
        let text = journalEditView.mainField.text ?? ""
        let currentLiked = journal?.liked ?? false
        
        viewModel.saveButtonTapped(journal: journal, savedPage: page, journalText: text, liked: currentLiked)
    }
    
    
    private func updateSaveButtonState() {
        let newPage = (journalEditView.pageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let newText = (journalEditView.mainField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let journal = journal else {
            journalEditView.saveButton.isEnabled = !newPage.isEmpty && !newText.isEmpty
            return
        }
        let oldPage = (journal.savedPage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let oldText = (journal.journalText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let hasTextChanged = (newPage != oldPage) || (newText != oldText)
        journalEditView.saveButton.isEnabled = !newPage.isEmpty && !newText.isEmpty && hasTextChanged
    }
    
    // MARK: 키보드
    
    // 키보드 높이 설정
    private func handleKeyboard(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let keyboardFrame = frameValue.cgRectValue
        let keyboardInView = view.convert(keyboardFrame, from: nil)
        
        // 키보드가 화면 안에 얼마나 들어와 있는지 계산
        let safeBottom = view.safeAreaInsets.bottom
        let overlap = max(0, view.bounds.height - keyboardInView.origin.y - safeBottom)
        let isKeyboardVisible = overlap > 0
        let safeHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let expandedHeight = safeHeight * 0.65
        let heightWhenKeyboard = safeHeight - overlap
        let collapsedHeight = max(heightWhenKeyboard * 0.65, 200)
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        
        journalEditView.mainFieldHeightConstraint?.update(offset: isKeyboardVisible ? collapsedHeight : expandedHeight)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 키보드 제스처
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: journalEditView.mainField) == true {
            return false
        }
        return true
    }
    
    private func saveCheck() -> Bool {
        let newPage = (journalEditView.pageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let newText = (journalEditView.mainField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let editPage = (journal?.savedPage ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let editText = (journal?.journalText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let textChanged = (newPage != editPage) || (newText != editText)
        return textChanged
    }
    
    
    // MARK: 텍스트필드/텍스트뷰 클릭 시 border 적용
    private func bindPageFieldFocus() {
        journalEditView.pageField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let field = self?.journalEditView.pageField else { return }
                field.layer.borderWidth = 1
                field.dynamicBorder = UIColor.editSelectedBorderColor
            })
            .disposed(by: disposeBag)
        
        journalEditView.pageField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                self?.journalEditView.pageField.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMainFieldFocus() {
        journalEditView.mainField.rx.didBeginEditing
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.journalEditView.mainField.layer.borderWidth = 1
                self.journalEditView.mainField.dynamicBorder = UIColor.editSelectedBorderColor
            })
            .disposed(by: disposeBag)
        
        journalEditView.mainField.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.journalEditView.mainField.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 스캔 버튼 액션
    @objc func didTapScanButton() {
        checkCameraPermission {
            self.openCamera()
        }
    }

    // MARK: - 카메라 권한 체크
    func checkCameraPermission(granted: @escaping () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            granted()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { ok in
                if ok { DispatchQueue.main.async { granted() } }
            }
        case .denied, .restricted:
            let alert = UIAlertController(
                title: "카메라 권한 필요",
                message: "책 페이지 스캔을 위해 카메라 권한이 필요합니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(alert, animated: true)
        @unknown default:
            break
        }
    }

    // MARK: - 카메라 열기
    func openCamera() {
        guard VNDocumentCameraViewController.isSupported else { return }
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        present(scanner, animated: true)
    }
    
    // MARK: - OCR
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            DispatchQueue.main.async {
                self?.correctWithLLM(text, fallback: text)
                self?.journalEditView.mainPlaceholderLabel.isHidden = !text.isEmpty
                self?.updateSaveButtonState()
            }
        }
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko", "en"]
        
        DispatchQueue.global().async {
            try? VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
        }
    }
    
    // MARK: - LLM 교정
    func correctWithLLM(_ text: String, fallback: String) {
        // 로딩 시작
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.center = journalEditView.mainField.center
            indicator.tag = 999
            journalEditView.mainField.addSubview(indicator)
            indicator.startAnimating()
            journalEditView.mainField.text = ""
            journalEditView.mainPlaceholderLabel.isHidden = true
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        let apiKey = Bundle.main.infoDictionary?["ANTHROPIC_API_KEY"] as? String ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let body: [String: Any] = [
            "model": "claude-haiku-4-5-20251001",
            "max_tokens": 4096,
            "messages": [
                ["role": "user", "content": """
                  다음은 책 페이지를 OCR로 스캔한 텍스트입니다.
                  오탈자, 깨진 글자, 줄바꿈 오류를 교정해주세요.
                  불필요한 줄바꿈을 제거하고 문단 단위로만 줄바꿈하세요.
                  원문의 의미는 절대 변경하지 마세요.
                  교정된 텍스트만 출력하세요. 설명이나 부가 텍스트 없이.
                ---
                \(text)
                ---
                """]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
               DispatchQueue.main.async {
                   self?.journalEditView.mainField.viewWithTag(999)?.removeFromSuperview()
               }
               
               if let error = error {
                   print("❌ API Error: \(error)")
                   DispatchQueue.main.async {
                       self?.journalEditView.mainField.text = fallback
                       self?.updateSaveButtonState()
                   }
                   return
               }
               
               guard let data = data,
                     let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                     let content = json["content"] as? [[String: Any]],
                     let corrected = content.first?["text"] as? String
               else {
                   print("❌ 파싱 실패")
                   DispatchQueue.main.async {
                       self?.journalEditView.mainField.text = fallback
                       self?.updateSaveButtonState()
                   }
                   return
               }
               
               DispatchQueue.main.async {
                   self?.journalEditView.mainField.text = corrected
                   self?.journalEditView.mainPlaceholderLabel.isHidden = true
                   self?.updateSaveButtonState()
               }
           }.resume()
       }

}


// MARK: - 촬영 완료
extension JournalEditViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                      didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        guard scan.pageCount > 0 else { return }
        let image = scan.imageOfPage(at: 0)
        recognizeText(from: image)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}
