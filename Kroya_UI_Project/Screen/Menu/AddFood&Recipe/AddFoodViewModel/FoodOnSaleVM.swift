import SwiftUI
import Foundation

class FoodSellViewModel: ObservableObject {
    
    @Published var FoodOnSale: [FoodSellModel] = []
    @Published var FoodSellByCategory: [FoodSellModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    // MARK: Fetch User CardSell
    func getAllFoodSell() {
        self.isLoading = true
        FoodSellService.shared.fetchAllCardFood { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200" {
                        if let payload = response.payload {
                            self?.FoodOnSale = payload
                        }
                        self?.successMessage = "FoodCard fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load FoodCard: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    //MARK: Get all Food By Category
    func getFoodByCuisine(cuisineId: Int) {
        self.isLoading = true
        FoodSellService.shared.getAllFoodSellByCategory(category: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.FoodSellByCategory = payload
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load food sell: \(error.localizedDescription)"
                }
            }
        }
    }
    
    //MARK: Get Search Food Recipe By Name
    func getSearchFoodFoodByName(searchText: String) {
        self.isLoading = true
        FoodSellService.shared.getSearchFoodSellByName(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.FoodSellByCategory = payload // Storing search results here
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load food: \(error.localizedDescription)"
                }
            }
        }
    }

}

