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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var userStore = UserStore()


    @StateObject var addressViewModel = AddressViewModel()
    @State private var isSplashScreenActive = true
    @State private var isConnected = true
    @State var lang: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    let modelContainer: ModelContainer
    private let monitor = NWPathMonitor()

    init() {
        modelContainer = try! ModelContainer(for: Draft.self)
        setupNetworkMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashScreenActive {
                    SplashScreen(isSplashScreenActive: $isSplashScreenActive, lang: $lang)
                        .environmentObject(userStore)

                        .environmentObject(addressViewModel)
                } else {
                    contentView
                        .overlay(
                            isConnected ? nil : OfflineMessageView(retryAction: checkNetworkAgain)
                        )
                }
            }
            .onAppear {
                checkInitialConnection()
           
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
        isConnected = monitor.currentPath.status == .satisfied
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Check the network status again after the delay
            isConnected = monitor.currentPath.status == .satisfied
        }
    }

}
