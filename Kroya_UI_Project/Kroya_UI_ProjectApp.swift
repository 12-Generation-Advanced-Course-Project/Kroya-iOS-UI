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
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
        // Initialize modelContainer with both Draft and RecentSearchesModel
        modelContainer = try! ModelContainer(for: Draft.self, RecentSearchesModel.self)
        setupNetworkMonitoring()
        
        // Clear Keychain on first launch after reinstall
        if isFirstLaunchAfterReinstall() {
            Auth.shared.clearAllCredentials()
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashScreenActive {
                    SplashScreen(isSplashScreenActive: $isSplashScreenActive, lang: $lang)
                        .environmentObject(userStore)
                        .environmentObject(addressViewModel)
                } else {
                    if isConnected {
                        contentView
                    } else {
                        OfflineMessageView(retryAction: checkNetworkAgain)
                    }
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
        isConnected = monitor.currentPath.status == .satisfied
    }

    private func checkNetworkAgain() {
        isConnected = monitor.currentPath.status == .satisfied
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if monitor.currentPath.status != .satisfied {
                isConnected = false // Re-show the offline message if still offline
            }
        }
    }

    private func isFirstLaunchAfterReinstall() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            return true
        }
        return false
    }
}

