// MARK: 저널 탭바 ViewModel
import UIKit
import Foundation

final class JournalViewModel {
    var onPageChanged: ((Int) -> Void)?
    var didTapEdit: (() -> Void)?
    
    
    let book: Book
    
    var paragraphRecords: [Journal] = []
    var momentRecords: [MomentEntity] = []
    
    init(book: Book) {
        self.book = book
    }
    private(set) var tabItems: [String] = ["문단 수집", "찰나의 기록"]
    
    private(set) var currentPage: Int = 0 {
        didSet {
            onPageChanged?(currentPage)
        }
    }
    
    private(set) var books: [Book] = []
    
    func title(at indexPath: IndexPath) -> String {
        books[indexPath.item].title ?? ""
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
    
    func editButtonTapped() {
        didTapEdit?()
    }
    
    func fetchJournalRecords() {
        let allRecords = CoreDataManager.shared.fetchJournals(for: self.book)
        
        allRecords.forEach { j in
              let type = j.type ?? "nil"
              let page = j.savedPage ?? ""
              let parentTitle = j.parentBook?.title ?? "nil"
          }
        self.paragraphRecords = allRecords.filter { $0.type == "문단 수집"}
    }
    
    
}
