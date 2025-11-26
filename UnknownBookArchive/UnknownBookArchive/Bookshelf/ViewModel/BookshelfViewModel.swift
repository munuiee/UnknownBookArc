//
//  BookshelfViewModel.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/24/25.
//

import Foundation

final class BookshelfViewModel {

    
    var onUpdate: (([BookshelfBook]) -> Void)?

    // 전체 책 Data
    private var allBooks: [BookshelfBook] = []
    
    
    // 필터 적용 후 보여줄 책 목록
    private var filteredBooks: [BookshelfBook] = []

    // 선택된 카테고리 index
    private var selectedCategoryIndex: Int = 0
    
    // 검색어
    private var searchText: String = ""

    init() {
        loadInitialData()
    }

    // 현재는 샘플 데이터 로딩 중. 추후 변경 예정.
    func loadInitialData() {
        allBooks = SampleData.books
        filteredBooks = allBooks
        onUpdate?(filteredBooks)
    }

    // 검색 텍스트 변경
    func updateSearch(text: String) {
        searchText = text
        applyFilter()
    }

    // 카테고리 선택 변경
    func updateCategory(index: Int) {
        selectedCategoryIndex = index
        applyFilter()
    }

    // 카테고리 + 검색
    private func applyFilter() {
        filteredBooks = allBooks.filter { book in
            let matchCategory = (selectedCategoryIndex == 0) || (book.categoryIndex == selectedCategoryIndex)
            let matchText = searchText.isEmpty || book.title.contains(searchText)
            return matchCategory && matchText
        }
        onUpdate?(filteredBooks)
    }
}
