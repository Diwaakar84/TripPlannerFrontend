//
//  NotificationService.swift
//  TripPlanner
//
//  Created by Diwaakar Adinathan on 12/11/25.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Ask user for notification permission
    func requestUserAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification authorization failed: \(error)")
            } else {
                print(granted ?
                        "✅ Notification permission granted" :
                        "⚠️ Notification permission denied"
                )
            }
        }
    }
    
    // Schedule a notification to be shown once the trip plan has been generated
    func tripGeneratedNotification(id: String, title: String) {
        let content = UNMutableNotificationContent()
        content.title = "Trip plan generated"
        content.body = "Your trip plan for \(title) has been generated successfully!"
        content.userInfo = ["id": id]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Trip generated notification scheduled.")
            }
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    // Called when a notification is delivered while the app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // Called when the user taps the notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            
            if let tripId = userInfo["id"] as? String {
                print("📩 User tapped trip notification for trip ID: \(tripId)")
                
                // Store the trip value in user defaults for navigation on opening app
                UserDefaults.standard.set(tripId, forKey: "lastTappedTripID")
            }
            
            completionHandler()
    }
}
