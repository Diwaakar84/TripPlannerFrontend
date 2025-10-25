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
    @Published var trip: PlanDetails? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let service = TripService()
    
    func generateTrip() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await service.generateTrip(
                location: destination,
                days: days
            )
            self.trip = result
        } catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}
