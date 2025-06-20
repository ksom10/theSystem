//
//  Velkrax+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 5/21/25.
//
//

import Foundation
import CoreData


extension Velkrax {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Velkrax> {
        return NSFetchRequest<Velkrax>(entityName: "Velkrax")
    }

    @NSManaged public var hp: Int32

}

extension Velkrax : Identifiable {

}
