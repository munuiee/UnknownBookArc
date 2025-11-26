// MARK: - 좋아요 탭바 ViewModel

import Foundation

final class LikeViewModel {
    var onPageChanged: ((Int) -> Void)?
    var didTapEdit: (() -> Void)?
    
    private(set) var tabItems: [String] = ["문단 수집", "책"]
    
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
    
    func pageType(at index: Int) -> LikePageType {
        index == 0 ? .likeParagraph : .likeBook
    }
    
    func editButtonTapped() {
        didTapEdit?()
    }
    
    
}
