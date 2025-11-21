import Foundation
import RxSwift
import RxCocoa

typealias Book = BookItem

class BookSearchViewModel {
    let disposeBag = DisposeBag()
    
    private let apiService = BookRepository()
    
    let bookList = BehaviorRelay<[Book]>(value: [])
    let viewState = BehaviorRelay<SearchState>(value: .initial)
    
    func search(query: String) {
        
        guard !query.isEmpty else {
            viewState.accept(.initial)
            return
        }
        apiService.searchBooks(query: query)
            .subscribe(onSuccess: { [weak self] items in
                self?.bookList.accept(items)
                self?.viewState.accept(.success)
            }, onFailure: { [weak self] error in
                print("검색 실패: \(error)")
                self?.viewState.accept(.error(error))
            })
            .disposed(by: disposeBag)
    }
    // 초기 상태로 돌리기 (검색 취소시 사용)
    func resetSearchState() {
        self.viewState.accept(.initial)
        self.bookList.accept([])
    }
}

