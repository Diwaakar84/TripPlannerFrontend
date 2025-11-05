//
//  Plan+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 05/11/25.
//
//

import Foundation
import CoreData


extension Plan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        return NSFetchRequest<Plan>(entityName: "Plan")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var startDate: String?
    @NSManaged public var days: NSSet?

}

// MARK: Generated accessors for days
extension Plan {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: DailyPlan)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: DailyPlan)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}

extension Plan : Identifiable {

}
