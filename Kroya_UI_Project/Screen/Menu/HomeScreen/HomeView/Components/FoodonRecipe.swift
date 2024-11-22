
import SwiftUI

struct FoodonRecipe: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var recipeViewModel = RecipeViewModel()
    @State private var selectedOrderIndex: Int? = nil
    let cuisineImages: [String: String] = [
        "Soup": "SoupPic",
        "Salad": "SaladPic",
        "Grill": "GrillPic",
        "Dessert": "DessertPic 1"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Cuisine Selection Buttons
                HStack(spacing: 40) {
                    ForEach(recipeViewModel.RecipeCuisine) { cuisine in
                        Button(action: {
                            if selectedOrderIndex == cuisine.id {
                                recipeViewModel.getAllRecipeFood() // Reset to all recipes
                                recipeViewModel.isChooseCuisine = false
                                selectedOrderIndex = nil
                            } else {
                                selectedOrderIndex = cuisine.id
                                recipeViewModel.getRecipesByCuisine(cuisineId: cuisine.id)
                                recipeViewModel.isChooseCuisine = true
                            }
                        }) {
                            VStack {
                                let imageName = cuisineImages[cuisine.cuisineName] ?? "snackPic"
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(12)
                                
                                Text(cuisine.cuisineName)
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(selectedOrderIndex == cuisine.id && recipeViewModel.isChooseCuisine ? Color.yellow : Color.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer().frame(height: 20)
                
                Text("All")
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.horizontal)
                
                if recipeViewModel.isLoading {
                    ZStack {
                        Color.white
                            .edgesIgnoringSafeArea(.all)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                            .scaleEffect(2)
                            .offset(y: -50)
                    }
                } else {
                    if recipeViewModel.filteredFoodRecipeList.isEmpty {
                        Text("No Food Recipe Available!")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(recipeViewModel.filteredFoodRecipeList) { recipe in
                                    NavigationLink(destination:
                                                    FoodDetailView(
                                                        isFavorite: recipe.isFavorite,
                                                        showPrice: false,
                                                        showOrderButton: false,
                                                        showButtonInvoic: nil,
                                                        invoiceAccept: nil,
                                                        FoodId: recipe.id,
                                                        ItemType: recipe.itemType
                                                    )
                                    ) {
                                        RecipeViewCell(
                                            recipe: recipe,
                                            foodId: recipe.id,
                                            itemType: "FOOD_RECIPE",
                                            isFavorite: recipe.isFavorite
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 20)
                                    }
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
        }
        .onAppear {
            recipeViewModel.getAllCuisines()
            recipeViewModel.getAllRecipeFood()
        }
        
        .searchable(text: $recipeViewModel.searchText, prompt: LocalizedStringKey("Search Item"))
        .navigationBarBackButtonHidden(true)
    }
}
