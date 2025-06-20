import Foundation
import CoreData

extension GlobalStats {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GlobalStats> {
        return NSFetchRequest<GlobalStats>(entityName: "GlobalStats")
    }

    @NSManaged public var lifeXP: Int32
    @NSManaged public var velkraxHP: Int32
}

extension GlobalStats: Identifiable {

}

