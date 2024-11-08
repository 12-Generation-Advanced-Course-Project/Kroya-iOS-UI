//
//  ProfileModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import SwiftUI
// MARK: - Full API Response
struct UserProfileResponse: Codable {
    let message: String
    let payload: ProfileModel?
    let statusCode: String
    let timestamp: String?
}

struct ProfileModel: Codable {
    var id: Int?
    var fullName: String?
    var email: String?
    var profileImage: String?
    var phoneNumber: String?
    var password: String?
    var location: String?
    var role: String?
    var createdAt: String?
    var emailVerifiedAt: String?
    var emailVerified: Bool?
}
