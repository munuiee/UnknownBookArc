import Foundation

final class JournalEditViewModel {
    private let coreDataManager = CoreDataManager.shared
    
    var onSaved: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func saveButtonTapped(savedPage: String, journalText: String, liked: Bool) {
        coreDataManager.createCollectionData(savedPage: savedPage, journalText: journalText, liked: liked)
        
        onSaved?()
    }
}
