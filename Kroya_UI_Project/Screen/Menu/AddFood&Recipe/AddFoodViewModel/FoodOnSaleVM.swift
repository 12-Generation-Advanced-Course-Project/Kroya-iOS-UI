import SwiftUI
import Foundation

class FoodSellViewModel: ObservableObject {
    @Published var FoodOnSale: [FoodSellModel] = []
    @Published var FoodSellByCategory: [FoodSellModel] = []
    @Published var FoodSaleCuisine: [CuisinesModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var searchText: String = "" // Search query
    @Published var isChooseCuisine: Bool = false
    // Helper property for filtered food list
    var filteredFoodList: [FoodSellModel] {
        let baseList = isChooseCuisine ?  FoodSellByCategory : FoodOnSale 
        if searchText.isEmpty {
            return baseList
        } else {
            return baseList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    
    // MARK: - Fetch All Food Sells
    func getAllFoodSell() {
        startLoading()
        FoodSellService.shared.fetchAllCardFood { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.FoodOnSale = payload
                        self?.successMessage = "Food list fetched successfully."
                        self?.showError = false
                    } else {
                        self?.handleError(response.message)
                    }
                case .failure(let error):
                    self?.handleError("Failed to fetch food list: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Post New Food Sell
    func createFoodSell(foodSellRequest: FoodSellRequest, foodRecipeId: Int, currencyType: String) {
        startLoading()
        FoodSellService.shared.postFoodSell(foodSellRequest, foodRecipeId: foodRecipeId, currencyType: currencyType) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "201" {
                        self?.successMessage = "Food sell posted successfully."
                        self?.showError = false
                        self?.getAllFoodSell() // Refresh the list
                    } else {
                        self?.handleError(response.message)
                    }
                case .failure(let error):
                    self?.handleError("Failed to post food sell: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Filter Foods by Cuisine
    func getFoodByCuisine(cuisineId: Int) {
        startLoading()
        FoodSellService.shared.getAllFoodSellByCategory(category: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.FoodSellByCategory = payload
                        self?.successMessage = "Filtered by cuisine successfully."
                        self?.isChooseCuisine = true
                        self?.showError = false
                    } else {
                        self?.handleError(response.message)
                    }
                case .failure(let error):
                    self?.handleError("Failed to filter by cuisine: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Search Foods by Name
    func searchFoodByName() {
        if searchText.isEmpty {
            // Reset to original list if search text is cleared
            FoodSellByCategory = []
            return
        }
        
        startLoading()
        FoodSellService.shared.getSearchFoodSellByName(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.FoodSellByCategory = payload
                        self?.successMessage = "Search results fetched successfully."
                        self?.showError = false
                    } else {
                        self?.handleError(response.message)
                    }
                case .failure(let error):
<<<<<<< HEAD
                    self?.handleError("Failed to search foods: \(error.localizedDescription)")
=======
                    self?.showError = true
                    self?.errorMessage = "Failed to load food : \(error.localizedDescription)"
>>>>>>> 06b9ba4 (lastUpdate)
                }
            }
        }
    }
    
    // MARK: - Fetch All Cuisines
    func getAllCuisines() {
        startLoading()
        FoodRecipeService.shared.getAllCuisines { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.FoodSaleCuisine = payload
                        self?.successMessage = "Cuisines fetched successfully."
                        self?.showError = false
                    } else {
                        self?.handleError(response.message)
                    }
                case .failure(let error):
                    self?.handleError("Failed to fetch cuisines: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Handle Errors
    private func handleError(_ message: String) {
        self.showError = true
        self.errorMessage = message
        print("Error: \(message)")
    }
}
