//
//  AuraStreak+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 5/21/25.
//
//

import Foundation
import CoreData


extension AuraStreak {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuraStreak> {
        return NSFetchRequest<AuraStreak>(entityName: "AuraStreak")
    }

    @NSManaged public var streakCount: Int32

}

extension AuraStreak : Identifiable {

}
