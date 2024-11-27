//
//  GuestSearchAllFoodVM.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 26/11/24.
//

import Foundation
import SwiftUI

class GuestSearchAllFoodVM: ObservableObject{
    
    @Published var guestSearchFoodRecipe: [FoodRecipeModel] = []
    @Published var guestSearchFoodSell: [FoodSellModel] = []
    @Published var guestSearchAllFood: [FoodListPayload] = []
    @Published var isloading: Bool = false
    
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    //MARK: Computed property to get all popular food names
    var GuestAllfoodListNames: [String] {
        let guestRecipeNames = guestSearchFoodRecipe.map { $0.name }
        let guestSellNames = guestSearchFoodSell.map { $0.name }
        return guestRecipeNames + guestSellNames
    }
    private func startLoading(){
        isloading = true
    }
    
    private func endLoading(){
        isloading = false
    }
    
    
    //MARK: Get guest search all food
    
    func getGuestSearchAllFood(){
        startLoading()
        GuestSearchAllFoodService.shared.fetchGuestSearchAllFood{ [weak self] result in
            DispatchQueue.main.async {
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.guestSearchFoodSell = payload.foodSells
                        self?.guestSearchFoodRecipe = payload.foodRecipes
                        self?.successMessage = "Guest search all food fetched successfully. "
                        self?.showError = false
                    } else {
                        self?.showError = true
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.showError = true
                    self?.errorMessage = "Failed to get all guest food \(error.localizedDescription)"
                    print("Error: \(error)")
                }
            }
        }
    }
    
    //MARK: Get Guest Search Food by Name
    
    func getGuestSearchFoodByName(guestFoodName: String){
        startLoading()
        GuestSearchAllFoodService.shared.fetchGuestSearchFoodByName(searchText: guestFoodName) { [weak self] result in
            
            DispatchQueue.main.async{
                self?.endLoading()
                switch result {
                case .success(let response):
                    if response.statusCode == "200", let payload = response.payload {
                        self?.guestSearchFoodSell = payload.foodSells
                        self?.guestSearchFoodRecipe = payload.foodRecipes
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
