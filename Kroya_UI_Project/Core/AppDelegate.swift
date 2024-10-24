//
//  AppDelegate.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
        return true
    }
}

