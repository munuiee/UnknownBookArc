// MARK: 책장 ViewMdoel

import Foundation
import CoreData

final class BookshelfViewModel {

    // 화면에 책 목록을 업데이트할 때 호출되는 콜백
    var onUpdate: (([BookshelfBook]) -> Void)?

    // 전체 CoreData 책 목록
    private var allBooks: [BookshelfBook] = []

    // 필터링 후 화면에 표시될 책 목록
    private var filteredBooks: [BookshelfBook] = []

    // 선택된 카테고리 index ("전체" = 0, 그 외 = 1 ~ 11)
    private var selectedCategoryIndex: Int = 0

    // 검색 텍스트
    private var searchText: String = ""

    // 초기 데이터 로드
    func loadInitialData() {
        let coreDataBooks = CoreDataManager.shared.fetchAllBooks()

        self.allBooks = coreDataBooks.map { book in
            return BookshelfBook(
                uuid: book.uuid ?? "",
                title: book.title ?? "",
                author: book.author ?? "",
                selectedTags: book.selectedTags ?? "",
                coverImageData: book.coverImage,
                readingState: book.readingState  
            )
        }

        self.filteredBooks = allBooks
        onUpdate?(filteredBooks)
    }

    // 검색 텍스트 변경
    func updateSearch(text: String) {
        self.searchText = text
        applyFilter()
    }

    // 카테고리 변경
    func updateCategory(index: Int) {
        self.selectedCategoryIndex = index
        applyFilter()
    }

    // 카테고리 + 검색 필터링
    private func applyFilter() {

        filteredBooks = allBooks.filter { book in

            // 카테고리 필터
            let matchCategory: Bool
            if selectedCategoryIndex == 0 {
                matchCategory = true   // "전체"
            } else {
                let categoryTag = BookTag.allCases[selectedCategoryIndex - 1].rawValue
                matchCategory = book.selectedTags.contains(categoryTag)
            }

            // 검색 필터
            let matchText = searchText.isEmpty ||
                            book.title.localizedCaseInsensitiveContains(searchText) ||
                            book.author.localizedCaseInsensitiveContains(searchText)

            return matchCategory && matchText
        }

        onUpdate?(filteredBooks)
    }
}
