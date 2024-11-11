//
//  FoodSellRequest.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 9/11/24.
//

import SwiftUI

struct FoodSellRequest:Encodable {
    var dateCooking: String
    var amount: Int
    var price: Int
    var location: String
}
