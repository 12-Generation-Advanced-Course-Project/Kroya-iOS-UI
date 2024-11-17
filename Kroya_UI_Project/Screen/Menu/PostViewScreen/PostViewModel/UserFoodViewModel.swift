//
//  UserFoodViewModel.swift
//  Kroya_UI_Project
//
//  Created by kosign on 8/11/24.
//

import SwiftUI
import Foundation

class UserFoodViewModel: ObservableObject {
    @Published var userPostRecipeFood: [FoodRecipeModel] = []
    @Published var userPostFoodSale: [FoodSellModel] = []
    @Published var userPostFood : [UserFoodModel] = []
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    //MARK: Computed property to get all post food names
    var popularFoodNames: [String] {
        let recipeNames = userPostRecipeFood.map { $0.name }
        let sellNames = userPostFoodSale.map { $0.name }
        return recipeNames + sellNames
    }
    var totalPosts: Int {
           return userPostRecipeFood.count + userPostFoodSale.count
       }
    init() {
           // Fetch data from backend when initialized
           getAllUserFood()
       }
    
    private func startLoading(){
        isLoading = true
    }
    
    private func endLoading(){
        isLoading = false
    }
    
    //MARK: - get All Popular
    
    func getAllUserFood() {
        startLoading()
        UserFoodService.shared.fetchAllUserFood{ [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.userPostFoodSale = payload.foodSells
                        self?.userPostRecipeFood = payload.foodRecipes
                        self?.successMessage = "Post food fetched successfully."
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to get post all food \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
}
