//
//  Machia+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 6/20/25.
//
//

import Foundation
import CoreData


extension Machia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Machia> {
        return NSFetchRequest<Machia>(entityName: "Machia")
    }

    @NSManaged public var hp: Int32

}

extension Machia : Identifiable {

}
