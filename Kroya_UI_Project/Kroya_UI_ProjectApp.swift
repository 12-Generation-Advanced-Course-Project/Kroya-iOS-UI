//
//  Kroya_UI_ProjectApp.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 26/9/24.
//

import SwiftUI
import GoogleMaps
import SwiftData
import Network

@main
struct Kroya_UI_ProjectApp: App {
    @UIApplicationDelegateAdaptor var appdelegate: AppDelegateForLocalNotification
    @StateObject var userStore = UserStore()
    @StateObject var addNewFoodVM = AddNewFoodVM()
    @StateObject var addressViewModel = AddressViewModel(userStore: UserStore())
    @State private var isSplashScreenActive = true
    @State private var isConnected = true
    @State var lang: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    let modelContainer: ModelContainer
    private let monitor = NWPathMonitor()

    init() {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
        modelContainer = try! ModelContainer(for: Draft.self)
        setupNetworkMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashScreenActive {
                    SplashScreen(isSplashScreenActive: $isSplashScreenActive, lang: $lang)
                        .environmentObject(userStore)
                        .environmentObject(addNewFoodVM)
                        .environmentObject(addressViewModel)
                } else {
                    contentView // Show the main content view
                        .overlay(
                            // Display OfflineMessageView as an overlay when disconnected
                            isConnected ? nil : OfflineMessageView(retryAction: checkNetworkAgain)
                        )
                }
            }
            .onAppear {
                checkInitialConnection() // Check connection immediately on app launch
            }
        }
    }
    
    private var contentView: some View {
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

    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                isConnected = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    private func checkInitialConnection() {
        // Manually check the connection status on app launch
        isConnected = monitor.currentPath.status == .satisfied
    }

    private func checkNetworkAgain() {
        // Dismiss the offline message temporarily
        isConnected = monitor.currentPath.status == .satisfied

        // Delay for 1 second to allow for network recheck
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Check the network status again after the delay
            isConnected = monitor.currentPath.status == .satisfied
            
            // If still not connected, the overlay (OfflineMessageView) will reappear
        }
    }

}
