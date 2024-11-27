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

struct QRCollectionRequest: Codable {
    var payername:String
    var parentAccountNo:String
    var paymentType:String
    var currencyCode:String
    var amount:Int
    var remark:String
    
    enum CodingKeys: String, CodingKey {
        case payername = "payer_name"
        case parentAccountNo = "parent_account_no"
        case paymentType = "payment_type"
        case currencyCode = "currency_code"
        case amount = "amount"
        case remark = "remark"
    }
}


struct QRCollectionResponse<T: Decodable>: Decodable {
    let data: T?
    let status: Status?
}

struct DataForQRCollection: Decodable{
    var accountNo:String
    var billNo:String
    var khqrdata:String
    
    enum CodingKeys: String, CodingKey {
        case accountNo = "account_no"
        case billNo = "bill_no"
        case khqrdata = "khqr_data"
    }
}

struct Status: Decodable{
    var code: Int
    var message: String
}

struct CheckStatusCodeRequest: Codable {
    var billNo: [String]
    
    enum CodingKeys: String, CodingKey {
        case billNo = "bill_no"
    }
}

// MARK: - WeBill Connect Request
struct ConnectWebillConnectRequest: Codable {
    var clientId: String
    var clientSecret: String
    var accountNo: String
}

// MARK: - WeBill Response
struct ConnectWebillResponse<T: Decodable>: Decodable {
    let message: String
    let payload: T?
    let statusCode: String
    let timestamp: String?
}

// MARK: - WeBill Connect Payload
struct ConnectWebillConnect: Codable {
    var id: Int
    var clientId: String
    var clientSecret: String
    var accountNo: String
}

typealias ConnectWebillResponseData = ConnectWebillResponse<ConnectWebillConnect>
typealias DisconnectWeBillAccountResponse = ConnectWebillResponse<String>



