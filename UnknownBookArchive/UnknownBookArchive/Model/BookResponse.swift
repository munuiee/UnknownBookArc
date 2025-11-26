
import Foundation
import RxSwift

struct BookResponse: Decodable {
    let item: [BookItem]
}

struct BookItem: Decodable {
    let title: String
    let author: String
    let publisher: String
    let cover: String
    let isbn13: String?
    
    // 직접 책 추가 시 초기화 용
    static func empty() -> BookItem {
        return BookItem(title: "", author: "", publisher: "", cover: "", isbn13: nil)
    }
}
