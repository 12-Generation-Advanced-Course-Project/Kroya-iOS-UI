//
//  Kroya_UI_ProjectApp.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 26/9/24.
//

import SwiftUI
//import GoogleMaps
@main
struct Kroya_UI_ProjectApp: App {
//    @StateObject var addressViewModel = AddressViewModel()
//    init() {
//        GMSServices.provideAPIKey(Constants.GoogleMapsAPIkeys)
//    }
//
    @StateObject private var userStore = UserStore()
    var body: some Scene {
        WindowGroup {
            LoginScreenView(userStore: userStore)
                            .environmentObject(userStore)
          
        }
    }
}
