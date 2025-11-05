//
//  CoreDataManager.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 02/11/25.
//

import CoreData

class CoreDataManager {
    // Creating a singleton object to use throughout the app
    static let shared = CoreDataManager()
    
    private let context = PersistenceController.shared.container.viewContext
    
    // Save the fetched trip details
    func saveTrip(plan: PlanDetails) {
        let fetchRequest: NSFetchRequest<Plan> = Plan.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", plan.title)

        do {
            // Check for existing plan
            let existingPlans = try context.fetch(fetchRequest)
            let planEntity: Plan

            if let existingPlan = existingPlans.first {
                print("♻️ Updating existing trip: \(plan.title)")
                planEntity = existingPlan

                // Remove old relationships before reassigning
                if let existingDays = planEntity.days as? Set<DailyPlan> {
                    for day in existingDays {
                        if let places = day.places as? Set<Place> {
                            for place in places {
                                context.delete(place)
                            }
                        }
                        context.delete(day)
                    }
                }
            } else {
                print("🆕 Creating new trip: \(plan.title)")
                planEntity = Plan(context: context)
                planEntity.id = plan.id
            }

            // Update base plan info
            planEntity.title = plan.title
            planEntity.startDate = plan.startDate

            // Rebuild relationships
            var days: [DailyPlan] = []
            for day in plan.days {
                let dailyPlanEntity = DailyPlan(context: context)
                dailyPlanEntity.id = day.id
                dailyPlanEntity.day = Int16(day.day)
                dailyPlanEntity.summary = day.summary

                // Places
                var places: [Place] = []
                for place in day.places {
                    let placeEntity = Place(context: context)
                    placeEntity.id = place.id
                    placeEntity.name = place.name
                    placeEntity.latitude = place.latitude
                    placeEntity.longitude = place.longitude
                    places.append(placeEntity)
                }

                dailyPlanEntity.places = NSSet(array: places)
                days.append(dailyPlanEntity)
            }

            planEntity.days = NSSet(array: days)

            try context.save()
            print("💾 Trip saved/updated successfully.")

        } catch {
            print("❌ Error saving trip: \(error)")
        }
    }
    
    // Fetch the list of all plans stored
    func fetchTrips() -> [PlanDetails] {
        let request: NSFetchRequest<Plan> = Plan.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { planEntity in
                // Fetch the list of days of the trip
                let days: [DayPlan] = (planEntity.days?.allObjects as? [DailyPlan])?.map {
                    
                    // Fetch the list of places for the day
                    let places = ($0.places?.allObjects as? [Place])?.map { place in
                        return PlaceDetails(
                            id: place.id ?? "",
                            name: place.name ?? "",
                            latitude: place.latitude,
                            longitude: place.longitude
                        )
                    } ?? []
                    
                    return DayPlan(
                        id: $0.id ?? "",
                        day: Int($0.day),
                        summary: $0.summary ?? "",
                        places: places
                    )
                } ?? []
                
                
                return PlanDetails(
                    id: planEntity.id ?? "",
                    startDate: planEntity.startDate ?? "",
                    title: planEntity.title ?? "",
                    days: days
                )
            }
        } catch {
            print("Error fetching trips: \(error)")
            return []
        }
    }
    
    // Clean up function used to clear the DB when needed
    func deleteAllTrips() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Plan.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("🧹 All trips deleted successfully.")
        } catch {
            print("❌ Failed to delete trips: \(error.localizedDescription)")
        }
    }
}
