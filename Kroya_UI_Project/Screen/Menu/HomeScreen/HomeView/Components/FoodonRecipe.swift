
import SwiftUI

struct FoodonRecipe: View {
    
    @Environment(\.dismiss) var dismiss

    
    @StateObject private var recipeViewModel = RecipeViewModel()
    let imageofOrder: [String] = ["SoupPic", "SaladPic", "GrillPic", "DessertPic 1"]
    let titleofOrder: [String] = ["Soup", "Salad", "Grill", "Dessert"]
    
    @State private var selectedOrderIndex: Int? = nil
    @State private var searchText = ""
    @State private var doubleSelectedOrderIndex:Int? = nil
    @State var isChooseCusine = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 40) {
                    ForEach(0..<imageofOrder.count, id: \.self) { index in
                        Button(action: {
                            if selectedOrderIndex == index {
                                recipeViewModel.getAllRecipeFood()
                                isChooseCusine = false
                              
                            } else{
                                selectedOrderIndex = index
                                doubleSelectedOrderIndex = index
                                recipeViewModel.getRecipesByCuisine(cuisineId: index + 1)
                                isChooseCusine = true
                            }
                        }) {
                            VStack {
                              
                                Image(imageofOrder[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Text(titleofOrder[index])
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(selectedOrderIndex == index && isChooseCusine ? Color.yellow : Color.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                    .frame(height: 20)
                
                Text("All")
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
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
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(isChooseCusine ? recipeViewModel.RecipeByCategory : recipeViewModel.RecipeFood) { recipe in
                                RecipeViewCell(recipe: recipe)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
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
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .onAppear{
            recipeViewModel.getAllRecipeFood()
        }
        .searchable(text: $searchText, prompt: LocalizedStringKey("Search Item"))
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                recipeViewModel.getSearchFoodRecipeByName(searchText: newValue)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            recipeViewModel.getAllRecipeFood()
        }
    }
}
