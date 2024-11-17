////
////  AddNewFoodPostService.swift
////  Kroya_UI_Project
////
////  Created by Ounbonaliheng on 1/11/24.
////
//
//
//import SwiftUI
//
//// Define protocol to standardize service methods
//protocol AddNewFoodServiceProtocol {
//    func fetchFoodItems(completion: @escaping (Result<[AddNewFoodModel], Error>) -> Void)
//    func createFoodItem(_ foodItem: AddNewFoodModel, completion: @escaping (Result<AddNewFoodModel, Error>) -> Void)
//    func updateFoodItem(_ foodItem: AddNewFoodModel, completion: @escaping (Result<AddNewFoodModel, Error>) -> Void)
//    func deleteFoodItem(_ id: Int, completion: @escaping (Result<Void, Error>) -> Void)
//}
//
//class AddNewFoodPostService: AddNewFoodServiceProtocol {
//    
//    static let shared = AddNewFoodPostService()
//    
//    private init() {}
//    
//    // MARK: - Fetch Food Items
//    func fetchFoodItems(completion: @escaping (Result<[AddNewFoodModel], Error>) -> Void) {
//        // Replace with API fetch logic
//        let sampleFoodItems = [AddNewFoodModel(
//            photos: [Photo(photo: "sample_photo_url")],
//            name: "Sample Food",
//            description: "A delicious sample recipe",
//            durationInMinutes: 30,
//            level: "Easy",
//            cuisineId: 1,
//            categoryId: 2,
//            ingredients: [RecipeIngredient(id: 1, name: "Salt", quantity: 1.0, price: 0.5, selectedCurrency: 0)],
//            cookingSteps: [CookingStep(id: 1, description: "Add salt to taste.")]
//        )]
//        completion(.success(sampleFoodItems))
//    }
//    
//    // MARK: - Create Food Item
//    func createFoodItem(_ foodItem: AddNewFoodModel, completion: @escaping (Result<AddNewFoodModel, Error>) -> Void) {
//        // Replace with API post logic
//        completion(.success(foodItem))
//    }
//    
//    // MARK: - Update Food Item
//    func updateFoodItem(_ foodItem: AddNewFoodModel, completion: @escaping (Result<AddNewFoodModel, Error>) -> Void) {
//        // Replace with API update logic
//        completion(.success(foodItem))
//    }
//    
//    // MARK: - Delete Food Item
//    func deleteFoodItem(_ id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
//        // Replace with API delete logic
//        completion(.success(()))
//    }
//}
