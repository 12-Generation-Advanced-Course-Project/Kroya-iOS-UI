//
//  KroyaAPIResponse.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 24/10/24.
//

import Foundation
import SwiftUI

// Generic API response model
struct KroyaAPIResponse<T: Decodable>: Decodable {
    let payload: T?
    let message: String
    let statusCode: String
    let timestamp: String?
}
//MARK: User Setting Profile
typealias UserSettingProfileResponse = KroyaAPIResponse<ProfileModel>
