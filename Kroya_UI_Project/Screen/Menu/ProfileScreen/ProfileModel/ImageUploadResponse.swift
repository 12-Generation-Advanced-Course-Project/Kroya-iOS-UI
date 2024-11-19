//
//  ImageUploadResponse.swift
//  Kroya_UI_Project
//
//  Created by KAK-REAK on 19/11/24.
//

import Foundation

struct ImageUploadResponse: Decodable {
    let message: String
    let status: Int
    let payload: [String]
}
