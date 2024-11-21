//
//  WeBillAccount.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 21/11/24.
//

// WeBillAccount.swift

// WeBillAccount.swift

import SwiftData

@Model
class WeBillAccount {
    var email: String
    var clientId: String
    var secretId: String

    init(email: String, clientId: String, secretId: String) {
        self.email = email
        self.clientId = clientId
        self.secretId = secretId
    }
}
