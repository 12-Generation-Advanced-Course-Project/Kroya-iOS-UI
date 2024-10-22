//
//  FavoriteView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 30/9/24.
//

import SwiftUI
import Combine

struct PostViewScreen: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss

    // Text titles for each tab
    let tabTitles = ["All", "Food on Sale", "Recipes"]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer().frame(height: 10)
                
                // Tab View
                VStack(alignment: .leading) {
                    // HStack for the Tab Titles
                    HStack {
                        ForEach(tabTitles, id: \.self) { title in
                            Text(title)
                                .onTapGesture {
                                    selectedSegment = tabTitles.firstIndex(of: title) ?? 0
                                }
                                .fontWeight(.semibold)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(selectedSegment == (tabTitles.firstIndex(of: title) ?? 0) ? .black.opacity(0.8) : .black.opacity(0.5))
                                .padding(.trailing, 10) // Spacing between titles
                        }
                    }
                    .padding(.horizontal, 15) // Leading padding to align the text with screen's edge
                    .padding(.top)

                    // Geometry Reader for Underline
                    GeometryReader { geometry in
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: underlineWidth(for: selectedSegment, in: geometry), height: 2)
                            .offset(x: underlineOffset(for: selectedSegment, in: geometry))
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2)
                }
                .padding(.top, 5)
                
                // TabView for content
                TabView(selection: $selectedSegment) {
//                    AllPostFoodandRecipe(iselected: selectedSegment)
                    FoodSaleView(iselected: selectedSegment)
                        .tag(0)
                    FoodSaleView(iselected: selectedSegment)
                        .tag(1)
                    RecipeView(iselected: selectedSegment)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("Men")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("Oun Bonaliheng")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(.black)
                            Spacer().frame(height: 5)
                            Text("Since Oct, 2024")
                                .font(.customfont(.light, fontSize: 12))
                                .foregroundStyle(.black)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { }) {
                        VStack {
                            Text("4")
                                .font(.customfont(.semibold, fontSize: 14))
                                .foregroundStyle(PrimaryColor.normal)
                            Text("Post")
                                .font(.customfont(.medium, fontSize: 14))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
    }

    // Calculate the underline width dynamically based on the text width
    private func underlineWidth(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let title = tabTitles[selectedSegment]
        let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font: font]).width
        
        // Add or subtract a fixed value from the calculated width
        let widthAdjustment: CGFloat = 10 // Adjust this value to add/subtract pixels from the underline width
        return titleWidth + widthAdjustment
    }



    // Calculate the underline offset based on the cumulative width of the previous text items
    private func underlineOffset(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        // Calculate the width of the preceding tabs
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        var offset: CGFloat = 10 // Starting padding from the leading edge

        for index in 0..<selectedSegment {
            let titleWidth = tabTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
            offset += titleWidth + 20 // Add the width of the text and the trailing padding between titles
        }

        return offset
    }
}

#Preview {
    PostViewScreen() // For preview
}
