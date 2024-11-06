//
//  APIResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import Foundation

struct AddressResponse<T: Codable>: Codable {
    var payload: T?
    var message: String
    var statusCode: String
    var timestamp: String?
}

typealias AddressResponseApi = AddressResponse<Address>
