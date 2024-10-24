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
//                .environmentObject(addressViewModel) // Inject AddressViewModel here
//        }
//    }
//}


@main
struct Kroya_UI_ProjectApp: App {
//    @StateObject var addressViewModel = AddressViewModel()
    @StateObject private var userStore = UserStore()
    init() {
        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen().environmentObject(userStore)
                .environmentObject(Auth.shared)
           
        }
    }
}
