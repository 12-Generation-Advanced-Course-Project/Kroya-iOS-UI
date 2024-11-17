import SwiftUI

struct FoodonRecipe: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var recipeViewModel = RecipeViewModel()
    @State private var selectedOrderIndex: Int? = nil
    @State private var searchText = ""
    @State private var isChooseCuisine = false
    
    // Static image mapping for cuisines
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
                                recipeViewModel.getAllRecipeFood()
                                isChooseCuisine = false
                                selectedOrderIndex = nil
                            } else {
                                selectedOrderIndex = cuisine.id
                                recipeViewModel.getRecipesByCuisine(cuisineId: cuisine.id)
                                isChooseCuisine = true
                            }
                        }) {
                            VStack {
                                let imageName = cuisineImages[cuisine.cuisineName] ?? "DefaultCuisineImage"
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(12)
                                
                                Text(cuisine.cuisineName)
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(selectedOrderIndex == cuisine.id && isChooseCuisine ? Color.yellow : Color.gray)
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
                
                // Content Display: Loading, Error, or Recipes
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
                    ScrollView {
                        LazyVStack {
                            ForEach(isChooseCuisine ? recipeViewModel.RecipeByCategory : recipeViewModel.RecipeFood) { recipe in
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    showPrice: false, // Always false for recipes
                                                    showOrderButton: false, // Always false for recipes
                                                    showButtonInvoic: nil, // Not applicable
                                                    invoiceAccept: nil, // Not applicable
                                                    FoodId: recipe.id,
                                                    ItemType: recipe.itemType
                                                )
                                ) {
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
           
        }
        .onAppear {
            recipeViewModel.getAllCuisines()
            recipeViewModel.getAllRecipeFood()
        }
        .searchable(text: $searchText, prompt: LocalizedStringKey("Search Item"))
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                recipeViewModel.getSearchFoodRecipeByName(searchText: newValue)
            } else {
                recipeViewModel.getAllRecipeFood()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
