//
//  FeedBackModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 16/11/24.
//

import SwiftUI
struct FeedBackModel: Decodable {
    let feedbackId: Int
    let user: userModel
    let ratingValue: Int?
    let commentText: String?
    let createdAt: String
}
