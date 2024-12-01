//
//  CategoryFodDetails.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 13/11/24.
//
//

import SwiftUI

struct CategoryFoodDetails: View {
    
    var category: Category
    @StateObject private var categoryVM = CategoryMV()
    @StateObject private var guestCategoryVM = GuestCategoryVM()
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Food on Sale")
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            if Auth.shared.hasAccessToken(){
                                selectedSegment = 0
                                categoryVM.fetchAllCategoryById(categoryId: category.id) // Ensure data is fetched
                            }else{
                                selectedSegment = 0
                                //                                guestCategoryVM.fetchAllfoodByCategoryId(categoryId: category.id) // Ensure data is fetched
                            }
                        }
                    Spacer()
                    Text("Recipes")
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            if Auth.shared.hasAccessToken(){
                                selectedSegment = 1
                                categoryVM.fetchAllCategoryById(categoryId: category.id) // Ensure data is fetched
                            } else {
                                selectedSegment = 1
                                //                                guestCategoryVM.fetchAllfoodByCategoryId(categoryId: category.id) // Ensure data is fetched
                            }
                        }
                    Spacer()
                }
                .padding(.top)
                
                // Underline indicator for selected tab
                GeometryReader { geometry in
                    Divider()
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width / 2, height: 2)
                        .offset(x: selectedSegment == 1 ? geometry.size.width / 2 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                }
                .frame(height: 2)
            }
            .padding(.top, 5)
            
            // Tab View Content
            TabView(selection: $selectedSegment) {
                CategoryFoodSaleTab(categoryVM: categoryVM, guestCategoryVM: guestCategoryVM)
                    .tag(0)
                CategoryFoodRecipeTab(categoryVM: categoryVM, guestCategoryVM: guestCategoryVM)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .onAppear {
            print("Selected Category ID: \(category.id)")
            if Auth.shared.hasAccessToken() {
                categoryVM.fetchAllCategoryById(categoryId: category.id)
                print("Selected Categoryuser ID: \(category.id)")
            } else {
                print("Selected Categoryguest ID: \(category.id)")
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle(category.title.rawValue)
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
}
