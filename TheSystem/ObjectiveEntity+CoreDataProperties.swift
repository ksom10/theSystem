//
//  ObjectiveEntity+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 5/21/25.
//
//

import Foundation
import CoreData


extension ObjectiveEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObjectiveEntity> {
        return NSFetchRequest<ObjectiveEntity>(entityName: "ObjectiveEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
    @NSManaged public var xpReward: Int32

}

extension ObjectiveEntity : Identifiable {

}
