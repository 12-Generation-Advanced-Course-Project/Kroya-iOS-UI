//
//  ProfileModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import SwiftUI
// MARK: - Full API Response
struct UserProfileResponse: Codable {
    let payload: ProfileModel?
    let message: String
    let statusCode: String
    let timestamp: String?
}

// MARK: - Profile Model (Payload)
struct ProfileModel: Codable {
    let id: Int
    let fullName: String?
    let email: String
    let profileImage: String?
    let phoneNumber: String?
    let password: String
    let location: String?
    let role: String
    let createdAt: String
    let emailVerifiedAt: String?
    let emailVerified: Bool
}
