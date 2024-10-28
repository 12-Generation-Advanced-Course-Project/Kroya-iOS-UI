//
//  LocalNotificationManager.swift
//  LocalNotification
//
//  Created by Ounbonaliheng on 20/9/24.
//

import UserNotifications
import SwiftUI
import Combine



class LocalNotificationManager {
    static var shared = LocalNotificationManager()
    private init() {}
    
    func askForNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        {
            success, error in
            if success {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func SendNotification(selectDate: Date){
        let content = UNMutableNotificationContent()
        content.title = "Kroya Mobile"
        content.subtitle = "You have a new notification"
        content.sound = UNNotificationSound.default
        let dataComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: selectDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendImmediateNotification() {
           let content = UNMutableNotificationContent()
           content.title = "Kroya Mobile"
           content.subtitle = "ចង់ញុំាម្ហូបអីដែលបង?🫵"
           content.sound = UNNotificationSound.default
           
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
           
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
           
           UNUserNotificationCenter.current().add(request)
       }

    
}

class AppDelegateForLocalNotification: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
