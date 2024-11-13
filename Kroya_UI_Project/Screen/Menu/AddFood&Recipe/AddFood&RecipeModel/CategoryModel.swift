//
//  CategoryModel.swift
//  Kroya_UI_Project
//
//  Created by kosign on 7/11/24.
//

import SwiftUI

struct CategoryResponse<T: Decodable>: Decodable{
    let message: String
    let payload:[T]?
    let statusCode: String
    let timestamp: String?
}

struct CategoryModel: Identifiable ,Decodable{
    var id: Int
    var categoryName: String

}

typealias CategoryResponses = CategoryResponse<CategoryModel>



