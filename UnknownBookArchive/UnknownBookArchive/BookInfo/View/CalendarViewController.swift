import UIKit
import FSCalendar
import SnapKit


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    var onDateSelected: ((Date) -> Void)?
    
    var minimumDate: Date?
    var maximumDate: Date?
    var shouldSetMinimumDate: Bool = true
    
    let containerView: UIView = {
        let cv = UIView()
        cv.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cv.layer.shadowOffset = CGSize(width: 1, height: 4)
        cv.layer.shadowRadius = 10
        cv.layer.shadowOpacity = 1
        return cv
    }()
    let calendarWrapperView: UIView = {
        let cwv = UIView()
        cwv.backgroundColor = .paragraphCellBackgroundColor
        cwv.layer.cornerRadius = 25
        cwv.clipsToBounds = true
        return cwv
    }()
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.backgroundColor = .paragraphCellBackgroundColor
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.titleDefaultColor = .bookTitleTextColor
        calendar.appearance.todayColor = .mainJournalButtonColor
        calendar.appearance.titleTodayColor = .mainJournalTextColor
        calendar.appearance.selectionColor = .mainJournalButtonColor
        calendar.appearance.weekdayTextColor = .bookTitleTextColor
        calendar.appearance.headerTitleColor = .mainLabelColor
        calendar.appearance.titleFont = .mediumFont(ofSize: 14)
        return calendar
    }()
    
    let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundModeColor
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        calendarWrapperView.addSubview(calendar)
        containerView.addSubview(calendarWrapperView)
        view.addSubview(containerView)
    }
    
    private func setConstraints() {
        calendar.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
            $0.width.equalTo(315)
            $0.height.equalTo(367)
        }
        calendarWrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        if !shouldSetMinimumDate {
            let pastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date()) ?? Date()
            return pastDate
        }
        return minimumDate ?? Date()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        
        if let maxDate = maximumDate {
            return maxDate
        }
        return Calendar.current.date(byAdding: .year, value: 10, to: Date()) ?? Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        onDateSelected?(date)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleTapOutside() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view, touchView.isDescendant(of: containerView) {
            return false
        }
        return true
    }
    
}
