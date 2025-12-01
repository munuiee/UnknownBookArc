//
//  ReadingHomeViewModel.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/20/25.
//

import Foundation

final class ReadingHomeViewModel {
    
    var onUpdate: (() -> Void)?
    
    var onAddBookTapped: (() -> Void)?

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
        
        // 가장 최근에 저장된 책이 앞으로 오도록 역순 정렬
        current.reverse()
        planned.reverse()
        paused.reverse()
        finished.reverse()
        
        model = ReadingHomeModel(
            currentReadingBooks: current,
            plannedBooks: planned,
            pausedBooks: paused,
            finishedBooks: finished
        )
        
        onUpdate?()
    }
    
    func addBookButtonTapped() {
        onAddBookTapped?()
    }
}

