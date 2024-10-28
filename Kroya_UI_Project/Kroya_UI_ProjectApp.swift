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
    init() {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
    }
    @State var lang: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    
    var body: some Scene {
        WindowGroup {
            Group {
                if Auth.shared.getAccessToken() != nil {
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
                    if Auth.shared.loggedIn != true {
                        NavigationView {
                            LoginScreenView(userStore: userStore, lang: $lang)
                                .environmentObject(userStore)
                                .environmentObject(Auth.shared)
                                .environmentObject(addressViewModel)
                                .environment(\.locale, .init(identifier: lang))
                        }
                    } else {
                       
                    }
                }
            }
        }
    }
}
