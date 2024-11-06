//
//  AddressRequest.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import Foundation

struct AddressRequest: Codable {
    var addressDetail: String
    var specificLocation: String
    var tag: String
    var latitude: Double
    var longitude: Double
}
