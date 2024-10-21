//
//  ViewAllPopularDishesView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct ViewAllPopularDishesView: View {
    @State private var selectedSegment = 0
    @Binding var isTabBarHidden: Bool
    
    @State private var currentPage = 0
    let images = ["slide1", "slide2", "slide3"]
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            GeometryReader{ geometry in 
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
                    Spacer().frame(height: 10)
                    
                    //Slider
                    VStack(alignment:.leading){
                        TabView(selection: $currentPage) {
                            ForEach(0..<images.count, id: \.self) { index in
                                Image(images[index])
                                    .resizable()
                                    .scaledToFill()
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(maxWidth: .infinity, maxHeight:130) // Dynamically set height
                        .cornerRadius(12)
                        .onReceive(timer) { _ in
                            withAnimation {
                                currentPage = (currentPage + 1) % images.count
                            }
                        }}
                    
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
                        .padding(.top)
                        // Geometry Reader for Dynamic Line Under the Selected Tab
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
                        .frame(height: 15)
                        
                    }
                    .padding(.top, 5)

                    
                    
                    
                    // Content for Each Tab
                    TabView(selection: $selectedSegment) {
                        AllPopularTabView(isselected: selectedSegment)
                            .tag(0)
                        SaleTab(isselected: selectedSegment)
                            .tag(1)
                        RecipeTab(isselected: selectedSegment)
                            .tag(2)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
            }
        }
    }
}

//#Preview {
//    ViewAllPopularDishesView(isTabBarHidden: .constant(false))
//}

