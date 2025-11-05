//
//  DailyPlan+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 02/11/25.
//
//

import Foundation
import CoreData


extension DailyPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyPlan> {
        return NSFetchRequest<DailyPlan>(entityName: "DailyPlan")
    }

    @NSManaged public var id: String?
    @NSManaged public var day: Int16
    @NSManaged public var summary: String?
    @NSManaged public var places: NSSet?

}

// MARK: Generated accessors for places
extension DailyPlan {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: Place)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: Place)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

extension DailyPlan : Identifiable {

}
