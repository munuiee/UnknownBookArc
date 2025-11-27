//
//  Journal+CoreDataProperties.swift
//  UnknownBookArchive
//
//  Created by jyeee on 11/21/25.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var savedPage: String?
    @NSManaged public var journalText: String?
    @NSManaged public var liked: Bool
    @NSManaged public var bookTitle: String?
    @NSManaged public var bookAuthor: String?


}

extension Journal : Identifiable {

}
