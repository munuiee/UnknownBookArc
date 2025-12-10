// MARK: 저널 '찰나의 기록' 날짜 헤더뷰

import UIKit
import SnapKit

final class DateHeaderView: UICollectionReusableView {
    static let id = "DateHeaderView"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        backgroundColor = .momentDateBadgeBackgroundColor
        layer.cornerRadius = 8
        clipsToBounds = true
        
        label.font = UIFont.mediumFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .momentDateBadgeTextColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        label.text = formatter.string(from: date)
    }
}
