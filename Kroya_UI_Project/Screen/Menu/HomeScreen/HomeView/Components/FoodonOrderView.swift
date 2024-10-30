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
                //Not work well
                // Search Bar
                //                NavigationLink(destination: SearchScreen()) {
                //                    HStack {
                //                        Image("ico_search1")
                //                            .resizable()
                //                            .scaledToFit()
                //                            .frame(width: 24, height: 24)
                //
                //                        Text("Search item")
                //                            .font(.customfont(.medium, fontSize: 16))
                //                            .foregroundColor(.gray)
                //                            .frame(width: .screenWidth * 0.26)
                //                            .padding(.trailing, 12)
                //
                //                        Spacer()
                //                    }
                //                    .padding(.leading, 12)
                //                    .frame(width: .screenWidth * 0.93, height: .screenHeight * 0.05)
                //                    .background(Color(hex: "#F3F2F3"))
                //                    .cornerRadius(12)
                //                }
                
                // Loop through images and titles
                HStack(spacing: 20) {
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                Spacer().frame(height: 20)
                Text("All")
                    .font(.customfont(.bold, fontSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.horizontal)
                
                FoodOnSaleView()
                
                Spacer()
            }
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
                ToolbarItem(placement: .principal) { // Center the title
                    Text(LocalizedStringKey("Food order"))
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundStyle(.black.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .center) // Center alignment
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
