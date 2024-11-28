//
//  SaleReportVM.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 21/11/24.
//

import SwiftUI
class SaleReportVM: ObservableObject {
    @Published var totalMonthlySales: Double = 0
    @Published var totalDailySales: Double = 0
    @Published var totalDailyOrders: Double = 0
    @Published var purchaseResponses: [OrderRequestModel] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    func fetchSaleReport(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)

        isLoading = true
        SaleReportService.shared.getSaleReport(date: formattedDate) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.totalMonthlySales = payload.totalMonthlySales
                        self?.totalDailySales = payload.dailySaleReport.totalSales
                        self?.totalDailyOrders = payload.dailySaleReport.totalOrders
                        self?.purchaseResponses = payload.dailySaleReport.purchaseResponses
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to fetch sales report: \(error.localizedDescription)"
                }
            }
        }
    }
}
