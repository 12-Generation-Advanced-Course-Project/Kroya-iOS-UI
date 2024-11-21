//
//  FoodSaleView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 11/20/24.
//


import SwiftUI
import Foundation

class FoodListVM: ObservableObject {
    @Published var listFoodRecipe: [FoodRecipeModel] = []
    @Published var listFoodSell: [FoodSellModel] = []
    @Published var listFood: [FoodListPayload] = []
    @Published var isLoading: Bool = false
    
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    //MARK: Computed property to get all popular food names
    var foodListNames: [String] {
        let recipeNames = listFoodRecipe.map { $0.name }
        let sellNames = listFoodSell.map { $0.name }
        return recipeNames + sellNames
    }
    private func startLoading(){
        isLoading = true
    }
    
    private func endLoading(){
        isLoading = false
    }
    
    //MARK: - get All Popular
    
    func getAllListFood() {
        startLoading()
        Foods_Service.shared.fetchAllListFood{ [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.listFoodSell = payload.foodSells
                        self?.listFoodRecipe = payload.foodRecipes
                        self?.successMessage = "Popular food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to getlist food \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func searchFoodByName(foodName: String) {
        startLoading()
        Foods_Service.shared.fetchFoodByName(searchText: foodName) { [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.listFoodSell = payload.foodSells
                        self?.listFoodRecipe = payload.foodRecipes
                        self?.successMessage = "Food Name fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to get food by name \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    


}
