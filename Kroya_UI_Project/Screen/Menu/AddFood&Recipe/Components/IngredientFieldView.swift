import SwiftUI

struct Ingredient: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantity: String
    var price: Double
    var selectedCurrency: Int // 0 for Riel, 1 for USD
}

struct IngredientEntryView: View {
    
    @Binding var ingredient: Ingredient
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var showValidationError = false
    let currencies = ["៛", "$"]
    private let conversionRate: Double = 4100.0
    @State private var basePrice: Double = 0.0
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
                    
                    TextField("Input", text: Binding(
                        get: { ingredient.quantity },
                        set: { newValue in
                            ingredient.quantity = newValue.filter { "0123456789".contains($0) }
                        }
                    ))
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
                        get: { formatPrice() },
                        set: { newValue in
                            let filteredValue = filterPriceInput(newValue)
                            basePrice = Double(filteredValue) ?? 0.0
                            ingredient.price = filteredValue
                        }
                    ))
                    .multilineTextAlignment(.leading)
                    .font(.customfont(.medium, fontSize: 15))
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
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 13)
                .padding(.top,5)
  
            }
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
            )
            .padding(.leading, .screenWidth * 0.1)
            .padding(.trailing, 1)
            
            // Error message if fields are empty
            if showValidationError && (ingredient.name.isEmpty || ingredient.quantity.isEmpty || ingredient.price.isNaN) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(LocalizedStringKey("Please fill all fields"))
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .padding(.horizontal)
            }
        }
        .background(Color.clear)
        .cornerRadius(15)
        .onAppear {
                    basePrice = ingredient.price
                }
    }
    
    //MARK: Function to get the placeholder text based on selected currency
    private func getCurrencyPlaceholder() -> String {
        ingredient.selectedCurrency == 0 ? "0.0000" : "0.0000"
    }
    
    //MARK: Function to format the price based on currency selection
    private func formatPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = ingredient.selectedCurrency == 0 ? 4 : 2
        formatter.groupingSeparator = ingredient.selectedCurrency == 1 ? "," : ""
        return formatter.string(from: NSNumber(value: ingredient.price)) ?? ""
    }

    
    //MARK: Function to filter and format the price input based on the selected currency
    private func filterPriceInput(_ input: String) -> Double {
        let maxDecimalPlaces = ingredient.selectedCurrency == 0 ? 4 : 2 // 4 for Riels, 2 for USD
        var filtered = input.filter { "0123456789.,".contains($0) } // Allow commas and periods
        
        // Remove commas if currency is Riels, as we only format with commas for USD
        if ingredient.selectedCurrency == 0 {
            filtered = filtered.replacingOccurrences(of: ",", with: "")
        }
        
        // Handle multiple decimal points
        let components = filtered.components(separatedBy: ".")
        if components.count > 1 {
            filtered.removeLast()
        }
        
        // Limit decimal places
        if let decimalIndex = filtered.firstIndex(of: ".") {
            let integerPart = filtered[..<decimalIndex]
            let decimalPart = filtered[decimalIndex...].prefix(maxDecimalPlaces + 1)
            filtered = String(integerPart + decimalPart)
        }
        
        // Remove extra commas in the integer part (just in case)
        if ingredient.selectedCurrency == 1 {
            filtered = formatUSDInput(filtered)
        }
        
        return Double(filtered.replacingOccurrences(of: ",", with: "")) ?? 0.0
    }
    // Helper function to format USD input with commas
    private func formatUSDInput(_ input: String) -> String {
        let components = input.components(separatedBy: ".")
        var integerPart = components[0].replacingOccurrences(of: ",", with: "")
        
        // Format integer part with commas for USD
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        if let formattedIntegerPart = numberFormatter.string(from: NSNumber(value: Double(integerPart) ?? 0)) {
            integerPart = formattedIntegerPart
        }
        
        // Add back the decimal part if it exists
        if components.count > 1, let decimalPart = components.last {
            return integerPart + "." + decimalPart
        }
        return integerPart
    }
    
    //MARK: Function to convert the currency value when switching between Riel and USD
    private func convertCurrency(_ price: Double) -> Double {
            if ingredient.selectedCurrency == 0 {
                return price * conversionRate // USD to Riels
            } else {
                return price / conversionRate // Riels to USD
            }
        }
    
    
    //MARK: Function to trigger validation error on "Next" button tap
    func validateFields() {
        showValidationError = ingredient.name.isEmpty || ingredient.quantity.isEmpty || ingredient.price.isNaN
    }
}

