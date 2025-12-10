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
    
    
    // MARK: - CoreData에서 다시 불러오기
    func reloadFromCoreData() {
        
        let allBooks: [Book] = CoreDataManager.shared.fetchAllBooks()
        
        var current: [Book] = []
        var planned: [Book] = []
        var paused: [Book] = []
        var finished: [Book] = []
        
        // 상태별 분류
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
        
        // MARK: 최근 수정된 순서로 정렬 
        func sortByModifiedDate(_ books: [Book]) -> [Book] {
            return books.sorted {
                ($0.lastModifiedDate ?? .distantPast) >
                ($1.lastModifiedDate ?? .distantPast)
            }
        }
        
        current  = sortByModifiedDate(current)
        planned  = sortByModifiedDate(planned)
        paused   = sortByModifiedDate(paused)
        finished = sortByModifiedDate(finished)
        
        
        // model 업데이트
        model = ReadingHomeModel(
            currentReadingBooks: current,
            plannedBooks: planned,
            pausedBooks: paused,
            finishedBooks: finished
        )
        
        // UI 업데이트 알림
        onUpdate?()
    }
    
    
    func addBookButtonTapped() {
        onAddBookTapped?()
    }
}
