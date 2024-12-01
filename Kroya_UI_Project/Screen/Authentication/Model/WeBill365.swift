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

struct QuickBillsRequest: Codable {
    var accountName:String
    var paymentType:String
    var currencyCode:String
    var issueDatetime:String
    var paymentTerm:String
    var parentAccountNo:String
    var amount:Int
    var remark:String
    
    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case paymentType = "payment_type"
        case currencyCode = "currency_code"
        case issueDatetime = "issue_datetime"
        case paymentTerm = "payment_term"
        case parentAccountNo = "parent_account_no"
        case amount = "amount"
        case remark = "remark"
    }
}


struct QRCollectionResponse<T: Decodable>: Decodable {
    let data: T?
    let status: Status?
}

struct DataForQRCollection: Decodable {
    var billNo: String
    var accountNo: String
    var khqrdata: String

    enum CodingKeys: String, CodingKey {
        case billNo = "bill_no"
        case accountNo = "account_no"
        case khqrdata = "khqr_data"
    }
}

struct Status: Decodable {
    let code: Int
    let message: String
}

struct CheckingStatus<T: Decodable>: Decodable {
    let data: [T]?
    let status: Status?
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



// MARK: - Get Credientail User
struct SellerCredentials : Codable {
    let message: String
        let payload: Payload
        let statusCode, timestamp: String
    }

    // MARK: - Payload
    struct Payload: Codable {
        let id: Int
        let clientID, clientSecret, accountNo: String

        enum CodingKeys: String, CodingKey {
            case id
            case clientID = "clientId"
            case clientSecret, accountNo
        }
    }
