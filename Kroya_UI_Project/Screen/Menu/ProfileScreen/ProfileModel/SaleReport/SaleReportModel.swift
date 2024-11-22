//
//  SaleReportModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 21/11/24.
//

import Foundation

struct SaleReportModel: Decodable {
    let totalMonthlySales: Int
    let dailySaleReport: DailySaleReport
    
}
// MARK: - DailySaleReport
struct DailySaleReport: Codable {
    let totalSales: Int
    let totalOrders: Int
    let purchaseResponses: [OrderRequestModel]
}
