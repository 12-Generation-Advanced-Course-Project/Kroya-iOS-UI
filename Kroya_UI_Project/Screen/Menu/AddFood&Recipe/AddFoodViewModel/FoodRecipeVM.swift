
import SwiftUI
import Foundation

class RecipeViewModel: ObservableObject {
    
    @Published var RecipeFood: [FoodRecipeModel] = []
    @Published var RecipeByCategory: [FoodRecipeModel] = []
    @Published var RecipeCuisine: [CuisinesModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var searchText: String = ""
    @Published var isChooseCuisine: Bool = false
    
    var filteredFoodRecipeList: [FoodRecipeModel] {
        let baseList = isChooseCuisine ? RecipeByCategory : RecipeFood
        if searchText.isEmpty {
            return baseList
        } else {
            return baseList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // MARK: Helper functions for loading state
    private func startLoading() {
        isLoading = true
    }
    
    private func endLoading() {
        isLoading = false
    }

    // MARK: Get All Recipe Food
    func getAllRecipeFood() {
        startLoading()
        FoodRecipeService.shared.getFoodRecipe { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.RecipeFood = payload
                        self?.successMessage = "Recipe food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load recipes: \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }

    // MARK: Get Recipes by Cuisine
    func getRecipesByCuisine(cuisineId: Int) {
        startLoading()
        FoodRecipeService.shared.getAllFoodRecipeByCategory(category: cuisineId) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.RecipeByCategory = payload
                        self?.isChooseCuisine = true
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load recipes by cuisine: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: Get All Cuisines
    func getAllCuisines() {
        self.isLoading = true
        FoodRecipeService.shared.getAllCuisines { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.RecipeCuisine = payload
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to load cuisines: \(error.localizedDescription)"
                }
            }
        }
    }
}

