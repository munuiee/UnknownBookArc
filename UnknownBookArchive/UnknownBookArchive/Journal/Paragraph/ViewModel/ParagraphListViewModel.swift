// MARK: - 문단 수집 리스트 화면 ViewModel

import Foundation
import CoreData
import UIKit

final class ParagraphListViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    private var context: NSManagedObjectContext {
        coreDataManager.persistentContainer.viewContext
    }
    
    private(set) var journals: [Journal] = [] {
        didSet { onUpdate?() }
    }
    
    var onUpdate: (() -> Void)?
    
    // 코어데이터에서 불러오기
    func fetchParagraphs() {
        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
        // 최신순 정렬
        let sort = NSSortDescriptor(key: "createDate", ascending: false)
        request.sortDescriptors = [sort]
        do {
            journals = try context.fetch(request)
        } catch {
            print("문단 수집 불러오기 실패: \(error)")
        }
    }
    
  
    
    var numberOfItems: Int {
        journals.count
    }
    
    func page(at indexPath: IndexPath) -> String {
        journals[indexPath.item].savedPage ?? ""
    }
    
    func text(at indexPath: IndexPath) -> String {
        journals[indexPath.item].journalText ?? ""
    }
    
    func liked(at indexPath: IndexPath) -> Bool {
        journals[indexPath.item].liked
    }
    
    func dateText(at indexPath: IndexPath) -> String {
        guard let date = journals[indexPath.item].createDate else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. MM. dd HH:mm"
        return formatter.string(from: date)
    }
    
    func journal(at indexPath: IndexPath) -> Journal {
        journals[indexPath.item]
    }
    
    func toggleLike(at index: Int) {
        let journal = journals[index]
        journal.liked.toggle()
        
        
        do {
            try context.save()
        } catch {
            journal.liked.toggle()
            print("좋아요 저장 실패 \(error)")
        }
    }
    
    func delete(at indexPath: IndexPath) {
        let target = journals[indexPath.item]
        
        do {
            try coreDataManager.paragraphDelete(journal: target)
            journals.remove(at: indexPath.item)
        } catch {
            print("[VM] 문단 삭제 실패 \(error)")
        }
    }
}
