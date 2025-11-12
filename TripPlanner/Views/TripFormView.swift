//
//  TripFormView.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import SwiftUI

struct TripFormView: View {
    @StateObject private var viewModel = TripViewModel()
    @EnvironmentObject private var notificationService: NotificationService
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var navigateToTrip: PlanDetails? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - New trip generation
                Section("Trip Details") {
                    TextField("Destination", text: $viewModel.destination)
                    Stepper(
                        "Days: \(viewModel.days)",
                        value: $viewModel.days,
                        in: 1...10
                    )
                }
                
                Section {
                    Button {
                        Task {
                            await viewModel.generateTrip { trip in
                                navigateToTrip = trip
                            }
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Generate Plan")
                        }
                    }
                    .disabled(viewModel.destination.isEmpty)
                }
                
                // MARK: - Error message
                Section {
                    if let error = viewModel.errorMessage {
                        Text(error)
                    }
                }
                
                // MARK: - Saved Trips Section
                if !viewModel.savedTrips.isEmpty {
                    Section("Saved Trips") {
                        ForEach(viewModel.savedTrips) { trip in
                            NavigationLink(destination: TripResultView(trip: trip, location: trip.title)) {
                                VStack(alignment: .leading) {
                                    Text(trip.title)
                                        .font(.headline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Trip Planner")
            .onAppear {
                viewModel.fetchSavedTrips()
            }
            .onChange(of: scenePhase) { newPhase in
                // When the app state changes to active check if opened app
                // through notification and if any trip is stored to open
                if(newPhase == .active) {
                    if let tripID = UserDefaults.standard.string(forKey: "lastTappedTripID") {
                        print("Found trip")
                        if let trip = viewModel.savedTrips.first(where: { $0.id == tripID }) {
                            print("navigating")
                            navigateToTrip = trip
                            
                            // Clear the value stored to prevent redirecting again
                            UserDefaults.standard.removeObject(forKey: "lastTappedTripID")
                        }
                    }
                }
            }
            .navigationDestination(item: $navigateToTrip) { trip in
                TripResultView(
                    trip: trip,
                    location: viewModel.destination
                )
            }
        }
    }
}

