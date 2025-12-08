
import Foundation
import RxSwift
import RxRelay

class MyPageViewModel {
    let monthCompletedCount = PublishRelay<Int>()
    let yearCompletedCount = PublishRelay<Int>()
    
    let coreDataManager: CoreDataManager
    let disposeBag = DisposeBag()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func viewDidLoad() {
        fetchMonthCompletedCount()
    }
    
    func fetchMonthCompletedCount() {
        let count = coreDataManager.countCompletedBooksInMonth()
        monthCompletedCount.accept(count)
    }
    func fetchYearCompletedCount() {
        let count = coreDataManager.countCompletedBooksInYear()
        yearCompletedCount.accept(count)
    }
    
    
}
