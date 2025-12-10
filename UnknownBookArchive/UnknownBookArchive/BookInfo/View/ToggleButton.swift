// MARK: 퍼센트/페이지 토글 버튼

import UIKit
import SnapKit

class ToggleButton: UIControl {
    
    private let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .toggleSelectedBackgroundColor
        view.clipsToBounds = true
        view.layer.cornerRadius = (30 - 6) / 2
        return view
    }()
    private let pLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.regularFont(ofSize: 15)
        return label
    }()
    private let percentLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.regularFont(ofSize: 15)
        return label
    }()
    var isPageMode: Bool = true {
        didSet {
            animateThumb()
            updateLabelColors()
            sendActions(for: .valueChanged)  // 외부에서 값 변경 감지 용
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .toggleBackgroundColor
        layer.cornerRadius = 15
        clipsToBounds = true
        
        [thumbView, pLable, percentLable].forEach { addSubview($0) }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
        configure(initialPageMode: true)

    }
    private func setConstraints() {
        self.snp.makeConstraints {
            $0.width.equalTo(51)
            $0.height.equalTo(30)
        }
        thumbView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(thumbView.snp.height)
        }
        
        pLable.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(3)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        percentLable.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(2)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    @objc
    private func handleTap() {
        isPageMode.toggle()
    }
    
    func configure(initialPageMode: Bool, pageTitle: String = "P", percentTitle: String = "%") {
        pLable.text = pageTitle
        percentLable.text = percentTitle
        self.isPageMode = initialPageMode
    }
    // 슬라이드 애니메이션
    private func animateThumb() {
        thumbView.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(thumbView.snp.height)
            
            if isPageMode {
                $0.leading.equalToSuperview().inset(3)
            } else {
                $0.trailing.equalToSuperview().inset(3)
            }
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // label 색상 변경 함수
    private func updateLabelColors() {
        if isPageMode {
            pLable.textColor = .toggleSelectedTextColor
            percentLable.textColor = .toggleUnselectedTextColor
            
        } else {
            pLable.textColor = .toggleUnselectedTextColor
            percentLable.textColor = .toggleSelectedTextColor
        }
    }
}
