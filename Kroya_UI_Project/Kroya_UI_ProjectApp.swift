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
    @StateObject var addNewFood = AddNewFoodVM()
    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
    @State private var isSplashScreenActive = true // State to control SplashScreen display
    @State var lang: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    let modelContainer: ModelContainer
    init() {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
        // Initialize the modelContainer with the Draft model for persistence
        modelContainer = try! ModelContainer(for: Draft.self) // Draft model should be in SwiftData
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
                                .environment(\.modelContext, modelContainer.mainContext)
                                .environmentObject(addNewFood)
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
                        }
                    }
                }
            }
        }
    }
}
