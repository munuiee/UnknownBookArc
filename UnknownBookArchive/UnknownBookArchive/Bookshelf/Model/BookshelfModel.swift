//
//  BookshelfModel.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/24/25.
//

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
