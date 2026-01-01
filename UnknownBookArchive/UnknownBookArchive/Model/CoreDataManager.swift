import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    init() {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "UnknownBookArchive")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No persistent store description found")
        }

        let options = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.UBACloudKit")
        description.cloudKitContainerOptions = options

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return container
    }()

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            print("⚠️ CoreData save 실패: \(nserror), \(nserror.userInfo)")
        }
    }
    
    func debugPrintCountsFor2026() {
        let testDate = Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        print("🧪 [FORCE] month:", countCompletedBooksInMonth(baseDate: testDate))
        print("🧪 [FORCE] year:", countCompletedBooksInYear(baseDate: testDate))
    }


    // MARK: - Journal / Moment

    func paragraphCreate(savedPage: String, journalText: String, liked: Bool) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Journal",
                                                     in: persistentContainer.viewContext) else { return }

        let collectionData = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
        collectionData.setValue(savedPage, forKey: "savedPage")
        collectionData.setValue(Date(), forKey: "createDate")
        collectionData.setValue(journalText, forKey: "journalText")
        collectionData.setValue(liked, forKey: "liked")

        do {
            try persistentContainer.viewContext.save()
            print("🫰🏻 문단 수집 데이터가 저장됨")
        } catch {
            print("🧎‍♀️ 문단 수집 데이터 저장 실패: \(error)")
        }
    }

    func paragraphDelete(journal: Journal) throws {
        let ctx = persistentContainer.viewContext
        ctx.delete(journal)

        do {
            try ctx.save()
        } catch {
            print("문단 삭제에 실패했습니다. \(error)")
        }
    }

    func momentDelete(moments: MomentEntity) throws {
        let ctx = persistentContainer.viewContext
        ctx.delete(moments)

        do {
            try ctx.save()
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
        try context.save()
    }

    func fetchJournals(for book: Book) -> [Journal] {
        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
        request.predicate = NSPredicate(format: "parentBook == %@", book)
        request.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("fetchJournals 실패: \(error)")
            return []
        }
    }

    // MARK: - Book CRUD

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
        isbn13: String?,
        lastModifiedDate: Date
    ) -> Book? {

        guard let entity = NSEntityDescription.entity(forEntityName: "Book", in: context) else {
            print("Book엔티티를 찾을 수 없습니다.")
            return nil
        }
        guard let newBook = NSManagedObject(entity: entity, insertInto: context) as? Book else {
            return nil
        }

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
        newBook.setValue(lastModifiedDate, forKey: "lastModifiedDate")

        do {
            try context.save()
            print("책 저장 성공")
            return newBook
        } catch {
            print("책 저장 실패: \(error)")
            return nil
        }
    }

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
        isbn13: String?,
        lastModifiedDate: Date
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
            bookToUpdate.setValue(lastModifiedDate, forKey: "lastModifiedDate")

            try context.save()
            print("책 수정 성공")
            return bookToUpdate
        } catch {
            print("책 수정 실패: \(error)")
            return nil
        }
    }

    func fetchBook(uuid: String) -> Book? {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)

        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            if let book = fetchedBooks.first {
                print("책 정보 불러오기 성공")
                return book
            } else {
                print("책 정보 불러오기 실패 \(uuid)")
                return nil
            }
        } catch {
            print("책 정보 불러오기 실패(에러): \(error)")
            return nil
        }
    }

    func deleteBook(uuid: String, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)

        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            guard let bookToDelete = fetchedBooks.first else {
                print("삭제할 책을 찾을 수 없습니다.")
                completion(false)
                return
            }

            // ✅ 연결된 Journal 먼저 삭제
            let journals = fetchJournals(for: bookToDelete)
            journals.forEach { context.delete($0) }

            // ✅ 책 삭제
            context.delete(bookToDelete)

            try context.save()
            print("책 + 연결된 문단 수집 삭제 성공")
            completion(true)
        } catch {
            print("책 삭제 실패(에러): \(error)")
            completion(false)
        }
    }

    func fetchAllBooks() -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastModifiedDate", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("책 목록 불러오기 실패: \(error)")
            return []
        }
    }

    // MARK: - isbn으로 책 중복 체크

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

        if isbnPredicates.isEmpty { return nil }

        predicates.append(NSCompoundPredicate(type: .or, subpredicates: isbnPredicates))

        if let excludeUUID = excludeUUID {
            predicates.append(NSPredicate(format: "uuid != %@", excludeUUID))
        }

        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)

        do {
            let fetchedBooks = try context.fetch(fetchRequest)
            if let book = fetchedBooks.first {
                print("중복된 책 발견: \(book.title ?? "")")
                return book
            }
            return nil
        } catch {
            print("중복 체크 에러: \(error)")
            return nil
        }
    }

    // MARK: - 완독한 책 카운트 (endDate 기준, 해 바뀌면 자동 리셋)

    /// 외부에서 그냥 호출용 (이번 달)
    func countCompletedBooksInMonth() -> Int {
        countCompletedBooksInMonth(baseDate: Date())
    }

    /// 외부에서 그냥 호출용 (올해)
    func countCompletedBooksInYear() -> Int {
        countCompletedBooksInYear(baseDate: Date())
    }

    /// 테스트/특정 날짜 기준 호출용 (이번 달)
    func countCompletedBooksInMonth(baseDate: Date) -> Int {
        let calendar = Calendar.current

        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate)) else {
            return 0
        }
        guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
            print("다음 달 시작일 계산 실패")
            return 0
        }

        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "readingState == %@", "완독"),
            NSPredicate(format: "endDate != nil"),
            NSPredicate(format: "endDate >= %@ AND endDate < %@", startOfMonth as CVarArg, startOfNextMonth as CVarArg)
        ])

        do {
            let count = try context.count(for: request)
            let y = calendar.component(.year, from: baseDate)
            let m = calendar.component(.month, from: baseDate)
            print("📚 \(y)년 \(m)월 완독 책 개수: \(count)권")
            return count
        } catch {
            print("이번 달 완독 책 개수 세기 실패: \(error)")
            return 0
        }
    }

    /// 테스트/특정 날짜 기준 호출용 (올해)
    func countCompletedBooksInYear(baseDate: Date) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: baseDate)

        guard let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) else {
            return 0
        }
        guard let startOfNextYear = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1)) else {
            print("다음 해 시작일 계산 실패")
            return 0
        }

        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "readingState == %@", "완독"),
            NSPredicate(format: "endDate != nil"),
            NSPredicate(format: "endDate >= %@ AND endDate < %@", startOfYear as CVarArg, startOfNextYear as CVarArg)
        ])

        do {
            let count = try context.count(for: request)
            print("📚 \(year)년 완독 책 개수: \(count)권")
            return count
        } catch {
            print("올해 완독 책 개수 세기 실패: \(error)")
            return 0
        }
    }

    /// 화면에 보여줄 현재 연도
    func currentYearInt(baseDate: Date = Date()) -> Int {
        Calendar.current.component(.year, from: baseDate)
    }

    // MARK: - 진행도 수정

    func updateProgress(
        uuid: String,
        isPageMode: Bool,
        currentPage: Int32,
        totalPage: Int32,
        percent: Int32,
        lastModifiedDate: Date
    ) -> Bool {

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)

        do {
            let results = try context.fetch(fetchRequest)
            guard let bookToUpdate = results.first else { return false }

            bookToUpdate.isPageMode = isPageMode
            bookToUpdate.lastModifiedDate = lastModifiedDate

            if isPageMode {
                bookToUpdate.currentPage = currentPage
                bookToUpdate.totalPage = totalPage
                bookToUpdate.percent = 0
            } else {
                bookToUpdate.percent = percent
                bookToUpdate.currentPage = 0
                bookToUpdate.totalPage = 0
            }

            if context.hasChanges {
                try context.save()
            }

            NotificationCenter.default.post(name: .bookUpdated, object: nil)
            return true
        } catch {
            print("Progress 업데이트 실패:", error)
            return false
        }
    }
}

// MARK: - 스와이프 삭제

extension CoreDataManager {
    func delete(details: Book) {
        let ctx = persistentContainer.viewContext
        let journals = fetchJournals(for: details)
        journals.forEach { ctx.delete($0) }
        ctx.delete(details)

        do {
            try ctx.save()
        } catch {
            print("스와이프 삭제 실패: \(error)")
        }
    }
}
