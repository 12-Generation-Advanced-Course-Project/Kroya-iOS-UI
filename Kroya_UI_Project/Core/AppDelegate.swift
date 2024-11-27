//
//  AppDelegate.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

//import GoogleMaps
// new import for FCM Store

import FirebaseMessaging
import UserNotifications
import Firebase
import SwiftUI
///

class AppDelegate: UIResponder , UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Initialize Google Maps
//        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Set FCM messaging delegate
        Messaging.messaging().delegate = self
        
        // Set notification center delegate for handling foreground notifications
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        self.registerForRemoteNotifications(application)
        
        return true
    }
    
    fileprivate func registerForRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10+, set the UNUserNotificationCenter delegate
            UNUserNotificationCenter.current().delegate = self
            
            // Request notification authorization
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
                print("Permission granted: \(granted)")
                
                if let error = error {
                    print("Error in notification authorization: \(error.localizedDescription)")
                    return
                }
                
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // For iOS versions below 10
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs Device Token: \(deviceToken)")
        
        // Set the APNs token in Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
        
        // Explicitly request the FCM token after setting the APNs token
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token after setting APNs token: \(error.localizedDescription)")
            } else if let token = token {
                print("Fetched FCM token after setting APNs token: \(token)")
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Foreground notification received: \(notification.request.content.userInfo)") // Log payload
        completionHandler([.alert, .badge, .sound])
    }

    // handle notification when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Background notification received: \(response.notification.request.content.userInfo)") // Log payload
        completionHandler()
    }

}

// MARK: - FCM Messaging Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Received FCM Token: \(fcmToken ?? "No token")")
        //MARK: Insert Device token
        Auth.shared.setDeviceToken(DeviceToken: fcmToken ?? "")
    }
}
