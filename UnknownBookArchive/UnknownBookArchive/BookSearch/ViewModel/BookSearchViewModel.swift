import Foundation
import RxSwift
import RxCocoa

typealias Book = BookItem

class BookSearchViewModel {
    let disposeBag = DisposeBag()
    
    private let apiService = BookRepository()
    
    let bookList = BehaviorSubject<[Book]>(value: [])
    
    func search(query: String) {
        
        guard !query.isEmpty else {
            // 추후에 검색 전 안내멘트 + 책 추가 버튼 추가필요
            bookList.onNext([])
            return
        }
        apiService.searchBooks(query: query)
            .subscribe(onSuccess: { [weak self] items in
                self?.bookList.onNext(items)
            }, onFailure: { [weak self] error in
                // 검색 실페시 안내멘트 + 책 추가 버튼 추가필요
                print("검색 실패: \(error)")
                self?.bookList.onNext([])
            })
            .disposed(by: disposeBag)

    }
}

