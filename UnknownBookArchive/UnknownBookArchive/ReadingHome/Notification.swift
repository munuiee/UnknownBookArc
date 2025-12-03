// MARK: 책 삭제 시 메인 화면 UI 업데이트를 위한 코드

import Foundation

extension Notification.Name {
    static let bookUpdated = Notification.Name("bookUpdated")
    static let bookDeleted = Notification.Name("bookDeleted")
}
