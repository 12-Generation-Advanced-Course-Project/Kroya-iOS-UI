//
//  WeBill365.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 21/11/24.
//

import SwiftUI
import Foundation

struct WeBill365Response: Decodable {
    let data: WeBill365Data?
    let status: WeBill365Status?
}

struct WeBill365Data: Decodable {
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct WeBill365Status: Decodable {
    let code: Int?
    let message: String?
}
