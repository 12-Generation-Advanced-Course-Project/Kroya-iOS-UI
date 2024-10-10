//
//  FavoriteView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 30/9/24.
//

import SwiftUI
import Combine

struct FavoriteView: View {
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @Binding var isTabBarHidden: Bool // Add this binding
    @Environment(\.dismiss) var dismiss
  
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    Text("Favorites")
                        .font(.customfont(.bold, fontSize: 18))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 16)
                Spacer().frame(height: 10)
                
                NavigationLink(destination: SearchScreen()
                    .onAppear {
                        isTabBarHidden = true // Hide the tab bar
                        UITabBar.appearance().isHidden = true
                    }
                    .onDisappear {
                        isTabBarHidden = false
                    }
                    .toolbar(.hidden, for: .tabBar)
                   
                   
                ) {
                    HStack {
                        Image("ico_search1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("Search item")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundColor(.gray)
                            .frame(width: .screenWidth * 0.26)
                            .padding(.trailing, 12)
                        
                        Spacer()
                    }
                    .padding(.leading, 12)
                    .frame(width: .screenWidth * 0.93, height: .screenHeight * 0.05)
                    .background(Color(hex: "#F3F2F3"))
                    .cornerRadius(12)
                }.onAppear{
                    print("search")
                }
                
                // Tab View
                VStack {
                    HStack {
                        Text("Food on Sale")
                            .onTapGesture { selectedSegment = 0 }
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        
                        Text("Recipes")
                            .onTapGesture { selectedSegment = 1 }
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                    }
                    .padding(.top)
                    
                    GeometryReader { geometry in
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: geometry.size.width / 4, height: 2)
                            .padding(.horizontal, 50)
                            .offset(x: CGFloat(selectedSegment) * geometry.size.width / 2)
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2)
                }
                .padding(.top, 5)
                
                TabView(selection: $selectedSegment) {
                    FoodSaleView(iselected: selectedSegment)
                        .tag(0)
                    RecipeView(iselected: selectedSegment)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }.onAppear {
                isTabBarHidden = false // Show the tab bar when this view appears
            }
        }
        
    }
}

#Preview {
    FavoriteView(isTabBarHidden: .constant(false)) // For preview
}
