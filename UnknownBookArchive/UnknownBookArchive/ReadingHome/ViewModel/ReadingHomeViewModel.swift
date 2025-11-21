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
    private(set) var model: ReadingHomeModel = ReadingHomeModel(currentReadingBooks: [], plannedBooks: [],
        pausedBooks: [],
        finishedBooks: []
    )
    
    func loadInitialData() {
        // 나중에 서버/ DB 연동 시 여기서 데이터 로딩
        onUpdate?()
    }
    
    func addDummyBook() {
        // 예시용 (테스트용 더미 데이터)
        var current = model.currentReadingBooks
        current.append("예시 책 제목")
        
        model = ReadingHomeModel(currentReadingBooks: current,
        plannedBooks: model.plannedBooks,
        pausedBooks: model.pausedBooks,
        finishedBooks: model.finishedBooks
        )
        
        onUpdate?()
    }
    
    func addBookButtonTapped() {
        onAddBookTapped?()
    }
}

