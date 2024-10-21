//
//  UserInfoModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 13/10/24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String { email }
    var email: String
    var userName: String?
    var phoneNumber: String?
    var address: String?
    var accesstoken: String?
    var refreshtoken: String?
}

// Struct for tokens as seen in the response payload
struct TokenPayload: Decodable {
    let access_token: String
    let refresh_token: String
}

struct RefreshTokenPayload: Decodable {
    let access_token: String
    let refresh_token: String
}
