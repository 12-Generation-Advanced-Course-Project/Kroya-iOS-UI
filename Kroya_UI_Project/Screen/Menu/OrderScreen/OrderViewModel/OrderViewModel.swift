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
    
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
    // MARK: fetch purchase all
    func fetchAllPurchase() {
        self.startLoading()
        PurchaseService.shared.getAllPurchases { [weak self] result in
            DispatchQueue.main.async {
                self!.endLoading()
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
    
    
    // MARK: Search Food Recipe by Name
    func fetchSearchPurchaseByName(searchText: String) {
        PurchaseService.shared.getSearchPurchaseByName(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.orders = payload
                        self?.fetchAllPurchase()
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load recipes: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    // MARK: fetch purchase all
    func fetchPurchaseOrder() {
        self.startLoading()
        PurchaseService.shared.getPurchaseOrder { [weak self] result in
            DispatchQueue.main.async {
                self!.endLoading()
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
    
    
    // MARK: fetch purchase all
    func fetchPurchaseSale() {
        self.startLoading()
        PurchaseService.shared.getPurchaseSale { [weak self] result in
            DispatchQueue.main.async {
                self!.endLoading()
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
