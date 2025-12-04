
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
    let isbn: String?
    let isbn13: String?
    
    var highQualityCover: String {
        return self.cover.replacingOccurrences(of: "/coversum/", with: "/cover200/")
    }
    // 직접 책 추가 시 초기화 용
    static func empty() -> BookItem {
        return BookItem(title: "", author: "", publisher: "", cover: "", isbn: nil, isbn13: nil)
    }
}
