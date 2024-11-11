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
    @State private var doubleSelectedOrderIndex:Int? = nil
    @State var isChooseCusine = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Category Selection Buttons
                HStack(spacing: 40) {
                    ForEach(0..<imageofOrder.count, id: \.self) { index in
                        Button(action: {
                            if selectedOrderIndex == index {
                                foodViewModel.getAllFoodSell()
                                isChooseCusine = false
                              
                            } else{
                                selectedOrderIndex = index
                                doubleSelectedOrderIndex = index
                                foodViewModel.getFoodByCuisine(cuisineId: index + 1)
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
                
                Spacer().frame(height: 20)
                
                Text("All")
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.horizontal)
                // Show Loading Indicator if data is being loaded
                if foodViewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    // Display either filtered or all food items
                    ScrollView {
                        LazyVStack {
                            ForEach(isChooseCusine ? foodViewModel.FoodSellByCategory : foodViewModel.FoodOnSale){ food in
                                FoodOnSaleViewCell(foodSale: food)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle(LocalizedStringKey("Food order"))
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
        .searchable(text: $searchText, prompt: LocalizedStringKey("Search Item"))
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                foodViewModel.getSearchFoodFoodByName(searchText: newValue)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            foodViewModel.getAllFoodSell()
        }
    }
}


//
//#Preview {
//    FoodonOrderView()
//}
