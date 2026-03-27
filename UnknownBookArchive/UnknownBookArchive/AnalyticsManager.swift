// MARK: 퍼널 지표
import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}
    
    func logSearchCompleted() {
        Analytics.logEvent("search_completed", parameters: nil)
    }
    
    func logBookRegistered() {
        Analytics.logEvent("book_registered", parameters: nil)
    }
    
    func logJournalStarted(type: String) {
        Analytics.logEvent("journal_started", parameters: [
            "journal_type": type
        ])
    }
    
    func logJournalCompleted(type: String) {
        Analytics.logEvent("jorunal_completed", parameters: [
            "journal_type": type
        ])
    }
}
