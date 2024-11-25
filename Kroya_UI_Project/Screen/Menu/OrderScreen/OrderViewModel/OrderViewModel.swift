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
       @Published var OrderForBuyer: [OrderModelForBuyer] = []
       @Published var Purchases: PurchaseModel?
       @Published var isLoading: Bool = false
       @Published var successMessage: String = ""
       @Published var showError: Bool = false
       @Published var errorMessage: String = ""
       @Published var isUpdate: Bool = false
       @Published var isOrderSuccess: Bool = false
  
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
                self?.endLoading()
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
    func fetchSearchPurchaseByName(searchText: String)  {
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
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self.orders = payload
                    } else {
                        print("Error fetching purchase: \(response.message)")
                        self.errorMessage = response.message
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to fetch purchases: \(error.localizedDescription)"
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
    //MARK: Add Purchase
    func addPurchase(purchase: PurchaseRequest, paymentType: String) {
        self.isLoading = true
        PurchaseService.shared.AddPurchase(purchase: purchase, paymentType: paymentType) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let purchaseResponse):
                    if purchaseResponse.statusCode == "200", let Purchases = purchaseResponse.payload {
                        self?.Purchases = Purchases
                        self?.isOrderSuccess = true
                        self?.showError = false
                        self?.successMessage = purchaseResponse.message
                    } else {
                        self?.showError = true
                        self?.errorMessage = "Failed to add purchase. Please try again."
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to add purchase: \(error.localizedDescription)"
                    self?.showError = true
                    print("Error adding purchase: \(error.localizedDescription)")
                }
            }
        }
    }

    
    //MARK: Get Receipt by PurchaseId
    func getReceipt(purchaseId: Int) {
        self.startLoading()
        PurchaseService.shared.getReceiptByPurchaseId(purchaseId: purchaseId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if let purchase = response {
                        self?.successMessage = "Purchase added successfully!"
                        self?.Purchases = purchase
                    } else {
                        self?.errorMessage = "Failed to add purchase: Invalid response from server."
                        self?.showError = true
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription.contains("404") ? "No receipt found for this order." : "Failed to load receipt. Please try again."
                    self?.showError = true

                }
            }
        }
    }
    
    func updatePurchaseStatus(purchaseId: Int, newStatus: String) {
        startLoading()
        PurchaseService.shared.UpdatePurchaseByPurchaseId(purchaseId: purchaseId, newStatus: newStatus) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.endLoading()
                switch result {
                case .success(let response):
                    if let updatedPurchase = response.payload {
                        self.isUpdate = true
                        self.successMessage = "Purchase updated successfully."
                        print("Purchase updated successfully: \(updatedPurchase)")
                    } else {
                        self.errorMessage = "Failed to fetch updated purchase details."
                        self.showError = true
                        print("Failed to fetch updated purchase details.")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    print("Failed to update purchase: \(error.localizedDescription)")
                }
            }
        }
    }

}
