//
//  Kroya_UI_ProjectApp.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 26/9/24.
//

import SwiftUI
import GoogleMaps


@main
struct Kroya_UI_ProjectApp: App {
    @UIApplicationDelegateAdaptor var appdelegate: AppDelegateForLocalNotification
    @StateObject var userStore = UserStore()
    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
    @State private var isSplashScreenActive = true // State to control SplashScreen display
    @State var lang: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    
    init() {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
    }
    
    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreen(isSplashScreenActive: $isSplashScreenActive, lang: $lang)
            } else {
                Group {
                    if Auth.shared.loggedIn {
                        NavigationView {
                            MainScreen(userStore: userStore, lang: $lang)
                                .environmentObject(userStore)
                                .environmentObject(Auth.shared)
                                .environmentObject(addressViewModel)
                                .environment(\.locale, .init(identifier: lang))
                                .onAppear {
                                    UNUserNotificationCenter.current().delegate = appdelegate
                                }
                        }
                    } else {
                        NavigationView {
                            LoginScreenView(userStore: userStore, lang: $lang)
                                .environmentObject(userStore)
                                .environmentObject(Auth.shared)
                                .environmentObject(addressViewModel)
                                .environment(\.locale, .init(identifier: lang))
                        }
                    }
                }
            }
        }
    }
}
