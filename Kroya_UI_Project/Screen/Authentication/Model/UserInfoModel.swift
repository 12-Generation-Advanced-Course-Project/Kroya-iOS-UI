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
    var accessToken:String?
    var refreshToken:String?
}
