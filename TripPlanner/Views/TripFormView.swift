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
                
                Section {
                    if let error = viewModel.errorMessage {
                        Text(error)
                    }
                }
            }
            .navigationTitle("AI Trip Planner")
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

