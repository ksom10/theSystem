//
//  XPStat+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 5/21/25.
//
//

import Foundation
import CoreData


extension XPStat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<XPStat> {
        return NSFetchRequest<XPStat>(entityName: "XPStat")
    }

    @NSManaged public var category: String?
    @NSManaged public var xp: Int32

}

extension XPStat : Identifiable {

}
