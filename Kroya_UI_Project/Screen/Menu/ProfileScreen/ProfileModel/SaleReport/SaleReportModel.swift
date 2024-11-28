//
//  SaleReportModel.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 21/11/24.
//

import Foundation

struct SaleReportModel: Decodable {
    let totalMonthlySales: Double
    let dailySaleReport: DailySaleReport
}
// MARK: - DailySaleReport
struct DailySaleReport: Codable {
    let totalSales: Double
    let totalOrders: Double
    let purchaseResponses: [OrderRequestModel]
}
