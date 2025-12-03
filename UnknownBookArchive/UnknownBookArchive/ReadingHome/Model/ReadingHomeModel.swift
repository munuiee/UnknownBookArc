// MARK: 메인화면 데이터 담는 코드

import Foundation


struct ReadingHomeModel {
    let currentReadingBooks: [Book]   // 현재 읽는 중인 책
    let plannedBooks: [Book]          // 읽을 예정인 책
    let pausedBooks: [Book]           // 잠시 멈춘 책
    let finishedBooks: [Book]         // 완독한 책

    static let empty = ReadingHomeModel(
        currentReadingBooks: [],
        plannedBooks: [],
        pausedBooks: [],
        finishedBooks: []
    )
}
