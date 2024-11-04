

import SwiftUI

struct FavoriteViewCart: View {
    
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var foodOnSaleViewModel = FoodOnSaleViewCellViewModel()
    @StateObject private var addNewFoodVM = AddNewFoodVM()
    
    var body: some View {
        VStack {
            // Single Tab Header
            VStack {
                HStack {
                    Spacer()
                    
                    Text(LocalizedStringKey("Food on Sale"))
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 0
                        }
                    
                    Spacer()
                    Spacer()
                    
                    Text(LocalizedStringKey("Recipes"))
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 1
                        }
                    
                    Spacer()
                }
                .padding(.top)
                
                // Underline animation for selected segment
                GeometryReader { geometry in
                    Divider()
             
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width / 2, height: 2)
                        .offset(x: selectedSegment == 1 ? geometry.size.width / 2 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                }
                .frame(height: 2)
            }
            .padding(.top, 5)
            
            // TabView Content without duplicated headers
            TabView(selection: $selectedSegment) {
                ScrollView(showsIndicators: false) {
                    ForEach(addNewFoodVM.allNewFoodAndRecipes) { foodSale in
                        FoodOnSaleViewCell(foodSale: foodSale, isFavorite: true)
                            .padding(.bottom, 8) // Adjust padding as needed
                            .padding(.top, 10)
                            .padding(.horizontal)
                    }
                }
                .tag(0)
                
                ScrollView(showsIndicators: false) {
                    ForEach(addNewFoodVM.allNewFoodAndRecipes) { recipe in
                        RecipeViewCell(recipe: recipe, isFavorite: true)
                            .padding(.bottom, 8) // Adjust padding as needed
                            .padding(.top, 10)
                            .padding(.horizontal)
                    }
                }
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    
                    Text("Favorite")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.black.opacity(0.8))
                }
            }
        }
        .environmentObject(foodOnSaleViewModel)
        .environmentObject(addNewFoodVM)
    }
}

#Preview {
    FavoriteViewCart()
        .environmentObject(FoodOnSaleViewCellViewModel())
        .environmentObject(AddNewFoodVM())
}
