// MARK: 찰나의 기록 페이지

import Foundation
import UIKit
import SnapKit

final class MomentViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    private let chatView = UIView()
    private let buttonView = UIView()
    private let inputPage = UITextField()
    private let inputText = UITextView()
    private let sendButton = UIButton()
    private let inputContainer = UIView()
    private let separatorView = UIView()
    private let textPlaceholderLabel = UILabel()
    private let maxTextViewHeight: CGFloat = 132
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    private var chatViewBottomConstraint: Constraint?
    
    private let viewModel: MomentListViewModel
    private let book: Book
    
    init(book: Book) {
        self.book = book
        self.viewModel = MomentListViewModel(book: book)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var records: [MomentEntity] = []
    var moments: MomentEntity?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        addKeyboardNotification()
        inputTextUI()
        collectionSet()
        
        
        viewModel.onUpdateMoment = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
        viewModel.fetchMoments()
        
        if let moments = moments {
            inputPage.text = moments.momentPage
            inputText.text = moments.momentText
            if let text = moments.momentText {
                textPlaceholderLabel.isHidden = !text.isEmpty
            }
        } else {
            inputText.text = ""
            textViewDidChange(inputText)
        }
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textViewDidChange(inputText)
    }
    
    
    // MARK: - CollectionView 세팅
    private func collectionSet() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MomentCell.self,
                                forCellWithReuseIdentifier: MomentCell.id)
        
        // 헤더 등록
        collectionView.register(
            DateHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DateHeaderView.id
        )
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(chatView.snp.top)
        }
        
        collectionView.backgroundColor = .white
    }
    
    
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 0,
            bottom: 20,
            trailing: 0
        )
        section.interGroupSpacing = 16
        
        // 섹션 헤더 (날짜 바)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .absolute(152),
            heightDimension: .estimated(32)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 4, trailing: 0)
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - 아래 입력창 UI
    
    private func inputTextUI() {
        view.addSubview(chatView)
        [inputContainer, buttonView].forEach { chatView.addSubview($0) }
        buttonView.addSubview(sendButton)
        
        chatView.backgroundColor = .white
        chatView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).constraint
            chatViewBottomConstraint = $0.bottom.equalTo(view.snp.bottom).constraint
            // $0.height.equalTo(126)
            
        }
        
        buttonView.backgroundColor = .white
        buttonView.layer.cornerRadius = 21
        buttonView.layer.masksToBounds = false
        
        buttonView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        buttonView.layer.shadowOpacity = 1
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 8)
        buttonView.layer.shadowRadius = 32
        
        buttonView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(42)
            $0.width.height.equalTo(42)
        }
        
        
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "arrow.up", withConfiguration: config)
        sendButton.setImage(image, for: .normal)
        sendButton.tintColor = UIColor(red: 0.10196, green: 0.09804, blue: 0.09804, alpha: 1.0)
        sendButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        inputContainer.backgroundColor = .clear
        inputContainer.layer.cornerRadius = 8
        inputContainer.layer.masksToBounds = false
        inputContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        inputContainer.layer.shadowOpacity = 1
        inputContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
        inputContainer.layer.shadowRadius = 32
        inputContainer.snp.makeConstraints {
            $0.width.equalTo(285)
            $0.height.greaterThanOrEqualTo(76)
            $0.height.lessThanOrEqualTo(172) // 132 + 40 (대략)
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(buttonView.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().inset(42)
        }
        
        
        let blurBackgroundView = UIView()
        blurBackgroundView.layer.cornerRadius = 10
        blurBackgroundView.clipsToBounds = true
        
        inputContainer.addSubview(blurBackgroundView)
        blurBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blurBackgroundView.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 블랙 10% 오버레이
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        blurBackgroundView.addSubview(dimView)
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let whiteContentView = UIView()
        whiteContentView.backgroundColor = .white
        whiteContentView.layer.cornerRadius = 10
        whiteContentView.layer.masksToBounds = true
        
        inputContainer.addSubview(whiteContentView)
        whiteContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 블러보다 위에 오게
        inputContainer.bringSubviewToFront(whiteContentView)
        
        
        
        
        [inputPage, separatorView, inputText].forEach { whiteContentView.addSubview($0) }
        
        inputPage.placeholder = "책의 페이지를 기록해 주세요"
        inputPage.font = UIFont.regularFont(ofSize: 14)
        inputPage.textColor = UIColor.colorB4B2B2
        inputPage.keyboardType = .numberPad
        inputPage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(24)
        }
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        inputPage.leftView = padding
        inputPage.leftViewMode = .always
        
        
        
        
        // 가운데 선
        separatorView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(inputPage.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(0.5)
        }
        
        // 아래 본문 입력
        inputText.delegate = self
        inputText.backgroundColor = .white
        inputText.font = UIFont.regularFont(ofSize: 14)
        inputText.isScrollEnabled = true
        inputText.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 6, right: 4)
        
        inputText.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(6)
            $0.height.lessThanOrEqualTo(150)
        }
        
        
        
        textPlaceholderLabel.text = "내용을 입력하세요."
        textPlaceholderLabel.textColor = UIColor(named: "placeholderColor")
        textPlaceholderLabel.font = UIFont.regularFont(ofSize: 13.8)
        inputText.addSubview(textPlaceholderLabel)
        textPlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(7.5)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboard(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    
    // MARK: 키보드가 올라오고 내려갈 때 chatView 조절
    @objc private func handleKeyboard(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let keyboardFrame = frameValue.cgRectValue
        let keyboardInView = view.convert(keyboardFrame, from: nil)
        
        // 키보드가 화면 안에 있을 때만 overlap 계산
        let safeBottom = view.safeAreaInsets.bottom
        let overlap = max(0, view.bounds.height - keyboardInView.origin.y - safeBottom)
        
        // 입력창을 키보드 높이만큼
        chatViewBottomConstraint?.update(offset: -overlap)
        
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func didTapSend() {
        let pageText = inputPage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let text = inputText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.isEmpty == false else { return }
        
        viewModel.addMoment(text: text, page: pageText)
        
        inputPage.text = ""
        inputText.text = ""
        textPlaceholderLabel.isHidden = false
        inputText.resignFirstResponder()
        
        textViewDidChange(inputText)
    }
    
    // 단일섹션의 경우
    private func scrollToBottom() {
        let section = 0
        let itemCount = collectionView.numberOfItems(inSection: section)
        guard itemCount > 0 else { return }
        
        let indexPath = IndexPath(item: itemCount - 1, section: section)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    // 다중섹션의 경우
    private func scrollToLastItem() {
        let sectionCount = viewModel.numberOfSections
        guard sectionCount > 0 else { return }
        
        let lastSection = sectionCount - 1
        let itemCount = viewModel.numberOfItems(in: lastSection)
        guard itemCount > 0 else { return }
        
        let indexPath = IndexPath(item: itemCount - 1, section: lastSection)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    // 탭 했을 때 키보드 숨기기
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: chatView) == true {
            return false
        }
        return true
    }
    
    
}

extension MomentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MomentCell.id,
            for: indexPath
        ) as? MomentCell
        else {
            return UICollectionViewCell()
        }
        
        //        cell.editTapped = { [weak self] in
        //            guard let self = self else { return }
        //            // 수정 액션
        //        }
        
        cell.deleteTapped = { [weak self] in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: "삭제",
                message: "이 기록을 삭제할까요?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.viewModel.delete(at: indexPath)
            })
            
            self.present(alert, animated: true)
        }
        
        cell.configure(
            mPage: viewModel.page(at: indexPath),
            mText: viewModel.text(at: indexPath),
            mDate: viewModel.mdateText(at: indexPath),
            mTime: viewModel.mTimeText(at: indexPath)
        )
        
        return cell
    }
    
    // 헤더
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: DateHeaderView.id,
            for: indexPath
        ) as! DateHeaderView
        
        let date = viewModel.dateForSection(indexPath.section)
        header.configure(date: date)
        return header
    }
    
}

extension MomentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textPlaceholderLabel.isHidden = !textView.text.isEmpty
        
        let isEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if isEmpty {
            // 입력 없음
            buttonView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
            sendButton.tintColor = UIColor(red: 0.10196, green: 0.09804, blue: 0.09804, alpha: 1.0)
        } else {
            // 입력 있음
            buttonView.backgroundColor = .primaryColor
            sendButton.tintColor = .white
        }
        
        let contentHeight = textView.contentSize.height
        if contentHeight > maxTextViewHeight {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}
