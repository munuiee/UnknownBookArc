// MARK: 찰나의 기록 리스트 화면 ViewModel

import Foundation
import CoreData
import UIKit

struct MomentSection {
    let date: Date
    let items: [MomentEntity]
}

final class MomentListViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    private var context: NSManagedObjectContext {
        coreDataManager.persistentContainer.viewContext
    }
    
    private let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    private(set) var sections: [MomentSection] = [] {
        didSet { onUpdateMoment?() }
    }
    
    
    var onUpdateMoment: (() -> Void)?
    
    // MARK: - 코어데이터에서 불러오기
    func fetchMoments() {
        let request: NSFetchRequest<MomentEntity> = MomentEntity.fetchRequest()
        request.predicate = NSPredicate(format: "parentBook == %@", book)
        let sortDate = NSSortDescriptor(key: "momentDate", ascending: false)
        let sortTime = NSSortDescriptor(key: "momentTime", ascending: false)
        request.sortDescriptors = [sortDate, sortTime]
        
        
        do {
            let moments = try context.fetch(request)
            print("📦 fetchMoments for book: \(book.title ?? "")")
            print("가져온 Moment 개수: \(moments.count)")
            sections = makeSections(from: moments)
        } catch {
            print("찰나의 기록 불러오기 실패: \(error)")
        }
    }
    
    // MARK: - 새 기록 추가
    func addMoment(text: String, page: String? = nil) {
        let newMoment = MomentEntity(context: context)
        
        let now = Date()
        newMoment.momentText = text
        newMoment.momentPage = page
        newMoment.momentDate = now
        newMoment.momentTime = now
        newMoment.createDate = now
        newMoment.parentBook = book
        
        do {
            try context.save()
            print("✅ Moment 저장 완료")
            print("text: \(newMoment.momentText ?? "")")
            print("page: \(newMoment.momentPage ?? "")")
            print("parentBook title: \(newMoment.parentBook?.title ?? "nil")")
            fetchMoments()
        } catch {
            print("찰나의 기록 저장 실패: \(error)")
            context.rollback()
        }
    }
    
    // MARK: - 섹션 구성 (날짜별 그룹핑)
    private func makeSections(from moments: [MomentEntity]) -> [MomentSection] {
        _ = moments.compactMap { moments -> MomentEntity? in
            guard moments.momentDate != nil else { return nil }
            return moments
        }
        
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: moments) { moment -> Date in
            let date = moment.momentDate ?? Date()
            return calendar.startOfDay(for: date)   // 2025-11-26 00:00:00 이런 식
        }
        
        // 날짜 오름차순 정렬
        let sortedDates = grouped.keys.sorted(by: >)
        
        return sortedDates.map { date in
            let items = grouped[date] ?? []
            return MomentSection(date: date, items: items)
        }
    }
    
    // MARK: - 컬렉션뷰용 헬퍼들
    
    var numberOfSections: Int {
        sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        sections[section].items.count
    }
    
    func moments(at indexPath: IndexPath) -> MomentEntity {
        sections[indexPath.section].items[indexPath.item]
    }
    
    func dateForSection(_ section: Int) -> Date {
        sections[section].date
    }
    
    func page(at indexPath: IndexPath) -> String {
        moments(at: indexPath).momentPage ?? ""
    }
    
    func text(at indexPath: IndexPath) -> String {
        moments(at: indexPath).momentText ?? ""
    }
    
    func mdateText(at indexPath: IndexPath) -> String {
        guard let date = moments(at: indexPath).momentDate else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter.string(from: date)
    }
    
    func mTimeText(at indexPath: IndexPath) -> String {
        guard let date = moments(at: indexPath).momentTime else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // 삭제도 섹션 기준으로
    func delete(at indexPath: IndexPath) {
        let target = moments(at: indexPath)
        
        do {
            try coreDataManager.momentDelete(moments: target)
            fetchMoments()
        } catch {
            print("[MomentListViewModel] 기록 삭제 실패 \(error)")
        }
    }
}
