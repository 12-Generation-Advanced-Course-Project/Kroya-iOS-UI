//
//  FoodonOrder.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 14/10/24.
//
import SwiftUI

struct FoodonOrderView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let imageofOrder: [String] = ["SoupPic", "SaladPic", "GrillPic", "DessertPic 1"]
    let titleofOrder: [String] = ["Soup", "Salad", "Grill", "Dessert"]
    
    @State private var selectedOrderIndex: Int? = nil // Tracks selected index
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            VStack {
                // Loop through images and titles
                HStack(spacing: 40) {
                    ForEach(0..<imageofOrder.count, id: \.self) { index in
                        Button(action: {
                            selectedOrderIndex = index // Update the selected index
                        }) {
                            VStack {
                                Image(imageofOrder[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Text(titleofOrder[index])
                                    .font(.customfont(.medium, fontSize: 16))
                                    .foregroundColor(selectedOrderIndex == index ? Color.yellow : Color.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                Spacer()
                    .frame(height: 20)
                Text(LocalizedStringKey("All"))
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.horizontal)
                
                FoodOnSaleView()
                
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FoodonOrderView()
}
