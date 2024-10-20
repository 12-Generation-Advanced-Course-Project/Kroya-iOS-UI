//
//  OrderListView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/19/24.
//

import SwiftUI

struct OrderListView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss

    // Tab Titles
    let tabTitles = ["New", "Old"]

    var body: some View {
    
            VStack(spacing: 0) {
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
                    
                    Button(action : {})
                    {
                        Image("ico_note")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                            .overlay(
                                Circle()
                                    .fill(Color.red)
                                    .scaledToFit()
                                    .frame(width: 16)
                                    .padding([.bottom, .leading], 12)
                                    .overlay(
                                        Text("8")
                                            .font(.customfont(.semibold, fontSize: 10))
                                            .foregroundColor(.white)
                                            .padding([.bottom, .leading], 12)
                                    )
                            )
                        
                    }
                    Spacer()
                        .frame(width: 2)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                Spacer().frame(height: 10)

        

                // Tab View
                VStack(alignment: .leading) {
                    // HStack for Tab Titles
                    HStack {
                        ForEach(tabTitles, id: \.self) { title in
                            Text(title)
                                .onTapGesture {
                                    selectedSegment = tabTitles.firstIndex(of: title) ?? 0
                                }
                                .fontWeight(.semibold)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(selectedSegment == (tabTitles.firstIndex(of: title) ?? 0) ? .black.opacity(0.8) : .black.opacity(0.5))
                                .padding(.trailing, 20) // Adjust spacing between titles
                        }
                    }
                    .padding(.horizontal, 20) // Aligns the text with the screen edge
                    .padding(.top)

                    // GeometryReader for underline
                    GeometryReader { geometry in
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: underlineWidth(for: selectedSegment, in: geometry), height: 2)
                            .offset(x: underlineOffset(for: selectedSegment, in: geometry))
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2) // Divider height
                }
                .padding(.top, 15)

                // TabView for Content
                TabView(selection: $selectedSegment) {
                    NewItemFoodOrderCardView(iselected: selectedSegment)
                        .tag(0)
                    OldItemFoodOrderCardView(iselected: selectedSegment)
                        .tag(1)

                }.padding(.top, 20)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }.navigationBarBackButtonHidden(true)
        
    }

    // Calculate the underline width dynamically based on the text width
    private func underlineWidth(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let title = tabTitles[selectedSegment]
        let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font: font]).width
        
        // Adjust width if needed
        return titleWidth + 7 // Add padding to the width
    }

    // Calculate the underline offset based on the width of preceding tabs
    private func underlineOffset(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        var offset: CGFloat = 13 // Starting padding

        for index in 0..<selectedSegment {
            let titleWidth = tabTitles[index].size(withAttributes: [NSAttributedString.Key.font: font]).width
            offset += titleWidth + 20 // Add text width + spacing between titles
        }

        return offset
    }
}

#Preview {
    OrderListView()
}
