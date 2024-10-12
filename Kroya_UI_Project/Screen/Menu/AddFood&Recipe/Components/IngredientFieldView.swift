//
//  IngredientFieldView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 11/10/24.
//

import SwiftUI

struct Ingredient: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantity: String
    var price: String
    var selectedCurrency: Int
    
}

struct IngredientEntryView: View {
    @Binding var ingredient: Ingredient
    
    let currencies = ["៛", "$"]
    
    var body: some View {
        VStack(spacing: 10) {
            // Ingredient TextField
            HStack {
                Image("ico_move")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField("Enter ingredients", text: $ingredient.name)
                    .padding(.vertical, 15)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 15)
                    .frame(width: .screenWidth * 0.795)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                    )
                    .font(.customfont(.medium, fontSize: 15))
                    .foregroundStyle(.black.opacity(0.6))
                    .cornerRadius(15)
            }
            
            // Quantity and Price Input Fields
            VStack(spacing: 10) {
                HStack {
                    Text("Quantity")
                        .font(.customfont(.regular, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.6))
                    
                    Spacer().frame(width: 17)
                    
                    TextField("Input", text: $ingredient.quantity)
                        .multilineTextAlignment(.leading)
                        .frame(width: .screenWidth * 0.2)
                        .font(.customfont(.medium, fontSize: 15))
                }
                .frame(width: .screenWidth * 0.7, alignment: .leading)
                
                Divider()
                
                HStack {
                    Text("Price")
                        .font(.customfont(.regular, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.6))
                    
                    Spacer().frame(width: 40)
                    
                    HStack(spacing: 35) {
                        TextField("Input", text: $ingredient.price)
                            .multilineTextAlignment(.leading)
                            .frame(width: .screenWidth * 0.2)
                            .font(.customfont(.medium, fontSize: 15))
                        
                        Picker("", selection: $ingredient.selectedCurrency) {
                            ForEach(0..<currencies.count) { index in
                                Text(currencies[index])
                                    .tag(index)
                                    .font(.customfont(.medium, fontSize: 20))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 60)
                    }
                }
                .frame(width: .screenWidth * 0.7, alignment: .leading)
            }
            .padding(.vertical, 10)
            .frame(width: .screenWidth * 0.8)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
            )
            .padding(.leading, .screenWidth * 0.1)
            .padding(.bottom, .screenWidth * 0.04)
        }
    }
}
