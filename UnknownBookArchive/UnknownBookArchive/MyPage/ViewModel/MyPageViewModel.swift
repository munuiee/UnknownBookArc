// MARK: 마이페이지 ViewModel

import Foundation
import RxSwift
import RxRelay

final class MyPageViewModel {

    let monthCompletedCount = PublishRelay<Int>()
    let yearCompletedCount = PublishRelay<Int>()

    let selectedYear = BehaviorRelay<Int>(value: Calendar.current.component(.year, from: Date()))

    let coreDataManager: CoreDataManager
    let disposeBag = DisposeBag()

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func viewDidLoad() {
        refresh()
    }

    func setSelectedYear(_ year: Int) {
        selectedYear.accept(year)
        refresh()
    }
    
    func fetchMonthCompletedCount() {
        refresh()
    }

    func fetchYearCompletedCount() {
        refresh()
    }


    func refresh() {
        let cal = Calendar.current
        let year = selectedYear.value

        let currentMonth = cal.component(.month, from: Date())

        let yearBase = cal.date(from: DateComponents(year: year, month: 1, day: 1))!
        let monthBase = cal.date(from: DateComponents(year: year, month: currentMonth, day: 1))!

        let monthCount = coreDataManager.countCompletedBooksInMonth(baseDate: monthBase)
        let yearCount = coreDataManager.countCompletedBooksInYear(baseDate: yearBase)

        monthCompletedCount.accept(monthCount)
        yearCompletedCount.accept(yearCount)
    }
}
