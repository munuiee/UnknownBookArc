
import Foundation

final class JournalViewModel {
    private(set) var tabItems: [String] = ["문단 수집", "찰나의 기록"]
    
    private(set) var currentPage: Int = 0 {
        didSet {
            onPageChanged?(currentPage)
        }
    }
    
    func setPage(index: Int) {
        guard index >= 0, index < tabItems.count else { return }
        guard index != currentPage else { return }
        currentPage = index
    }
    
    var numberOfTabs: Int {
        return tabItems.count
    }
    
    func titleForTab(index: Int) -> String {
        guard index >= 0, index < tabItems.count else { return "" }
        return tabItems[index]
    }
    
    func pageType(at index: Int) -> JournalPageType {
        index == 0 ? .paragraph : .moment
    }
    
    var onPageChanged: ((Int) -> Void)?
}
