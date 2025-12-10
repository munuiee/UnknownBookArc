// MARK: 책 검색화면 ViewModel

import Foundation
import RxSwift
import RxCocoa

typealias BookItems = BookItem

class BookSearchViewModel {
    let disposeBag = DisposeBag()
    
    private let apiService = BookRepository()
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: Output (View로 데이터 내보냄)
    let bookList = BehaviorRelay<[BookItems]>(value: [])
    let viewState = BehaviorRelay<SearchState>(value: .initial)
    let selectedBookItem = PublishRelay<BookItem>()
    
    let currentPage = BehaviorRelay<Int>(value: 1)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let canLoadMore = BehaviorRelay<Bool>(value: true)
    
    let bookDuplicationCheck = PublishRelay<(item: BookItem, isDuplicated: Bool)>()
    
    // MARK: 검색 및 페이지네이션
    func search(query: String, page: Int) {
        guard !query.isEmpty else {
            self.viewState.accept(.initial)
            return
        }
        if page > 1 {
            guard !isLoading.value, canLoadMore.value else { return }
            
        }
        if page == 1 {
            self.currentPage.accept(1)
            self.canLoadMore.accept(true)
        }
        guard !isLoading.value, canLoadMore.value else { return }
        
        self.isLoading.accept(true)
        if bookList.value.isEmpty {
            self.viewState.accept(.loading)
        }
        
        apiService.searchBooks(query: query, page: page)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] newBookList in
                guard let self = self else { return }
                self.isLoading.accept(false)
                let isLastPage = newBookList.isEmpty
                
                self.currentPage.accept(page)
                
            
                var currentList = self.bookList.value
                currentList.append(contentsOf: newBookList)
                self.bookList.accept(currentList)
                
                self.canLoadMore.accept(!isLastPage)
                
                if self.bookList.value.isEmpty {
                    self.viewState.accept(.success)
                } else {
                    self.viewState.accept(.success)
                }
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.isLoading.accept(false)
                self.viewState.accept(.error(error))
  
            })
            .disposed(by: disposeBag)
    }
    
//    // MARK: 페이지네이션
//    func searchPage(query: String, page: Int) {
//        
//        guard !query.isEmpty else {
//            viewState.accept(.initial)
//            return
//        }
//        if page == 1 {
//            self.bookList.accept([])
//            self.canLoadMore.accept(true)
//        }
//        
//        guard !isLoading.value, canLoadMore.value else { return }
//        
//        self.isLoading.accept(true)
//        if bookList.value.isEmpty {
//            self.viewState.accept(.loading)
//        }
//       
//        
//        apiService.searchBooks(query: query, page: page)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onSuccess: { [weak self] newBookList in
//                guard let self = self else { return }
//                self.isLoading.accept(false)
//                let isLastPage = newBookList.isEmpty
//                
//                self.currentPage.accept(page)
//                
//            
//                var currentList = self.bookList.value
//                currentList.append(contentsOf: newBookList)
//                self.bookList.accept(currentList)
//                
//                self.canLoadMore.accept(!isLastPage)
//                
//                if self.bookList.value.isEmpty {
//                    self.viewState.accept(.success)
//                } else {
//                    self.viewState.accept(.success)
//                }
//            }, onFailure: { [weak self] error in
//                guard let self = self else { return }
//                self.isLoading.accept(false)
//                self.viewState.accept(.error(error))
//  
//            })
//            .disposed(by: disposeBag)
//    }

    // 초기 상태로 돌리기 (검색 취소시 사용)
    func resetSearchState() {
        self.viewState.accept(.initial)
        self.bookList.accept([])
    }
    
    // MARK: 검색 한 책 중복 체크
    func selectBook(item: BookItem) {
        let hasIsbn = !(item.isbn?.isEmpty ?? true)
        let hasIsbn13 = !(item.isbn13?.isEmpty ?? true)
        
        if hasIsbn || hasIsbn13 {
            let existingBook = coreDataManager.fetchBookByIsbn(isbn: item.isbn, isbn13: item.isbn13)
            let isDuplicated = existingBook != nil
            
            bookDuplicationCheck.accept((item: item, isDuplicated: isDuplicated))
        } else {
            bookDuplicationCheck.accept((item: item, isDuplicated: false))
        }
    }
}

