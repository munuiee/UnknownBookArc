import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "UnknownBookArchive")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("⚠️ CoreData save 실패: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    func paragraphCreate(savedPage: String, journalText: String, liked: Bool) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Journal", in: self.persistentContainer.viewContext) else { return }
        
        // JCData = 저널 문단 수집 데이터
        let collectionData = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        
        collectionData.setValue(savedPage, forKey: "savedPage")
        collectionData.setValue(Date(), forKey: "createDate")
        collectionData.setValue(journalText, forKey: "journalText")
        collectionData.setValue(liked, forKey: "liked")
        
        do {
            try self.persistentContainer.viewContext.save()
            print("🫰🏻 문단 수집 데이터가 저장됨")
        } catch {
            print("🧎‍♀️ 문단 수집 데이터 저장 실패")
        }
    }
    
    
    
    
    func paragraphDelete(journal: Journal) throws {
        let context = persistentContainer.viewContext
        context.delete(journal)
        
        do {
            try context.save()
        } catch {
            print("문단 삭제에 실패했습니다. \(error)")
        }
    }
    
    func momentDelete(moments: MomentEntity) throws {
        let context = persistentContainer.viewContext
        context.delete(moments)
        
        do {
            try context.save()
        } catch {
            print("기록 삭제에 실패했습니다. \(error)")
        }
    }
    
    func paragraphUpdate(journal: Journal, page: String, text: String, liked: Bool) throws {
        journal.savedPage = page
        journal.journalText = text
        journal.liked = liked
        try context.save()
    }
    
    func newParagraphCreate(page: String, text: String, liked: Bool) throws {
        let newJournal = Journal(context: persistentContainer.viewContext)
        newJournal.savedPage = page
        newJournal.journalText = text
        newJournal.liked = liked
        // newJournal.createDate = Date()
        try context.save()
    }
    
    
    func fetchJournals(for book: Book) -> [Journal] {
        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
        request.predicate = NSPredicate(format: "parentBook == %@", book)
        let sort = NSSortDescriptor(key: "createDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let records = try context.fetch(request)
            return records
        } catch {
            print("fetchJournals 실패: \(error)")
            return []
        }
    }
    
    
    
    // MARK: 책 정보
    
    // 책 정보 저장 함수
    func bookCreate(

            uuid: String,
            title: String,
            author: String?,
            publisher: String?,
            readingState: String?,
            bookFormat: String?,
            selectedTags: String?,
            coverImage: Data?,
            isPageMode: Bool,
            currentPage: Int32,
            totalPage: Int32,
            percent: Int32,
            startDate: Date?,
            endDate: Date?

    ) -> Book? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Book", in: context) else {
            print("Book엔티티를 찾을 수 없습니다.")
            return nil
        }
        guard let newBook = NSManagedObject(entity: entity, insertInto: context) as? Book else { return nil }
        newBook.setValue(uuid, forKey: "uuid")
        newBook.setValue(title, forKey: "title")
        newBook.setValue(author, forKey: "author")
        newBook.setValue(publisher, forKey: "publisher")
        newBook.setValue(readingState, forKey: "readingState")
        newBook.setValue(bookFormat, forKey: "bookFormat")
        newBook.setValue(selectedTags, forKey: "selectedTags")
        newBook.setValue(coverImage, forKey: "coverImage")
        newBook.setValue(isPageMode, forKey: "isPageMode")
        newBook.setValue(currentPage, forKey: "currentPage")
        newBook.setValue(totalPage, forKey: "totalPage")
        newBook.setValue(percent, forKey: "percent")
        newBook.setValue(startDate, forKey: "startDate")
        newBook.setValue(endDate, forKey: "endDate")
        
        do {
            try context.save()
            print("책 저장 성공")
            return newBook
        } catch {
            _ = error as NSError
            print("책 저장 실패")
            return nil
        }
    }
    

    // 책 정보 수정 함수
    func bookUpdate(
            uuid: String,
            title: String,
            author: String?,
            publisher: String?,
            readingState: String?,
            bookFormat: String?,
            selectedTags: String?,
            coverImage: Data?,
            isPageMode: Bool,
            currentPage: Int32?,
            totalPage: Int32?,
            percent: Int32?,
            startDate: Date?,
            endDate: Date?
    ) -> Book? {
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            guard let bookToUpdate = fetchedBooks.first else {
                print("수정할 책(\(uuid))을 찾을 수 없습니다.")
                return nil
            }
            
            bookToUpdate.setValue(uuid, forKey: "uuid")
            bookToUpdate.setValue(title, forKey: "title")
            bookToUpdate.setValue(author, forKey: "author")
            bookToUpdate.setValue(publisher, forKey: "publisher")
            bookToUpdate.setValue(readingState, forKey: "readingState")
            bookToUpdate.setValue(bookFormat, forKey: "bookFormat")
            bookToUpdate.setValue(selectedTags, forKey: "selectedTags")
            bookToUpdate.setValue(coverImage, forKey: "coverImage")
            bookToUpdate.setValue(isPageMode, forKey: "isPageMode")
            bookToUpdate.setValue(currentPage, forKey: "currentPage")
            bookToUpdate.setValue(totalPage, forKey: "totalPage")
            bookToUpdate.setValue(percent, forKey: "percent")
            bookToUpdate.setValue(startDate, forKey: "startDate")
            bookToUpdate.setValue(endDate, forKey: "endDate")
            
            try context.save()
            print("책 수정 성공")
            return bookToUpdate
        } catch {
            let _ = error as NSError
            print("책 수정 실패")
            return nil
        }

    }
    
    // 첵 정보 불러오기
    func fetchBook(uuid: String) -> Book? {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            if let book = fetchedBooks.first {
                print("책 정보 불러오기 성공")
                return book
            } else {
                print("책 정보 불러오기 실패\(uuid)")
                return nil
            }
        } catch {
            let nsError = error as NSError
            print("책 정보 불러오기 실패(에러\(nsError)")
            return nil
        }
    }
    
    // 책 정보 삭제
    func deleteBook(uuid: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard self != nil else {
                completion(false)
                return
            }
        }
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            guard let bookToDelete = fetchedBooks.first else {
                print("삭제할 책을 찾을 수 없습니다.")
                completion(false)
                return
            }
            context.delete(bookToDelete)
            
            try context.save()
            print("책 삭제 성공")
            completion(true)
            return
        } catch {
            let nsError = error as NSError
            print("책 삭제 실패(에러: \(nsError))")
            completion(false)
            return
        }
    }
    
    func fetchAllBooks() -> [Book] {
            let request: NSFetchRequest<Book> = Book.fetchRequest()
  
            request.sortDescriptors = [
                NSSortDescriptor(key: "startDate", ascending: true)
            ]
            
            do {
                let result = try context.fetch(request)
                return result
            } catch {
                print("책 목록 불러오기 실패: \(error)")
                return []
            }
        }

}
