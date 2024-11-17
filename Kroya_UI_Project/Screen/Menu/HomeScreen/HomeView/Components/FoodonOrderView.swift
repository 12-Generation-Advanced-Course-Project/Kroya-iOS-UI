//
//  FoodonOrder.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 14/10/24.
//
import SwiftUI

struct FoodonOrderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var foodViewModel = FoodSellViewModel()
    let imageofOrder: [String] = ["SoupPic", "SaladPic", "GrillPic", "DessertPic 1"]
    let titleofOrder: [String] = ["Soup", "Salad", "Grill", "Dessert"]
    
    @State private var selectedOrderIndex: Int? = nil
    @State private var searchText = ""
    @State private var doubleSelectedOrderIndex: Int? = nil
    @State var isChooseCuisine = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Cuisine Category Buttons
                HStack(spacing: 40) {
                    ForEach(0..<imageofOrder.count, id: \.self) { index in
                        Button(action: {
                            if selectedOrderIndex == index {
                                foodViewModel.getAllFoodSell()
                                isChooseCuisine = false
                            } else {
                                selectedOrderIndex = index
                                doubleSelectedOrderIndex = index
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
                
                Spacer().frame(height: 20)
                
                Text("All")
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.horizontal)
                
                // Loading Indicator or Content
                if foodViewModel.isLoading {
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
                            ForEach(isChooseCuisine ? foodViewModel.FoodSellByCategory : foodViewModel.FoodOnSale) { foodSale in
                                NavigationLink(destination:
                                                FoodDetailView(
                                                    showPrice: true, // Always false for recipes
                                                    showOrderButton: true, // Always false for recipes
                                                    showButtonInvoic: nil, // Not applicable
                                                    invoiceAccept: nil, // Not applicable
                                                    FoodId: foodSale.id ?? 0,
                                                    ItemType: foodSale.itemType
                                                )
                                ) {
                                    FoodOnSaleViewCell(foodSale: foodSale)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Food Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: LocalizedStringKey("Search Item"))
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                foodViewModel.getSearchFoodFoodByName(searchText: newValue)
            } else {
                foodViewModel.getAllFoodSell()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            foodViewModel.getAllFoodSell()
        }
    }
}
