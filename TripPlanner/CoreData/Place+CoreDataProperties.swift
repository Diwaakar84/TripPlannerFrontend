//
//  Place+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 02/11/25.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Place : Identifiable {

}
