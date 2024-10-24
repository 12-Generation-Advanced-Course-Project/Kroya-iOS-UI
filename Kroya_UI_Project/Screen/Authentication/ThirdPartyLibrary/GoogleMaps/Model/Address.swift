//
//  Address.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//
import Foundation

struct Address: Codable, Identifiable, Equatable {
    var id: Int
    var addressDetail: String
    var specificLocation: String
    var tag: String
}

