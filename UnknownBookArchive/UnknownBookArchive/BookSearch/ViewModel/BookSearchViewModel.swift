import Foundation
import RxSwift
import RxCocoa

// 임시 데이터 모델
struct Book {
    let title: String
    let author: String
    let publisher: String
}

class BookSearchViewModel {
    let disposeBag = DisposeBag()
    
    let bookList = BehaviorSubject<[Book]>(value: [])
    
    func search(query: String) {
        let dummyBooks = [
            Book(title: "해리포터와 비밀의 방", author: "조앤 K.롤링", publisher: "문학수첩"),
            Book(title: "혼모노", author: "성해나", publisher: "창비"),
            Book(title: "모순", author: "양귀자", publisher: "쓰다")
        ]
        bookList.onNext(dummyBooks)
    }
}

