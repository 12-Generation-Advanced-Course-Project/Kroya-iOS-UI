//
//
import SwiftUI
import Foundation
//

class ListFoodName: ObservableObject {
    @Published var allFoodName: [String] = []
    // @Published var allFoodName: [String] = []  // Use [String] here
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private func startLoading(){
        isLoading = true
    }
    
    private func endLoading(){
        isLoading = false
    }
    
    // MARK: - Get All Food Names
    func getAllListFoodName() {
        startLoading()
        FoodSellService.shared.fetchAllFoodName { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.allFoodName = payload.foodNames
                        self?.successMessage = "Food Name fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to get food list: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
}

