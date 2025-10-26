//
//  TripMapView.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import SwiftUI
import MapKit

struct TripMapView: View {
    var places: [PlaceDetails]
    @StateObject private var routeVM = RouteViewModel()
    @State private var region = MKCoordinateRegion()
    
    let routeColors: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .teal]
    
    var body: some View {
        Map(position: .constant(.region(region))) {
            // Markers for each place
            ForEach(places) { place in
                Annotation(
                    place.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                ) {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 10, height: 10)
                        Circle()
                            .stroke(.white, lineWidth: 2)
                            .frame(width: 10, height: 10)
                    }
                }
            }

            // Draw the real driving routes
            ForEach(Array(routeVM.routes.enumerated()), id: \.element) { index, route in
                MapPolyline(route.polyline)
                    .stroke(
                        routeColors[index % routeColors.count],
                        style: StrokeStyle(
                            lineWidth: 4,
                            lineCap: .round,
                            lineJoin: .round)
                    )
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .task {
            // Set region when the map loads
            if let first = places.first {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: first.latitude,
                        longitude: first.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.15,
                        longitudeDelta: 0.15)
                )
            }
            // Fetch driving routes
            await routeVM.fetchRoutes(for: places)
        }
    }
}
