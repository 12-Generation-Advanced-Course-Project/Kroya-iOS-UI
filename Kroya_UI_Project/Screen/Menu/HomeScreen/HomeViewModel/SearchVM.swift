////
////  SearchVM.swift
////  Kroya_UI_Project
////
////  Created by Macbook on 11/19/24.
////
//
//
//import SwiftUI
//import Foundation
//
//class SearchVM: ObservableObject {
//    @Published var listFoodRecipe: [FoodRecipeModel] = []
//    @Published var listFoodSale: [FoodSellModel] = []
//    @Published var foodList : [FoodListPayload] = []
//    @Published var searchFoodName: [SearchModel] = []
//    
//    @Published var isLoading: Bool = false
//    @Published var successMessage: String = ""
//    @Published var showError: Bool = false
//    @Published var errorMessage: String = ""
//    
//
//    //MARK: Computed property to get all post food names
////    var foodListNames: [String] {
////        let recipeNames = listFoodRecipe.map { $0.name }
////        let sellNames = listFoodSale.map { $0.name }
////        return recipeNames + sellNames
////    }
//    // MARK: Helper functions for loading state
//    private func startLoading() {
//        isLoading = true
//    }
//    
//    private func endLoading() {
//        isLoading = false
//    }
//    
//    func getAllListFood() {
//        startLoading()
//        Foods_Service.shared.fetchAllListFood { [weak self] result in
//            DispatchQueue.main.async {
//                self?.endLoading()
//                switch result {
//                case .success(let response):
//                    if response.statusCode == "200", let payload = response.payload {
//                        self?.listFoodSale = payload.foodSells
//                        self?.listFoodRecipe = payload.foodRecipes
//                        self?.successMessage = " Food list fetched successfully."
//                        self?.showError = false
//                    } else {
//                        self?.showError = true
//                        self?.errorMessage = response.message
//                    }
//                case .failure(let error):
//                    self?.showError = true
//                    self?.errorMessage = "Failed to get food list\(error.localizedDescription)"
//                    print("Error: \(error)")
//                }
//            }
//        }
//    }
//    
//    // MARK: Search Food Recipe by Name
//    func getSearchFoodByName(searchText: String) {
//        startLoading()
//        Foods_Service.shared.getSearchFoodByName(searchText: searchText) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.endLoading()
//                switch result {
//                case .success(let response):
//                    if response.statusCode == "200", let payload = response.payload {
//                        self?.getSearchFoodByName(searchText: searchText)
//                    } else {
//                        self?.showError = true
//                        self?.errorMessage = response.message
//                    }
//                case .failure(let error):
//                    self?.showError = true
//                    self?.errorMessage = "Failed to load recipes: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//
// 
//}
//
