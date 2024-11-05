import SwiftUI
struct IngredientEntryView: View {
    
    @Binding var ingredient: RecipeIngredient
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var showValidationError = false
    @State private var priceText: String = ""
    let currencies = ["៛", "$"]
    private let conversionRate: Double = 4000.0
    
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
            .padding(.leading, .screenWidth * 0.020)
            .padding(.top, 10)
            
            // Quantity and Price Input Fields
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Quantity")
                        .font(.customfont(.regular, fontSize: 15))
                        .foregroundStyle(.black.opacity(0.6))
                        
                    Spacer().frame(width: 25)
                    TextField("Input", text: Binding(
                        get: { ingredient.quantity == 0 ? "" : String(Int(ingredient.quantity)) },
                        set: { newValue in
                            if let value = Int(newValue) {
                                ingredient.quantity = Double(value)
                            } else {
                                ingredient.quantity = 0 // Reset if invalid input
                            }
                        }
                    ))
                    .multilineTextAlignment(.leading)
                    .font(.customfont(.medium, fontSize: 15))
                    .keyboardType(.numberPad)
                    .foregroundStyle(.black.opacity(0.6))
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
                    
                    TextField("Input", text: Binding(
                        get: { priceText },
                        set: { newValue in
                            priceText = filterPriceInput(newValue)
                            ingredient.price = Double(priceText) ?? 0.0
                        }
                    ))
                    .multilineTextAlignment(.leading)
                    .font(.customfont(.medium, fontSize: 15))
                    .foregroundStyle(.black.opacity(0.6))
                    .keyboardType(.decimalPad)
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
                        ingredient.price = convertCurrency(ingredient.price)
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
            
            // Error message if fields are empty
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
    
    // MARK: Function to format the price based on currency selection
    private func formatPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = ingredient.selectedCurrency == 0 ? 4 : 2
        formatter.groupingSeparator = ingredient.selectedCurrency == 1 ? "," : ""
        return formatter.string(from: NSNumber(value: ingredient.price)) ?? ""
    }

    // MARK: Function to filter and format the price input based on the selected currency
    private func filterPriceInput(_ input: String) -> String {
        let maxDecimalPlaces = ingredient.selectedCurrency == 0 ? 4 : 2
        var filtered = input.filter { "0123456789.,".contains($0) }
        
        // Remove commas if currency is Riels, as we only format with commas for USD
        if ingredient.selectedCurrency == 0 {
            filtered = filtered.replacingOccurrences(of: ",", with: "")
        }
        
        // Prevent the price from starting with zero unless followed by a decimal
        if filtered.hasPrefix("0") && !filtered.hasPrefix("0.") && filtered.count > 1 {
            filtered.removeFirst()
        }
        
        // Handle multiple decimal points
        let components = filtered.components(separatedBy: ".")
        if components.count > 2 {
            filtered = components[0] + "." + components[1]
        } else if components.count == 2 {
            // Limit decimal places for USD (2) or Riels (4)
            let decimalIndex = filtered.firstIndex(of: ".") ?? filtered.endIndex
            let integerPart = filtered[..<decimalIndex]
            let decimalPart = filtered[decimalIndex...].prefix(maxDecimalPlaces + 1)
            filtered = String(integerPart + decimalPart)
        }
        
        return filtered
    }

    
    // MARK: Function to convert the currency value when switching between Riel and USD
    private func convertCurrency(_ price: Double) -> Double {
        if ingredient.selectedCurrency == 0 {
            return price * conversionRate // USD to Riels
        } else {
            return price / conversionRate // Riels to USD
        }
    }
    
    // MARK: Function to trigger validation error on "Next" button tap
    func validateFields() {
        showValidationError = ingredient.name.isEmpty || ingredient.quantity == 0 || ingredient.price == 0
    }
}
