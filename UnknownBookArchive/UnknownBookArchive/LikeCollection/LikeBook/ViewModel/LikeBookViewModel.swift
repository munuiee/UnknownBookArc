// MARK: 좋아요 한 책 ViewModel

import Foundation

final class LikeBookViewModel {
    var allLikeBooks: [LikeBooks] = []
    var onUpdate: (() -> Void)?
    
    init() {
        loadLikeBooksData()
    }
    
    func loadLikeBooksData() {
        allLikeBooks = SampleDataSource.books
        onUpdate?()
    }
}
