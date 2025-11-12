//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 22/10/25.
//

import SwiftUI

@main
struct TripPlannerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var notificationService = NotificationService.shared
    
    // When the app is initialized ask user for notification permission
    init() {
        NotificationService.shared.requestUserAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            TripFormView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationService)
        }
    }
}
