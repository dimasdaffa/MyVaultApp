//
//  NotificationManager.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/06/26.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Requests notification authorization from the user
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    /// Schedules a local notification for when the item's cooldown timer expires
    func scheduleNotification(for item: VaultItem) {
        let targetDate = item.targetDate
        let timeInterval = targetDate.timeIntervalSinceNow
        
        // Only schedule if the date is in the future
        guard timeInterval > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Cooling Down Finished!"
        content.body = "Time is up for \(item.name). You can now validate your decision!"
        content.sound = .default
        content.badge = 1
        
        // Trigger fires at the calculated interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for item \(item.name) in \(timeInterval) seconds.")
            }
        }
    }
    
    /// Cancels any scheduled notification for the given item (e.g. if deleted)
    func cancelNotification(for item: VaultItem) {
        let identifier = item.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Cancelled pending notification for item: \(item.name)")
    }
    
    /// Clears the app badge and removes all delivered notifications
    func clearBadgeAndNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        center.setBadgeCount(0) { error in
            if let error = error {
                print("Error resetting badge: \(error.localizedDescription)")
            } else {
                print("Badge reset to 0 successfully.")
            }
        }
    }
}
