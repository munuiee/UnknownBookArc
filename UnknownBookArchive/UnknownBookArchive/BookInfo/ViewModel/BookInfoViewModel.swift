// MARK: 책 편집화면 ViewModel

import Foundation
import RxSwift
import RxCocoa

class BookInfoViewModel {
    
    // Input (View에서 데이터 받음)
    let initialBookItem = PublishSubject<BookItem>()
    
    // Output
    let coverImageUrl = BehaviorRelay<String?>(value: nil)
    let title = BehaviorRelay<String>(value: "")
    let author = BehaviorRelay<String>(value: "")
    let publisher = BehaviorRelay<String>(value: "")
    let isbn = BehaviorRelay<String?>(value: nil)
    let isbn13 = BehaviorRelay<String?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    init() {
        initialBookItem
            .subscribe(onNext: { [weak self] item in
                self?.coverImageUrl.accept(item.cover)
                self?.title.accept(item.title)
                self?.author.accept(item.author)
                self?.publisher.accept(item.publisher)
                self?.isbn.accept(item.isbn)
                self?.isbn13.accept(item.isbn13)
            })
            .disposed(by: disposeBag)
    }
    
}
