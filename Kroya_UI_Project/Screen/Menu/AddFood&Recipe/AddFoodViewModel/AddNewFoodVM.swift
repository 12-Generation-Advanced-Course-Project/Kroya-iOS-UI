//
//  AddNewFoodVM.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 31/10/24.
//

import SwiftUI

class AddNewFoodVM: ObservableObject {
    @Published var foodItems: [AddNewFoodModel] = []
    @Published var addNewFood: AddNewFoodModel
    private let service: AddNewFoodServiceProtocol
    @ObservedObject var userStore: UserStore

    // Initialize with default values and injected service
    init(service: AddNewFoodServiceProtocol = AddNewFoodPostService.shared,userStore: UserStore) {
        self.service = service
        self.userStore = userStore
        self.addNewFood = AddNewFoodModel(
            photos: [],
            name: "",
            description: "",
            durationInMinutes: 0,
            level: "",
            cuisineId: 0,
            categoryId: 0,
            ingredients: [],
            cookingSteps: []
        )
    }
    
    // MARK: - Fetch Food Items
    func fetchFoodItems() {
        service.fetchFoodItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let foodItems):
                    self?.foodItems = foodItems
                case .failure(let error):
                    print("Failed to fetch food items: \(error)")
                }
            }
        }
    }
    
    // MARK: - Create New Food Item
    func createFoodItem() {
        service.createFoodItem(addNewFood) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newFood):
                    self?.foodItems.append(newFood)
                    self?.resetAddNewFood()
                case .failure(let error):
                    print("Failed to create food item: \(error)")
                }
            }
        }
    }
    
    // MARK: - Update Existing Food Item
    func updateFoodItem(at index: Int, with updatedFood: AddNewFoodModel) {
        guard index >= 0 && index < foodItems.count else { return }
        
        service.updateFoodItem(updatedFood) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedFoodItem):
                    self?.foodItems[index] = updatedFoodItem
                case .failure(let error):
                    print("Failed to update food item: \(error)")
                }
            }
        }
    }
    
    // MARK: - Delete Food Item
    func deleteFoodItem(at index: Int) {
        guard index >= 0 && index < foodItems.count else { return }
        
        let foodItemId = foodItems[index].cuisineId
        
        service.deleteFoodItem(foodItemId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.foodItems.remove(at: index)
                case .failure(let error):
                    print("Failed to delete food item: \(error)")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func resetAddNewFood() {
        addNewFood = AddNewFoodModel(
            photos: [],
            name: "",
            description: "",
            durationInMinutes: 0,
            level: "",
            cuisineId: 0,
            categoryId: 0,
            ingredients: [],
            cookingSteps: []
        )
    }
}
