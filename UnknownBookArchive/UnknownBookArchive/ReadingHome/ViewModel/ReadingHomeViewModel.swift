//
//  ReadingHomeViewModel.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/20/25.
//

import Foundation

final class ReadingHomeViewModel {
    
    // View에 UI 업데이트를 알려줄 때 사용
    var onUpdate: (() -> Void)?
    
    // 버튼 탭 등 이벤트 콜백
    var onAddBookTapped: (() -> Void)?

    // 화면에서 사용할 데이터
    private(set) var model: ReadingHomeModel = .empty
    
    
    func loadInitialData() {
        reloadFromCoreData()
    }
    
    
    // MARK: - CoreData에서 다시 불러오기 (UUID 문자열 비교를 사용)
    func reloadFromCoreData() {
        
        let allBooks: [Book] = CoreDataManager.shared.fetchAllBooks()
        
        var current: [Book] = []
        var planned: [Book] = []
        var paused: [Book] = []
        var finished: [Book] = []
        
        for book in allBooks {
            let state = book.readingState ?? ""
            
            switch state {
            case "읽는 중":
                current.append(book)
            case "읽을 예정":
                planned.append(book)
            case "중단":
                paused.append(book)
            case "완독":
                finished.append(book)
            default:
                break
            }
        }
        
        func sortByUUIDDescending(_ books: [Book]) -> [Book] {
            return books.sorted(by: { book1, book2 in
               
                let uuid1 = book1.uuid ?? ""
                let uuid2 = book2.uuid ?? ""
             
                return uuid1 > uuid2
            })
        }
        
        // 정렬 적용
        current = sortByUUIDDescending(current)
        planned = sortByUUIDDescending(planned)
        paused = sortByUUIDDescending(paused)
        finished = sortByUUIDDescending(finished)
        
        model = ReadingHomeModel(
            currentReadingBooks: current,
            plannedBooks: planned,
            pausedBooks: paused,
            finishedBooks: finished
        )
        
        // 데이터 로드 및 정렬 완료 후 View에 업데이트를 알림
        onUpdate?()
    }
    
    
    func addBookButtonTapped() {
        onAddBookTapped?()
    }
}
