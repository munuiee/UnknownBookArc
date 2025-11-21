
import Foundation
import RxSwift

struct BookResponse: Decodable {
    let item: [BookItem]
}

struct BookItem:Decodable {
    let title: String
    let author: String
    let publisher: String
    let cover: String
    let isbn13: String?

}
