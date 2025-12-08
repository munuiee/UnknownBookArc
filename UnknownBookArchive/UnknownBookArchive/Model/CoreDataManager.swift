import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "UnknownBookArchive")
        
           guard let description = container.persistentStoreDescriptions.first else {
               fatalError("No persistent store description found")
           }
        let options = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.UBACloudKit")
        description.cloudKitContainerOptions = options


        
        if let description = container.persistentStoreDescriptions.first {
            // CloudKit 동기화에 거의 필수 옵션 두 개
            description.setOption(true as NSNumber,
                                  forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber,
                                  forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
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
            endDate: Date?,
            isbn: String?,
            isbn13: String?

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
        newBook.setValue(isbn, forKey: "isbn")
        newBook.setValue(isbn13, forKey: "isbn13")
        
        
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
            endDate: Date?,
            isbn: String?,
            isbn13: String?
    ) -> Book? {
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            guard let bookToUpdate = fetchedBooks.first else {
                print("수정할 책(\(uuid))을 찾을 수 없습니다.")
                return nil
            }
            
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
            bookToUpdate.setValue(isbn, forKey: "isbn")
            bookToUpdate.setValue(isbn13, forKey: "isbn13")
            
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
    
    // MARK: isbn으로 책 중복 체크
    func fetchBookByIsbn(isbn: String?, isbn13: String?, excludeUUID: String? = nil) -> Book? {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        var predicates: [NSPredicate] = []
        
        var isbnPredicates: [NSPredicate] = []
        
        if let isbn = isbn, !isbn.isEmpty {
            isbnPredicates.append(NSPredicate(format: "isbn == %@", isbn))
        }
        if let isbn13 = isbn13, !isbn13.isEmpty {
            isbnPredicates.append(NSPredicate(format: "isbn13 == %@", isbn13))
        }
        
        if isbnPredicates.isEmpty {
            return nil
        }
        
        let isbnCompound = NSCompoundPredicate(type: .or, subpredicates: isbnPredicates)
        predicates.append(isbnCompound)
        
        if let excludeUUID = excludeUUID {
            predicates.append(NSPredicate(format: "uuid != %@", excludeUUID))
        }
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
              
        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            
            if let book = fetchedBooks.first {
                print("중복된 책 발견: \(book.title ?? "")")
                return book
            } else {
                return nil
            }
        } catch {
            let nsError = error as NSError
            print("중복 체크 에러 (에러: \(nsError))")
            return nil
        }
    }
        
}
