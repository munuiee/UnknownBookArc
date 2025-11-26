
// MARK: - 찰나의 기록 페이지

import Foundation
import UIKit
import SnapKit

final class MomentViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let chatView = UIView()
    private let buttonView = UIView()
    private let inputText = UITextView()
    private let sendButton = UIButton()
    
    private let viewModel = MomentListViewModel()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    private var chatViewBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        addKeyboardNotification()
        inputTextUI()
        collectionSet()
        
        viewModel.onUpdateMoment = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onUpdateMoment = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            //self.scrollToLastItem()
        }
        
        viewModel.fetchMoments()
        collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - CollectionView 세팅
    
    private func collectionSet() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MomentCell.self,
                                forCellWithReuseIdentifier: MomentCell.id)
        
        // 🔹 헤더 등록
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
        
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
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
            leading: 16,
            bottom: 20,
            trailing: 16
        )
        section.interGroupSpacing = 16
        
        // 🔹 섹션 헤더 (날짜 바)
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
        [inputText, buttonView].forEach { chatView.addSubview($0) }
        buttonView.addSubview(sendButton)
        
        chatView.backgroundColor = .white
        chatView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            chatViewBottomConstraint = $0.bottom.equalTo(view.snp.bottom).constraint
            $0.height.equalTo(92)
        }
        inputText.backgroundColor = UIColor(
            red: 250/255,
            green: 250/255,
            blue: 250/255,
            alpha: 1
        )
        inputText.layer.cornerRadius = 8
        inputText.font = .systemFont(ofSize: 16, weight: .medium)
        inputText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.5)
            $0.bottom.equalToSuperview().inset(42.5)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(buttonView.snp.leading).offset(-8)
            $0.height.equalTo(40)
        }
        
        buttonView.backgroundColor = UIColor(
            red: 31/255,
            green: 56/255,
            blue: 127/255,
            alpha: 1
        )
        buttonView.layer.cornerRadius = 21
        buttonView.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(42.5)
        }
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let image = UIImage(systemName: "arrow.up", withConfiguration: config)
        sendButton.setImage(image, for: .normal)
        sendButton.tintColor = .white
        sendButton.snp.makeConstraints {
            $0.center.equalToSuperview()
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
        
        chatViewBottomConstraint?.update(offset: -overlap)
        
        let options = UIView.AnimationOptions(rawValue: curveValue << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func didTapSend() {
        let text = inputText.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.isEmpty == false else { return }
        
        viewModel.addMoment(text: text)
        
        inputText.text = ""
        inputText.resignFirstResponder()
    }
    
    private func scrollToBottom() {
        let section = 0
        let itemCount = collectionView.numberOfItems(inSection: section)
        guard itemCount > 0 else { return }
        
        let indexPath = IndexPath(item: itemCount - 1, section: section)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    private func scrollToLastItem() {
        let sectionCount = viewModel.numberOfSections
        guard sectionCount > 0 else { return }
        
        let lastSection = sectionCount - 1
        let itemCount = viewModel.numberOfItems(in: lastSection)
        guard itemCount > 0 else { return }
        
        let indexPath = IndexPath(item: itemCount - 1, section: lastSection)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
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
    
    // 🔹 헤더 (날짜 바)
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


