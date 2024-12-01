import SwiftUI

struct IngredientEntryView: View {
    @Binding var ingredient: RecipeIngredient
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var quantityText: String = ""
    @State private var showValidationError = false
    @State private var priceText: String = ""
    let currencies = ["៛", "$"]
    private let conversionRate: Double = 4000.0
    @Environment(\.locale) var locale

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Ingredient Name Section
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
            .padding(.leading, .screenWidth * 0.020)
            .padding(.top, 10)
            
            // Quantity and Price Input Fields
            VStack(alignment: .leading, spacing: 10) {
                // Quantity Field
                HStack {
                    Text("Quantity")
                        .customFontMediumLocalize(size: 15)
                        .foregroundStyle(.black.opacity(0.6))

                    Spacer().frame(width: 25)

                    TextField("Input (e.g., 3kg)", text: $quantityText)
                        .multilineTextAlignment(.leading)
                        .customFontMediumLocalize(size: 15)
                        .keyboardType(.default)
                        .foregroundStyle(.black.opacity(0.6))
                        .padding(.leading, 10)
                        .frame(width: .screenWidth * 0.4, height: 30)
                        .onChange(of: quantityText) { newValue in
                            parseQuantityAndUnit(newValue) // Update quantity dynamically
                        }
                        .onAppear {
                            quantityText = formatQuantity() // Display formatted quantity
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

                
                Divider()
                
                // Price Field
                HStack {
                    Text("Price")
                        .customFontMediumLocalize(size: 15)
                        .foregroundStyle(.black.opacity(0.6))

                    Spacer().frame(width: locale.identifier == "ko" ? 40 : locale.identifier == "km-KH" ? 40 : 60)

                    TextField("0", text: Binding(
                        get: { priceText },
                        set: { newValue in
                            priceText = filterPriceInput(newValue)
                            ingredient.price = Double(priceText) ?? 0.0
                        }
                    ))
                    .multilineTextAlignment(.leading)
                    .customFontMediumLocalize(size: 15)
                    .foregroundStyle(.black.opacity(0.6))
                    .keyboardType(.decimalPad)
                    .frame(width: .screenWidth * 0.25, height: 30)

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
                        // Do not modify price during currency switch
                        priceText = formatPrice()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 13)
                .padding(.top, 5)

            }
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
            )
            .padding(.leading, .screenWidth * 0.1)
            .padding(.trailing, 1)
            
            // Validation Error Message
            if showValidationError && (ingredient.name.isEmpty || ingredient.quantity == 0 || ingredient.price == 0) {
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
        .onAppear {
            priceText = formatPrice()
        }
    }

    // MARK: Parse Quantity and Unit
    private func parseQuantityAndUnit(_ input: String) {
        let unitRegex = #"(\d+\.?\d*)([a-zA-Z]*)"#
        if let match = input.range(of: unitRegex, options: .regularExpression) {
            let quantity = Double(input[match].split(whereSeparator: { $0.isLetter }).first ?? "0") ?? 0
            ingredient.quantity = quantity // Store the numeric part as-is
            // Note: Units are not converted here
        }
    }



    // Convert Units to Grams
    private func convertToGrams(quantity: Double, unit: String) -> Double {
        switch unit.lowercased() {
        case "kg": return quantity * 1000 // Kilograms to grams
        case "g": return quantity // Grams remain unchanged
        default: return quantity // Default to grams
        }
    }
    
    // Format Quantity for Display
    private func formatQuantity() -> String {
        if ingredient.quantity >= 1000 {
            return "\(ingredient.quantity / 1000)kg"
        } else {
            return "\(ingredient.quantity)g"
        }
    }

    // Filter Price Input
    private func filterPriceInput(_ input: String) -> String {
        let maxDecimalPlaces = ingredient.selectedCurrency == 0 ? 4 : 2
        var filtered = input.filter { "0123456789.,".contains($0) }
        
        if filtered == "." {
            filtered = "0."
        }
        if ingredient.selectedCurrency == 0 {
            filtered = filtered.replacingOccurrences(of: ",", with: "")
        }
        let components = filtered.components(separatedBy: ".")
        if components.count > 2 {
            filtered = components[0] + "." + components[1]
        } else if components.count == 2 {
            let decimalIndex = filtered.firstIndex(of: ".") ?? filtered.endIndex
            let integerPart = filtered[..<decimalIndex]
            let decimalPart = filtered[decimalIndex...].prefix(maxDecimalPlaces + 1)
            filtered = String(integerPart + decimalPart)
        }
        return filtered
    }

    // Format Price
    private func formatPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = ingredient.selectedCurrency == 0 ? 4 : 2
        formatter.groupingSeparator = ingredient.selectedCurrency == 1 ? "," : ""
        return formatter.string(from: NSNumber(value: ingredient.price)) ?? ""
    }

    // Convert Currency
    private func convertCurrency(_ price: Double) -> Double {
        if ingredient.selectedCurrency == 0 {
            return price * conversionRate // USD to Riels
        } else {
            return price / conversionRate // Riels to USD
        }
    }
}
