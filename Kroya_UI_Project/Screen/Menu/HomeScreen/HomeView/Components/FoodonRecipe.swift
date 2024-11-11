//import SwiftUI
//
//struct FoodonRecipe: View {
//    
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
//    @StateObject private var recipeViewModel = RecipeViewModel()
//    
////    let imageofOrder: [String] = ["soupImage", "saladImage", "grillImage", "dessertImage"]
//    let imageofOrder: [String] = ["SoupPic", "SaladPic", "GrillPic", "DessertPic 1"]
//    let titleofOrder: [String] = ["Soup", "Salad", "Grill", "Dessert"]
//    
//    @State private var selectedOrderIndex: Int? = nil
//    @State private var searchText = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Order Selection Buttons
//                HStack(spacing: 40) {
//                    ForEach(0..<imageofOrder.count, id: \.self) { index in
//                        Button(action: {
//                            selectedOrderIndex = index
//                            recipeViewModel.getRecipesByCuisine(cuisineId: index + 1)
//                        }) {
//                            VStack {
//                                Image(imageofOrder[index])
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 60, height: 60)
//                                
//                                Text(titleofOrder[index])
//                                    .font(.customfont(.medium, fontSize: 16))
//                                    .foregroundColor(selectedOrderIndex == index ? Color.yellow : Color.gray)
//                            }
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
//                .padding()
//                
//                Spacer()
//                    .frame(height: 20)
//                
//                // Conditional Rendering Based on Selected Order Index
//                if selectedOrderIndex == nil {
//                    // Show this when no cuisine is selected
//                    Text("All")
//                        .font(.customfont(.bold, fontSize: 16))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .foregroundColor(.black.opacity(0.8))
//                        .padding(.horizontal)
//                    
//                    // Display RecipeView below the title
//                    RecipeView()
//                        .environmentObject(recipeViewModel) // Pass the environment object if needed
//                } else {
//                    // Show cuisine-specific recipes when a cuisine is selected
//                    if recipeViewModel.isLoading {
//                        ProgressView("Loading...")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                    } else {
//                        ScrollView {
//                            LazyVStack {
//                                ForEach(recipeViewModel.RecipeByCategory) { recipe in
//                                    RecipeViewCell(recipe: recipe)
//                                        .frame(maxWidth: .infinity)
//                                        .padding(.horizontal, 20)
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                Spacer()
//            }
//            .navigationTitle("Food Recipe")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.black)
//                    }
//                }
//            }
//            .onAppear {
//                // Fetch data when the view appears
//                recipeViewModel.getRecipeFood()
//            }
//        }
//        .searchable(text: $searchText, prompt: LocalizedStringKey("Search Item"))
//        .onChange(of: searchText) { newValue in
//            if !newValue.isEmpty {
//                recipeViewModel.getSearchFoodRecipeByName(searchText: newValue)
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}



import SwiftUI

struct FoodonRecipe: View {
    
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    @State private var selectedOrderIndex: Int? = nil
    @State private var searchText = ""
    
    // Static image mapping for cuisines
    let cuisineImages: [String: String] = [
        
        "Soup": "soupImage",
        "Salad": "saladImage",
        "Grill": "grillImage",
        "Dessert": "dessertImage"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Display dynamic cuisines as buttons with static images
                if recipeViewModel.isLoading {
                    ProgressView("Loading cuisines...")
                        .padding()
                } else if !recipeViewModel.RecipeCuisine.isEmpty {
                    HStack(spacing: 40) {
                        ForEach(recipeViewModel.RecipeCuisine) { cuisine in
                            Button(action: {
                                selectedOrderIndex = cuisine.id
                                recipeViewModel.getRecipesByCuisine(cuisineId: cuisine.id)
                            }) {
                                VStack {
                                    // Use static image based on cuisine name or a default image
                                    let imageName = cuisineImages[cuisine.cuisineName] ?? "DefaultCuisineImage"
                                    Image(imageName) // Replace "DefaultCuisineImage" with a generic default image if needed
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(12)
                                    
                                    Text(cuisine.cuisineName)
                                        .font(.customfont(.medium, fontSize: 16))
                                        .foregroundColor(selectedOrderIndex == cuisine.id ? Color.yellow : Color.gray)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                } else if recipeViewModel.showError {
                    Text(recipeViewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                    .frame(height: 20)
                
                // Conditional Rendering Based on Selected Order Index
                if selectedOrderIndex == nil {
                    Text("All")
                        .font(.customfont(.bold, fontSize: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.horizontal)
                    
                    RecipeView()
//                        .environmentObject(recipeViewModel)
                } else {
                    if recipeViewModel.isLoading {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(recipeViewModel.RecipeByCategory) { recipe in
                                    RecipeViewCell(recipe: recipe)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Food Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }
            }
            .onAppear {
                recipeViewModel.getAllCuisines() // Fetch cuisines when view appears
                recipeViewModel.getRecipeFood()
            }
        }
        .searchable(text: $searchText, prompt: LocalizedStringKey("Search Item"))
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                recipeViewModel.getSearchFoodRecipeByName(searchText: newValue)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
