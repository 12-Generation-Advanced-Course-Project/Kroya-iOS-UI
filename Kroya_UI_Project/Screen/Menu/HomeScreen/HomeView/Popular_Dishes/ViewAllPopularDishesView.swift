//
//  ViewAllPopularDishesView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct ViewAllPopularDishesView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    @State private var isExpanded = false
    @Binding var isTabBarHidden: Bool
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Orders Text Header
                HStack {
                    Text("Popular Dishes")
                        .font(.customfont(.bold, fontSize: 18))
                        .opacity(0.84)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 16)
                
              Spacer()
                    .frame(height: 10)
              
                Slide().padding(.horizontal, 15)
                
                // Tab View
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(["All", "Sale", "Recipe"], id: \.self) { title in
                            Text(title)
                                .onTapGesture {
                                    selectedSegment = ["All", "Sale", "Recipe"].firstIndex(of: title) ?? 0
                                }
                                .fontWeight(.semibold)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(selectedSegment == (["All", "Sale", "Recipe"].firstIndex(of: title) ?? 0) ? .black.opacity(0.8) : .black.opacity(0.5))
                                .padding(.horizontal, 19)
                        }
                        Spacer()
                    }
//
//                    // Geometry Reader for Dynamic Line Under the Selected Tab
                    GeometryReader { geometry in
                       
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: geometry.size.width / 7, height: 2)
                            .offset(x: selectedSegment == 2
                                    ? CGFloat(selectedSegment) * geometry.size.width / 4.7
                                    : CGFloat(selectedSegment) * geometry.size.width / 5)
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2)
                    
                }
                .padding(.top, 5)
//               //
//                // Content for Each Tab
                TabView(selection: $selectedSegment) {
                    AllTabView(iselected: selectedSegment)
                        .tag(0)
                    OrderTabview(iselected: selectedSegment)
                        .tag(1)
                    SaleTabView(iselected: selectedSegment)
                        .tag(2)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
            }
        }
    }
}

#Preview {
    ViewAllPopularDishesView(isTabBarHidden: .constant(false))
}

