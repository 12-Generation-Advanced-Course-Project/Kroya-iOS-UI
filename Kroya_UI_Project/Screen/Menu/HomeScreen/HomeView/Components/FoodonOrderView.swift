import SwiftUI

struct FoodonOrderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var foodViewModel = FoodSellViewModel()
    let imageofOrder: [String] = ["SoupPic", "SaladPic", "GrillPic", "DessertPic 1"]
    let titleofOrder: [String] = ["Soup", "Salad", "Grill", "Dessert"]
    @State private var selectedOrderIndex: Int? = nil
    @State var isChooseCuisine = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Cuisine Category Buttons
                CuisineCategoryButtons(imageofOrder: imageofOrder, titleofOrder: titleofOrder, selectedOrderIndex: $selectedOrderIndex, isChooseCuisine: $isChooseCuisine, foodViewModel: foodViewModel)

                Spacer().frame(height: 20)
                
                Text("All")
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.horizontal)
                
                // Loading Indicator or Content
                if foodViewModel.isLoading {
                    LoadingView()
                } else {
                    FoodListView(isChooseCuisine: isChooseCuisine, foodViewModel: foodViewModel)
                }
            }
            .navigationTitle("Food Order")
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
        .searchable(text: $foodViewModel.searchText, prompt: LocalizedStringKey("Search Item")) // Bind to searchText
    
        .onAppear {
            foodViewModel.getAllFoodSell()
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Separate view for Cuisine Category Buttons
struct CuisineCategoryButtons: View {
    let imageofOrder: [String]
    let titleofOrder: [String]
    @Binding var selectedOrderIndex: Int?
    @Binding var isChooseCuisine: Bool
    @ObservedObject var foodViewModel: FoodSellViewModel
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(0..<imageofOrder.count, id: \.self) { index in
                Button(action: {
                    if selectedOrderIndex == index {
                        foodViewModel.getAllFoodSell()
                        isChooseCuisine = false
                    } else {
                        selectedOrderIndex = index
                        foodViewModel.getFoodByCuisine(cuisineId: index + 1)
                        isChooseCuisine = true
                    }
                }) {
                    VStack {
                        Image(imageofOrder[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                        
                        Text(titleofOrder[index])
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(selectedOrderIndex == index && isChooseCuisine ? Color.yellow : Color.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// Separate view for the loading state
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                .scaleEffect(2)
                .offset(y: -50)
        }
    }
}

// Separate view for the Food List
struct FoodListView: View {
    let isChooseCuisine: Bool
    @ObservedObject var foodViewModel: FoodSellViewModel
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(isChooseCuisine ? foodViewModel.FoodSellByCategory : foodViewModel.filteredFoodList) { foodSale in
                    NavigationLink(destination: FoodDetailView(
                        isFavorite: foodSale.isFavorite ?? false,
                        showPrice: true,
                        showOrderButton: true,
                        showButtonInvoic: nil,
                        invoiceAccept: nil,
                        FoodId: foodSale.id,
                        ItemType: foodSale.itemType
                    )) {
                        FoodOnSaleViewCell(
                            foodSale: foodSale,
                            foodId: foodSale.id,
                            itemType: "FOOD_SELL",
                            isFavorite: foodSale.isFavorite ?? false
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}
