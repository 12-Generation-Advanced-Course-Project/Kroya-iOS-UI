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
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showValidationError = false
    let currencies = ["៛", "$"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ico_move")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "#D0DBEA"))
                HStack {
                    TextField("Enter ingredients", text: $ingredient.name)
                        .padding(.vertical, 17)
                        .padding(.horizontal, 10)
                        .font(.customfont(.medium, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.6))
                        .cornerRadius(12)
                        .onChange(of: ingredient.name) { _ in
                            showValidationError = false
                        }
                    
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(.black)
                            .padding(.trailing, 10)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                )
            }
            .padding(.leading, .screenWidth * 0.015)
            .padding(.top, 10)
            
            // Quantity and Price Input Fields
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Quantity")
                        .font(.customfont(.regular, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.6))
                    
                    TextField("Input", text: $ingredient.quantity)
                        .multilineTextAlignment(.leading)
                        .font(.customfont(.medium, fontSize: 15))
                        .keyboardType(.numberPad)
                        .padding(.leading, 10)
                        .frame(width: .screenWidth * 0.2, height: 30)
                        .onChange(of: ingredient.quantity) { _ in
                            showValidationError = false
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                Divider()
                
                HStack {
                    Text("Price")
                        .font(.customfont(.regular, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.6))
                    Spacer().frame(width: 30)
                    TextField(getCurrencyPlaceholder(), text: Binding(
                        get: { ingredient.price },
                        set: { newValue in
                            ingredient.price = formatNumericInput(newValue, for: ingredient.selectedCurrency)
                        }
                    ))
                    .multilineTextAlignment(.leading)
                    .font(.customfont(.medium, fontSize: 15))
                    .keyboardType(.numberPad)
                    .padding(.leading, 10)
                    .frame(width: .screenWidth * 0.2, height: 30)
                    .onChange(of: ingredient.price) { _ in
                        showValidationError = false
                    }
                    Spacer()
                    Picker("", selection: $ingredient.selectedCurrency) {
                        ForEach(currencies.indices, id: \.self) { index in
                            Text(currencies[index])
                                .tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 60)
                    .onChange(of: ingredient.selectedCurrency) { _ in
                        ingredient.price = formatNumericInput(ingredient.price, for: ingredient.selectedCurrency)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
            )
            .padding(.leading, .screenWidth * 0.1)
            
            // Error message shown only if showValidationError is true
            if showValidationError && (ingredient.name.isEmpty || ingredient.quantity.isEmpty || ingredient.price.isEmpty) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Please fill all fields")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .padding(.horizontal)
            }
        }
        .background(Color.clear)
        .cornerRadius(15)
    }
    
    // Function to get the placeholder text based on selected currency
    private func getCurrencyPlaceholder() -> String {
        ingredient.selectedCurrency == 0 ? "0.0000" : "0.00"
    }
    
    // Function to format the price based on currency selection
    private func formatNumericInput(_ input: String, for currency: Int) -> String {
        // Set max decimal places based on currency (៛ = 4 decimal places, $ = 2 decimal places)
        let maxDecimalPlaces = (currency == 0) ? 4 : 2
        let regex = (currency == 0) ? "^[0-9]*((\\.[0-9]{0,4})?)$" : "^[0-9]*((\\.[0-9]{0,2})?)$"
        
        // Filter input to remove non-numeric characters except for decimal
        let filtered = input.filter { "0123456789.".contains($0) }
        
        // Limit decimal places
        if let dotIndex = filtered.firstIndex(of: ".") {
            let integerPart = filtered.prefix(upTo: dotIndex)
            let decimalPart = filtered.suffix(from: dotIndex).prefix(maxDecimalPlaces + 1)
            return String(integerPart + decimalPart)
        }
        
        // Check against regex for valid input and return
        if filtered.range(of: regex, options: .regularExpression) != nil {
            return filtered
        }
        return "" // Reset if invalid input
    }

    
    // Function to trigger validation error on "Next" button tap
    func validateFields() {
        showValidationError = ingredient.name.isEmpty || ingredient.quantity.isEmpty || ingredient.price.isEmpty
    }
}
