//
//  TripResultView.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import SwiftUI

struct TripResultView: View {
    var trip: PlanDetails
    var location: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(location)
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                
                ForEach(trip.days) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Day \(day.day)")
                            .font(.headline)
                        Text(day.summary)
                            .font(.subheadline)
                        TripMapView(places: day.places)
                            .frame(height: 250)
                            .cornerRadius(12)
                    }
                    .padding(.vertical)
                }
            }
            .padding()
        }
        .navigationTitle("Your Trip")
    }
}

