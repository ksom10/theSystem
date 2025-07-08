//
//  Neverest+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 7/2/25.
//
//

import Foundation
import CoreData


extension Neverest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Neverest> {
        return NSFetchRequest<Neverest>(entityName: "Neverest")
    }

    @NSManaged public var hp: Int32

}

extension Neverest : Identifiable {

}
