//
//  UserStore.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 13/10/24.
//

import Foundation
import Combine

class UserStore: ObservableObject {
    @Published var user: User?
//    @Published var isBasicInfoComplete: Bool = UserDefaults.standard.bool(forKey: "isBasicInfoComplete")
//    @Published var isNewlyRegistered: Bool = UserDefaults.standard.bool(forKey: "isNewlyRegistered")

    func setUser(email: String, userName: String? = nil, phoneNumber: String? = nil, address: String? = nil, accesstoken: String? = nil, refreshtoken: String? = nil, password: String? = nil) {
        self.user = User(
            email: email,
            userName: userName,
            phoneNumber: phoneNumber,
            address: address,
            accesstoken: accesstoken,
            refreshtoken: refreshtoken,
            password: password
        )
    }

//    func setBasicInfoComplete(_ complete: Bool) {
//        self.isBasicInfoComplete = complete
//        UserDefaults.standard.set(complete, forKey: "isBasicInfoComplete")
//    }
//
//    func setNewlyRegistered(_ newlyRegistered: Bool) {
//        self.isNewlyRegistered = newlyRegistered
//        UserDefaults.standard.set(newlyRegistered, forKey: "isNewlyRegistered")
//    }

    func clearUser() {
        self.user = nil
//        setBasicInfoComplete(false) // Reset basic info completion status
//        setNewlyRegistered(false) // Reset newly registered status
//        UserDefaults.standard.removeObject(forKey: "isBasicInfoComplete")
//        UserDefaults.standard.removeObject(forKey: "isNewlyRegistered")
    }
}
