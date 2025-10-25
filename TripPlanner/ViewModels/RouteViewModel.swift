//
//  RouteViewModel.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import MapKit
import SwiftUI

@MainActor
class RouteViewModel: ObservableObject {
    @Published var routes: [MKRoute] = []
    
    func fetchRoutes(for places: [PlaceDetails]) async {
        routes.removeAll()
        guard places.count > 1 else { return }
        
        for i in 0..<places.count - 1 {
            let sourceCoord = CLLocationCoordinate2D(
                latitude: places[i].latitude,
                longitude: places[i].longitude
            )
            let destCoord = CLLocationCoordinate2D(
                latitude: places[i + 1].latitude,
                longitude: places[i + 1].longitude
            )
            
            let request = MKDirections.Request()
            request.source = MKMapItem(
                placemark: MKPlacemark(coordinate: sourceCoord)
            )
            request.destination = MKMapItem(
                placemark: MKPlacemark(coordinate: destCoord)
            )
            request.transportType = .automobile
            
            do {
                let directions = MKDirections(request: request)
                let response = try await directions.calculate()
                if let route = response.routes.first {
                    routes.append(route)
                }
            } catch {
                print("Failed to fetch route: \(error.localizedDescription)")
            }
        }
    }
}

