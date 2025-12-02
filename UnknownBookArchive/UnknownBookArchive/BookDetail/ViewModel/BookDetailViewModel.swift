import Foundation
import CoreData
import UIKit

final class BookDetailViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    private var context: NSManagedObjectContext {
        coreDataManager.persistentContainer.viewContext
    }
    
    // MARK: 좋아요 한 책 순서 정렬
    func toggleLike(for book: Book) {
        book.liked.toggle()
        
        if book.liked {
            book.likedAt = Date()
        } else {
            book.likedAt = nil
        }
        
        do {
            try context.save()
        } catch {
            book.liked.toggle()
            print("좋아요 저장 실패: \(error)")
        }
    }

}
