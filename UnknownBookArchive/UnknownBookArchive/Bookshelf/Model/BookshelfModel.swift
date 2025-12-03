// MARK: 책장 Model

import Foundation
import UIKit

struct BookshelfBook {
    let uuid: String
    let title: String
    let author: String
    let selectedTags: String     
    let coverImageData: Data?
    let readingState: String?
}
