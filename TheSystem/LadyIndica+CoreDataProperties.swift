//
//  LadyIndica+CoreDataProperties.swift
//  TheSystem
//
//  Created by Kameron Someson on 6/18/25.
//
//

import Foundation
import CoreData


extension LadyIndica {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LadyIndica> {
        return NSFetchRequest<LadyIndica>(entityName: "LadyIndica")
    }

    @NSManaged public var hp: Int32

}

extension LadyIndica : Identifiable {

}
