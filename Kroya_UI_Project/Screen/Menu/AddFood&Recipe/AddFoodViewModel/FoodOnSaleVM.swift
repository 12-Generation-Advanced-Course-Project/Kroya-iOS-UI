import SwiftUI
import Foundation

class FoodSellViewModel: ObservableObject {
    
    @Published var FoodOnSale: [FoodSellModel] = []
    @Published var FoodSellByCategory: [FoodSellModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var searchText: String = ""
    // MARK: - Helper Methods for Loading State
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }
    var filteredFoodList: [FoodSellModel] {
         // let foodList = isChooseCuisine ? FoodSellByCategory : FoodOnSale
          if searchText.isEmpty {
              return FoodOnSale
          } else {
              return FoodOnSale.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
          }
      }
    // MARK: Fetch User CardSell
    func getAllFoodSell() {
        startLoading()
        FoodSellService.shared.fetchAllCardFood { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.FoodOnSale = payload
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
    
    // MARK: Post New Food Sell
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
                        self?.getAllFoodSell()
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to post food sell: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: Get all Food By Category
    func getFoodByCuisine(cuisineId: Int) {
        startLoading()
        FoodSellService.shared.getAllFoodSellByCategory(category: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
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
    
    // MARK: Get Search Food Recipe By Name
    func getSearchFoodFoodByName(searchText: String) {
        startLoading()
        FoodSellService.shared.getSearchFoodSellByName(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
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
                    self?.errorMessage = "Failed to load food: \(error.localizedDescription)"
                }
            }
        }
    }
}
