//
//  DinnerScreenView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 14/10/24.
//

import SwiftUI


struct DinnerScreenView: View {
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        VStack {
            // Tab View
            VStack {
                HStack {
                    Spacer()
                    
                    Text(LocalizedStringKey("Food on Sale"))
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 0
                        }
                    
                    Spacer()
              
                    
                    Text(LocalizedStringKey("Recipes"))
                        .fontWeight(.semibold)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 1
                        }
                    
                    Spacer()
                }
                .padding(.top)
                
                // Simple Geometry Reader for Underline
                GeometryReader { geometry in
                    Divider()
                    
                    Rectangle()
                        .fill(Color.yellow) // Use your defined color here
                        .frame(width: geometry.size.width / 2, height: 2) // Two segments
                        .offset(x: selectedSegment == 1 ? geometry.size.width / 2 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                }
                .frame(height: 2)
            }
            .padding(.top, 5)
            
            // Tab View Content
            TabView(selection: $selectedSegment) {
                FoodOnSaleView(iselected: selectedSegment)
                    .tag(0)
                RecipeView(iselected: selectedSegment)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Dinner")
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

#Preview {
    DinnerScreenView()
}
