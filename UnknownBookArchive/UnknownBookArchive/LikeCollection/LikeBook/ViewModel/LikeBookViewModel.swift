// MARK: 좋아요 한 책 ViewModel


import Foundation
import UIKit
import CoreData


final class LikeBookViewModel {
    
    //    var allLikeBooks: [LikeBooks] = []
    //    var onUpdate: (() -> Void)?
    //
    //    init() {
    //        loadLikeBooksData()
    //    }
    //
    //    func loadLikeBooksData() {
    //        allLikeBooks = SampleDataSource.books
    //        onUpdate?()
    //    }
    
    private let coreDataManager = CoreDataManager.shared
    
    private var context: NSManagedObjectContext {
        coreDataManager.persistentContainer.viewContext
    }
    
    private(set) var likedBooks: [Book] = [] {
        didSet { onUpdate?() }
    }
    var onUpdate: (() -> Void)?
    
    func fetchLikeBooks() {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSPredicate(format: "liked == true")
        do {
            likedBooks = try context.fetch(request)
        } catch {
            print("좋아요한 책 불러오기 실패")
        }
    }
    
    func bookThumbnail(at indexPath: IndexPath) -> UIImage? {
        guard let data = likedBooks[indexPath.item].coverImage else {
            return nil
        }
        return UIImage(data: data)
    }
    
    
    func toggleLikeBook(at index: Int) {
        let book = likedBooks[index]
        book.liked.toggle()
        
        do {
            try context.save()
            if book.liked == false {
                likedBooks.remove(at: index)
            }
        } catch {
            book.liked.toggle()
            print("책 좋아요 저장 실패 \(error)")
        }
    }
    
    
    
}
