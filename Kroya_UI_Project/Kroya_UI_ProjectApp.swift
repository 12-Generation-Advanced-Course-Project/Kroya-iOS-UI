//
//  Kroya_UI_ProjectApp.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 26/9/24.
//

import SwiftUI
import GoogleMaps
import SwiftData

@main
struct Kroya_UI_ProjectApp: App {
    @UIApplicationDelegateAdaptor var appdelegate: AppDelegateForLocalNotification
    @StateObject var userStore = UserStore()
    @StateObject var addNewFoodVM = AddNewFoodVM()
    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
    @State private var isSplashScreenActive = true
    @State var lang: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    let modelContainer: ModelContainer

    init() {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
        modelContainer = try! ModelContainer(for: Draft.self) // Initialize model container for persistence
    }
    
    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreen(isSplashScreenActive: $isSplashScreenActive, lang: $lang)
                    .environmentObject(userStore)
                    .environmentObject(addNewFoodVM)
                    .environmentObject(addressViewModel)
            } else {
                Group {
                    if Auth.shared.loggedIn {
                        NavigationView {
                            MainScreen(userStore: userStore, lang: $lang)
                                .environmentObject(userStore)
                                .environmentObject(Auth.shared)
                                .environmentObject(addressViewModel)
                                .environment(\.locale, .init(identifier: lang))
                                .environment(\.modelContext, modelContainer.mainContext)
                                .environmentObject(addNewFoodVM)
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
                                .environment(\.modelContext, modelContainer.mainContext)
                                .environmentObject(addNewFoodVM)
                        }
                    }
                }
            }
        }
    }
}
