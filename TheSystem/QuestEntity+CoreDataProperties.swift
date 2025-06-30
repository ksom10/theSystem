//
//  QuestEntity+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 6/23/25.
//
//

import Foundation
import CoreData


extension QuestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestEntity> {
        return NSFetchRequest<QuestEntity>(entityName: "QuestEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var xpReward: Int32
    @NSManaged public var category: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dateCompleted: Date?

}

extension QuestEntity : Identifiable {

}
