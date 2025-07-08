//
//  Nightpour+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 6/30/25.
//
//

import Foundation
import CoreData


extension Nightpour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nightpour> {
        return NSFetchRequest<Nightpour>(entityName: "Nightpour")
    }

    @NSManaged public var hp: Int32

}

extension Nightpour : Identifiable {

}
