// MARK: 찰나의 기록 페이지 편집 ViewModel

import Foundation
import CoreData

final class MomentEditViewModel {
    private let coreDataManager = CoreDataManager.shared
    private var context: NSManagedObjectContext {
        coreDataManager.persistentContainer.viewContext
    }
    
    private(set) var moments: MomentEntity?
    var onSaved: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(moments: MomentEntity?) {
        self.moments = moments
    }
    

}
