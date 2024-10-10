//
//  AddFoodView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 9/10/24.
//

import SwiftUI

struct AddFoodView:View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ScrollView(.vertical){
                VStack{
                    Spacer().frame(height: 15)
                    Button(action: {
                           }) {
                               VStack {
                                   Image("addphoto")
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 46, height: 46)
                                
                                   Spacer().frame(height: 10)
                                   Text("Add dishes Photo")
                                       .font(.customfont(.bold, fontSize: 15))
                                       .foregroundStyle(.black.opacity(0.5))
                                   Text("(up to 12 Mb)")
                                       .font(.customfont(.medium, fontSize: 12))
                                       .foregroundStyle(.black.opacity(0.5))
                                    
                               }
                               .frame(width: .screenWidth * 0.9, height: .screenHeight * 0.2)
                               .cornerRadius(16)
                               .overlay(
                                   RoundedRectangle(cornerRadius: 16)
                                       .strokeBorder(
                                        Color(hex: "#D0DBEA"),
                                           style: StrokeStyle(
                                               lineWidth: 2,
                                               dash: [10, 5] // Adjust dash lengths as needed
                                           )
                                       )
                               )
                           }
                   
                }.navigationTitle("Your dishes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Toolbar items
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                dismiss()
                            }
                            .padding(.horizontal,8)
                    }
                }
                
            }
        }
    }
}

#Preview {
    AddFoodView()
}
