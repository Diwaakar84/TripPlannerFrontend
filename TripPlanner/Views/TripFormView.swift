//
//  TripFormView.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import SwiftUI

struct TripFormView: View {
    @StateObject private var viewModel = TripViewModel()
    
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
                        Task { await viewModel.generateTrip() }
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
            .navigationDestination(isPresented: .constant(viewModel.trip != nil)) {
                if let trip = viewModel.trip {
                    TripResultView(
                        trip: trip,
                        location: viewModel.destination
                    )
                }
            }
        }
    }
}

