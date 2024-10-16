//
//  AuthAPIResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 12/10/24.
//

import Foundation

// Generic API response model
struct ApiResponse<T: Decodable>: Decodable {
    let payload: T?
    let message: String
    let statusCode: String
    let timestamp: String?
}


typealias EmailCheckResponse = ApiResponse<String>
typealias SendOTPResponse = ApiResponse<String>
typealias VerificationCodeRequestResponse = ApiResponse<String>
typealias CreatePasswordResponse = ApiResponse<TokenPayload>





