//
//  APIResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import Foundation

struct ApiResponse1<T: Codable>: Codable {
    var payload: T
    var message: String
    var code: Int
    var error: Bool
    var date: String
}
