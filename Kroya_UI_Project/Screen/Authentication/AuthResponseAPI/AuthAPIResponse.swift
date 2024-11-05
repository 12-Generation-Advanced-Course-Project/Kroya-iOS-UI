//
//  AuthAPIResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/10/24.
//

import Foundation
import SwiftUI

// Generic API response model
struct AuthAPIResponse<T: Decodable>: Decodable {
    let payload: T?
    let message: String
    let statusCode: String
    let timestamp: String?
}


typealias EmailCheckResponse = AuthAPIResponse<String>
typealias SendOTPResponse = AuthAPIResponse<String>
typealias VerificationCodeRequestResponse = AuthAPIResponse<String>
typealias CreatePasswordResponse = AuthAPIResponse<LoginandRegisterResponse>
typealias LoginAccountResponse = AuthAPIResponse<LoginandRegisterResponse>
typealias RefreshTokenResponse = AuthAPIResponse<RefreshTokenPay>
typealias UserInfoResponse = AuthAPIResponse<Payload>



