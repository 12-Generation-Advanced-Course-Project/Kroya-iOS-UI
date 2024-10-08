//
//  DateUtils.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 26/9/24.
//

// DateUtils.swift
import Foundation
import SwiftUI

struct DateUtils {
    static func formatDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
