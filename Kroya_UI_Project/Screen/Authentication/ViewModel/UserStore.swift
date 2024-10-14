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

    func setUser(email: String, userName: String? = nil, phoneNumber: String? = nil, address: String? = nil) {
        self.user = User(email: email, userName: userName, phoneNumber: phoneNumber, address: address)
    }

    func clearUser() {
        self.user = nil
    }
}
