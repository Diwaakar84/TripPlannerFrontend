//
//  File.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import Foundation
import CoreLocation

struct PlanDetails: Identifiable, Codable, Hashable {
    var id: String = ""
    var startDate: String = ""
    var title: String = ""
    var days: [DayPlan] = []
}

struct DayPlan: Identifiable, Codable, Hashable {
    var id: String = ""
    var day: Int = 0
    var summary: String = ""
    var places: [PlaceDetails] = []
}

struct PlaceDetails: Identifiable, Codable, Hashable {
    var id: String = ""
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}
