//
//  ViewAllPopularDishesView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct ViewAllPopularDishesView: View {
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    let images = ["slide1", "slide2", "slide3"]
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View{
        GeometryReader{ geometry in
            VStack(spacing: 10) {
                //Slider
                Spacer().frame(height: 15)
                VStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        ZStack{
                            TabView(selection: $currentPage) {
                                ForEach(0..<images.count, id: \.self) { index in
                                    Image(images[index])
                                        .resizable()
                                        .scaledToFill()
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .cornerRadius(12)
                            .onReceive(timer) { _ in
                                withAnimation {
                                    currentPage = (currentPage + 1) % images.count
                                }
                            }
                            // Custom pagination dots
                            HStack(spacing: 5) {
                                ForEach(0..<images.count, id: \.self) { index in
                                    if index == currentPage {
                                        // Active dot (oval and yellow)
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.yellow)
                                            .frame(width: 20, height: 10) // Oval shape
                                    } else {
                                        // Inactive dot (circular)
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 10, height: 10)
                                    }
                                }
                            }
                            .padding(.top,80)
                        }
                    }
                    .padding(.horizontal)
                }
                
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
                                    ? CGFloat(selectedSegment) * geometry.size.width / 4.5
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
        .navigationBarBackButtonHidden(true)
        .navigationTitle(LocalizedStringKey("Popular Dishes"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                    Spacer()
                }
            }
        }
        
    }
}

//#Preview {
//    ViewAllPopularDishesView(isTabBarHidden: .constant(false))
//}

