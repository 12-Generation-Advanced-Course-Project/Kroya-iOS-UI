//
//  CuisinesModel.swift
//  Kroya_UI_Project
//
//  Created by kosign on 7/11/24.
//
import SwiftUI

struct CuisinesResponse<T: Decodable>: Decodable {
    
    let message     : String
    let payload     : [T]?
    let statusCode  : String
    let timestamp   : String?
}

struct CuisinesModel: Identifiable , Decodable{
    
    var id          : Int
    var cuisineName : String
    
}

typealias CuisineResponse = CuisinesResponse<CuisinesModel>
