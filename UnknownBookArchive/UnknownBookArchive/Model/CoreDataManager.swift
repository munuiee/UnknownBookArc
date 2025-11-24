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
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createCollectionData(savedPage: String, journalText: String, liked: Bool) {
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
    

}
