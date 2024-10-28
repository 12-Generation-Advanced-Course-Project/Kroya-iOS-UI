//
//  Kroya_UI_ProjectApp.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 26/9/24.
//

import SwiftUI
import GoogleMaps
//
//@main
//struct Kroya_UI_ProjectApp: App {
//    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
//    @StateObject private var userStore = UserStore()
//        init() {
//            GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
//        }
//    var body: some Scene {
//        WindowGroup {
//            UserBasicInfoView()
//                .environmentObject(userStore)
//                .environmentObject(addressViewModel)
//        }
//    }
//}


@main
struct Kroya_UI_ProjectApp: App {
    @UIApplicationDelegateAdaptor var appdelegate: AppDelegateForLocalNotification
    @StateObject var userStore = UserStore()
    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
    init() {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if Auth.shared.getAccessToken() != nil {
                    NavigationView {
                        MainScreen(userStore: userStore)
                            .environmentObject(userStore)
                            .environmentObject(Auth.shared)
                            .environmentObject(addressViewModel)
                            .onAppear{
                                UNUserNotificationCenter.current().delegate = appdelegate
                            }
                    }
                }else {
                    if Auth.shared.loggedIn != true {
                        NavigationView {
                            LoginScreenView(userStore: userStore)
                                .environmentObject(userStore)
                                .environmentObject(Auth.shared)
                                .environmentObject(addressViewModel)
                        }
                    }
                    else {
                        
                    }
                   
                }
                
            }
           
        }
    }
}
