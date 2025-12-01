//
//  Moment+CoreDataProperties.swift
//  UnknownBookArchive
//
//  Created by jyeee on 11/26/25.
//
//

import Foundation
import CoreData


extension MomentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MomentEntity> {
        return NSFetchRequest<MomentEntity>(entityName: "MomentEntity")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var momentDate: Date?
    @NSManaged public var momentPage: String?
    @NSManaged public var momentText: String?
    @NSManaged public var momentTime: Date?
    @NSManaged public var parentBook: Book?
}

extension MomentEntity : Identifiable {

}
