import Foundation
import RxSwift
import RxCocoa

typealias BookItems = BookItem

class BookSearchViewModel {
    let disposeBag = DisposeBag()
    
    private let apiService = BookRepository()
    
    // MARK: Output (View로 데이터 내보냄)
    let bookList = BehaviorRelay<[BookItems]>(value: [])
    let viewState = BehaviorRelay<SearchState>(value: .initial)
    let selectedBookItem = PublishRelay<BookItem>()
    
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

