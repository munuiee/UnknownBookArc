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

}
