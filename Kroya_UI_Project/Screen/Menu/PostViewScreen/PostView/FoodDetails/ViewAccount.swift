//
//  ViewAccount.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/21/24.
//

import SwiftUI

struct ViewAccount: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    var profileImage: String
    var userName: String
    var email: String
    @Environment(\.dismiss) var dismiss

    // Tab Titles
    let tabTitles = ["All","Food on sale", "Recipes"]

    var body: some View {
    
            VStack {
                Spacer().frame(height: 10)

                // Orders Text Header
                HStack {
                    Button(action: {
                      dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.black)
                    }
                    Spacer()
                      
                }.padding(.horizontal, 15)
                    .padding(.bottom, 10)
                    
                    // Profile
                        HStack(spacing: 10) {
                            // Profile Image
                            Image(profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 52, height: 52)
                                .clipShape(RoundedCorner(radius: 15))
                              

                            // User Details
                            VStack(alignment: .leading, spacing: 4) {
                                Text(userName)
                                    .font(.customfont(.bold, fontSize: 17))
                                    .foregroundColor(.black)

                                Text(email)
                                    .font(.customfont(.regular, fontSize: 14))
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                       .padding(.horizontal, 15)

        
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

                // TabView for Content
                TabView(selection: $selectedSegment) {
                    AllView(iselected: selectedSegment)
                        .tag(0)
                    FoodOnSale(iselected: selectedSegment)
                        .tag(1)
                    Recipe(iselected: selectedSegment)
                        .tag(2)
                  

                }.padding(.top, 20)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }.navigationBarBackButtonHidden(true)
        
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
    ViewAccount(profileImage: "Songvak", userName: "Kuromi", email: "Kuromi@gmail.com")
}
