import SwiftUI
import SwiftData
import Network

@main
struct Kroya_UI_ProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var userStore = UserStore()
    @StateObject var userStore: UserStore
    @StateObject var authVM: AuthViewModel
    @State private var isSplashScreenActive = true
    @State private var isConnected = true
    @State var lang: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    let modelContainer: ModelContainer
    private let monitor = NWPathMonitor()

    init() {
        
        // Create a local instance of UserStore
        let userStoreInstance = UserStore()
        // Initialize 'userStore' using the local instance
        _userStore = StateObject(wrappedValue: userStoreInstance)
        // Initialize 'authVM' using the same local instance
        _authVM = StateObject(wrappedValue: AuthViewModel(userStore: userStoreInstance))

        // Configure the navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Configure back indicator image with template rendering
        if let backImage = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate) {
            appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        }
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear] // Hides back button text

        // Set shadow color to nil to remove underline
        appearance.shadowColor = nil // This removes the underline/shadow under the navigation bar

        // Apply appearance to UINavigationBar
        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = .black // Set tint color for the back arrow and other bar button items

        // Apply global tint color for UIBarButtonItem as well
        UIBarButtonItem.appearance().tintColor = .black
        
//        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
        // Initialize modelContainer with both Draft and RecentSearchesModel
        modelContainer = try! ModelContainer(for: Draft.self, RecentSearchesModel.self, WeBillAccount.self)
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
                        .environmentObject(authVM) // Inject into environment
                } else {
                    if isConnected {
                        contentView
                            .environmentObject(userStore)
                            .environmentObject(authVM) // Inject into environment
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
            if authVM.isLoggedIn {
                NavigationStack {
                    MainScreen(lang: $lang)
                        .environmentObject(userStore)
                        .environmentObject(authVM)
                        .environment(\.locale, .init(identifier: lang))
                        .environment(\.modelContext, modelContainer.mainContext)
                }
            } else {
                NavigationView {
                    LoginScreenView(lang: $lang)
                        .environmentObject(userStore)
                        .environmentObject(authVM)
                        .environment(\.locale, .init(identifier: lang))
                        .environment(\.modelContext, modelContainer.mainContext)
                }
            }
        }
    }
    
//    private var contentView: some View {
//            Group {
////                if Auth.shared.loggedIn {
//                if authVM.isLoggedIn {
//                    NavigationView {
////                        MainScreen(userStore: userStore, lang: $lang)
//                        MainScreen(lang: $lang)
//                            .environmentObject(userStore)
//                            .environmentObject(authVM) // Use authVM
////                            .environmentObject(Auth.shared)
//                            .environment(\.locale, .init(identifier: lang))
//                            .environment(\.modelContext, modelContainer.mainContext)
//                    }
//                } else {
//                    NavigationView {
//                        LoginScreenView(userStore: userStore, lang: $lang)
//                        LoginScreenView(lang: $lang)
//                            .environmentObject(userStore)
//                            .environmentObject(authVM) // Use authVM
////                            .environmentObject(Auth.shared)
//                            .environment(\.locale, .init(identifier: lang))
//                            .environment(\.modelContext, modelContainer.mainContext)
//                    }
//                }
//            }
//        }

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

