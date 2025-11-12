//
//  TripViewModel.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import Foundation
import Combine

@MainActor
class TripViewModel: ObservableObject {
    @Published var destination = ""
    @Published var days = 3
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var savedTrips: [PlanDetails] = []
    
    private let service = TripService()
    
    func generateTrip(completion: (_ trip: PlanDetails) -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await service.generateTrip(
                location: destination,
                days: days
            )
            
            // Send notification to user once the trip is generated
            NotificationService.shared.tripGeneratedNotification(
                id: result.id,
                title: result.title
            )
            
            completion(result)
        } catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchSavedTrips() {
        savedTrips = CoreDataManager.shared.fetchTrips()
    }
}
