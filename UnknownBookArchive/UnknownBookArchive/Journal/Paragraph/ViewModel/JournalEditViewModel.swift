// MARK: - 문단 수집 페이지 편집 ViewModel

import Foundation
import CoreData

final class JournalEditViewModel {
    private let coreDataManager = CoreDataManager.shared
    private var context: NSManagedObjectContext {
        coreDataManager.persistentContainer.viewContext
    }
    
    private let book: Book
    private let type: String
    
    private(set) var journal: Journal?
    var onSaved: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(journal: Journal?, book: Book, type: String) {
        self.journal = journal
        self.book = book
        self.type = type
    }
    
    func saveButtonTapped(journal: Journal?, savedPage: String, journalText: String, liked: Bool) {
        if let journal = journal {
            // 수정
            journal.savedPage = savedPage
            journal.journalText = journalText
            journal.liked = liked
            
            if journal.createDate == nil {
                journal.createDate = Date()
            }
        } else {
            // 신규 생성
            let newJournal = Journal(context: context)
            newJournal.savedPage = savedPage
            newJournal.journalText = journalText
            newJournal.liked = liked
            newJournal.createDate = Date()
            
            newJournal.parentBook = self.book
            newJournal.bookTitle = self.journal?.bookTitle
            newJournal.bookAuthor = self.journal?.bookAuthor ?? ""
            newJournal.type = self.type
        }
        do {
            try context.save()
            onSaved?()
        } catch {
            print("[JournalEditVC] 문단 수집 저장 실패")
            onError?(error)
        }
    }
    
    func likedButtonTapped() {
        guard let journal = journal else { return }
        journal.liked.toggle()
        coreDataManager.saveContext()
    }
}
