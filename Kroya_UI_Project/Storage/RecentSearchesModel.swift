//
//  RecentSearchesModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 14/11/24.
//

import SwiftData
import SwiftUI

@Model
class RecentSearchesModel {
    var title: String
    var email: String

    init(title: String, email: String) {
        self.title = title
        self.email = email
    }
}
