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
    var password: String?
}

//MARK: Struct for tokens as seen in the response payload
struct LoginandRegisterResponse: Decodable {
    let access_token: String
    let refresh_token: String
    let profile_image: String?
    let full_name: String?
    let email: String?
    let created_date: String?
}

struct RefreshTokenPay: Decodable {
    let accessToken: String
    let refreshToken: String
}
// MARK: - Payload for User Info
struct UserPayload: Codable {
    let userName: String
    let phoneNumber: String
    let address: String
}

//MARK: Response OTP
struct OtpResponse: Codable {
    let email: String
    let otp: String
}

struct ValidationOTPCode: Codable {
    let email: String
    let isEmailVerified: Bool
    let verifiedAt: String
}

struct userModel: Codable {
    var id: Int
    var fullName: String
    var profileImage: String?
    var email: String?
    var phoneNumber: String?
}
struct DeviceTokenModel: Codable {
    var deviceToken: String
}

struct SellerInformation: Identifiable, Codable {
    var id: Int
    var fullName: String?
    var phoneNumber: String?
    var profileImage: String?
    var location: String?
    
    // Map userId from JSON to id in the struct
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case fullName
        case phoneNumber
        case profileImage
        case location
    }
}
