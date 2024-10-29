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
    let onEdit: () -> Void  // Action for editing
    let onDelete: () -> Void  // Action for deleting
    
    @State private var showError = false  // Track validation state
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
                    .padding(.leading, 7)
                VStack(alignment: .leading){
                    HStack{
                        TextField("Enter incredients", text: $ingredient.name)
                            .padding(.vertical, 15)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 10)
                            .padding(.trailing,2)
                            .frame(maxWidth: .infinity)
                            .font(.customfont(.medium, fontSize: 15))
                            .foregroundStyle(.black.opacity(0.6))
                            .cornerRadius(15)
                        //                    if ingredient.name.contains([]) {
                        //
                        //                    }
                        EditDropDownButton(onEdit: onEdit, onDelete: onDelete)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                    )
                    if ingredient.name == "" {
                        HStack{
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(LocalizedStringKey("Ingredient cannot be empty"))
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
            }
            
            // Quantity and Price Input Fields
            VStack(alignment: .leading){
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
                                .keyboardType(.decimalPad)
                            Picker("", selection: $ingredient.selectedCurrency) {
                                ForEach(currencies.indices, id: \.self) { index in
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
            }
            .padding(.vertical, 10)
            .frame(width: .screenWidth * 0.8)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
            )
            
            .padding(.leading, .screenWidth * 0.1)
            
            if (ingredient.quantity == "" || ingredient.price == "" ) {
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(LocalizedStringKey("quantity and price cannot be empty"))
                        .foregroundColor(.red)
                        .font(.caption)
                }
            } 
        }.cornerRadius(15)
        
    }
}

