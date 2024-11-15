//
//  OrderViewModel.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 8/10/24.
//

import SwiftUI
import Alamofire

class OrderViewModel: ObservableObject {
    
    @Published var orders: [OrderModel] = []
    
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isUpdate: Bool = false
    
    
    
    // MARK: fetch purchase all
    func fetchAllPurchase() {
        //           self.isLoading = true
        PurchaseService.shared.getAllPurchases { [weak self] result in
            DispatchQueue.main.async {
                //                   self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.orders = payload
                    }else {
                        print("Error fetching purchase: \(response.message)")
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch purchases: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
}
