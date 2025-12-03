// MARK: 좋아요 한 책 임시 모델

import Foundation

struct LikeBooks {
    let id = UUID()
    let thumbnailURL: String
}

enum SampleDataSource {
    static let books: [LikeBooks] = [
        LikeBooks(thumbnailURL: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788937463662.jpg"),
        LikeBooks(thumbnailURL: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788937460883.jpg"),
        LikeBooks(thumbnailURL: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788937463488.jpg"),
        LikeBooks(thumbnailURL: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788937462832.jpg"),
        LikeBooks(thumbnailURL: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788937461323.jpg"),
        LikeBooks(thumbnailURL: "https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788937463631.jpg")
    ]
}
