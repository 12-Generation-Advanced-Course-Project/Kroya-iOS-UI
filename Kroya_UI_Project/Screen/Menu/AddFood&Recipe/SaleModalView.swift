import SwiftUI

struct SaleModalView: View {
    let dismissToRoot: () -> Void
    @Environment(\.dismiss) var dismiss
    @Binding var ingret: SaleIngredient
    @State private var isAvailableForSale: Bool? = nil
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible: Bool = false
    @State private var showError: Bool = false
    let totalRiels: Double
    let totalUSD: Double
    let currencies = ["៛", "$"]
    @State private var addressSelect: String = ""
    @ObservedObject var addressStore: AddressViewModel
    @ObservedObject var draftModelData: DraftModelData
    @Environment(\.modelContext) var modelContext
    @State var showDraftAlert: Bool = false
    @State private var formattedDate: String = ""
    private let conversionRate: Double = 4100.0
    @State private var priceText: String = ""
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .trailing, spacing: 15) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Is this food available for sale?")
                            .font(.customfont(.bold, fontSize: 16))
                        VStack(spacing: 15) {
                            Button(action: {
                                draftModelData.isForSale = true
                                isAvailableForSale = true
                            }) {
                                Text("Yes")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(draftModelData.isForSale ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(draftModelData.isForSale ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 4)
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 5)
                            
                            Button(action: {
                                draftModelData.isForSale = false
                                isAvailableForSale = false
                            }) {
                                Text("No")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(draftModelData.isForSale == false ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(draftModelData.isForSale == false ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 4)
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 5)
                        }
                        .padding(.vertical, 20)
                    }
                    
                    // Show details only if available for sale is Yes
                    if draftModelData.isForSale {
                        VStack(alignment: .leading) {
                            Text("Details")
                                .font(.customfont(.bold, fontSize: 16))
                                .padding(.vertical, 10)
                            VStack(spacing: 10) {
                                // Cook Date Section
                                HStack(spacing: 10) {
                                    Text("Cook date")
                                        .font(.customfont(.regular, fontSize: 15))
                                        .foregroundStyle(.black.opacity(0.6))
                                        .frame(minWidth: 100, alignment: .leading)
                                    Spacer()
                                    TextField("", text: $formattedDate)
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                        .foregroundStyle(.gray.opacity(0.8))
                                        .disabled(true)
                                    
                                    Button {
                                        isDatePickerVisible.toggle()
                                    } label: {
                                        Image(systemName: "calendar")
                                            .font(.customfont(.light, fontSize: 25))
                                            .foregroundColor(.gray)
                                    }
                                    .overlay(
                                        Group {
                                            if isDatePickerVisible {
                                                DatePicker(
                                                    selection: $draftModelData.cookDate,
                                                    in: Date()...,
                                                    displayedComponents: .date
                                                ) {
                                                    
                                                }
                                                .fixedSize()
                                                .labelsHidden()
                                                .colorMultiply(.clear)
                                                .onChange(of: draftModelData.cookDate) { newDate in
                                                    formattedDate = newDate.formatted(.dateTime.day().month().year())
                                                }
                                                
                                            }
                                        },
                                        alignment: .trailing
                                    )
                                    Spacer()
                                }
                                .padding(.horizontal)
                                Divider()
                                
                                HStack {
                                    Text("Amount")
                                        .font(.customfont(.regular, fontSize: 15))
                                        .foregroundStyle(.black.opacity(0.6))
                                        .frame(maxWidth: 120, alignment: .leading)
                                    TextField("", value: $draftModelData.amount, format: .number)
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.numberPad)
                                        .font(.customfont(.medium, fontSize: 15))
                                        .foregroundStyle(.gray.opacity(0.8))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onChange(of: draftModelData.amount) { _ in
                                            validateFields()
                                        }
                                }
                                .padding(.horizontal)
                                Divider()
                                
                                // Price Input Section
                                HStack {
                                    Text("Price")
                                        .font(.customfont(.regular, fontSize: 15))
                                        .foregroundStyle(.black.opacity(0.6))
                                        .frame(maxWidth: 120, alignment: .leading)
                                    
                                    TextField(getCurrencyPlaceholder(), text: Binding(
                                        get: { formatPrice() },
                                        set: { newValue in
                                            priceText = filterPriceInput(newValue)
                                            ingret.price = Double(priceText) ?? 0.0
                                        }
                                    ))
                                    .multilineTextAlignment(.leading)
                                    .keyboardType(.decimalPad)
                                    .foregroundStyle(.gray.opacity(0.8))
                                    .font(.customfont(.medium, fontSize: 15))
                                    .onChange(of: ingret.price) { _ in
                                        validateFields()
                                    }
                                    
                                    Picker("", selection: $ingret.selectedCurrency) {
                                        ForEach(0..<currencies.count) { index in
                                            Text(currencies[index])
                                                .tag(index)
                                                .font(.customfont(.medium, fontSize: 20))
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .frame(width: 60)
                                    .onChange(of: ingret.selectedCurrency) { newCurrency in
                                        if newCurrency == 1 {
                                            // Convert Riel to USD if switching to USD
                                            ingret.price = convertCurrency(ingret.price)
                                        } else {
                                            // Convert USD to Riel if switching to Riel
                                            ingret.price = ingret.price * conversionRate
                                        }
                                    }

                                }
                                .padding(.horizontal)
                                
                                Divider()
                                
                                NavigationLink(destination: AddressView(viewModel: addressStore)) {
                                    HStack {
                                        Text("Location")
                                            .font(.customfont(.regular, fontSize: 15))
                                            .foregroundStyle(.black.opacity(0.8))
                                            .frame(maxWidth: 120, alignment: .leading)
                                        
                                        TextField("Choose Location", text: Binding(
                                            get: { addressStore.selectedAddress?.specificLocation ?? "" },
                                            set: { _ in }
                                        ))
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.gray.opacity(0.8))
                                        .disabled(true)
                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                            )
                            
                            HStack {
                                if showError {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                        Text("Detail information cannot be empty")
                                            .foregroundColor(.red)
                                            .font(.customfont(.regular, fontSize: 10))
                                    }
                                }
                                Spacer()
                                VStack {
                                    Text("Ingredient ")
                                        .font(.customfont(.medium, fontSize: 13))
                                        .foregroundColor(.black.opacity(0.4)) +
                                    Text("\(totalRiels, specifier: "%.2f") ៛")
                                        .foregroundStyle(.yellow)
                                        .font(.customfont(.medium, fontSize: 13)) +
                                    Text("(\(totalUSD, specifier: "%.2f")$)")
                                        .font(.customfont(.medium, fontSize: 13))
                                        .foregroundColor(.black.opacity(0.4))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
        }
        
        Spacer()
        
        HStack(spacing: 10) {
            Button(action: {
                dismiss()
            }) {
                Text("Back")
                    .font(.customfont(.semibold, fontSize: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.3))
                    )
                    .foregroundColor(.black)
            }
            
            Button(action: {
                validateFields()
                if !showError {
                    draftModelData.saveDraft(in: modelContext) // Save data
                    draftModelData.clearDraft(from: modelContext) // Clear data after save
                    dismissToRoot()
                }
            }) {
                Text("Post")
                    .font(.customfont(.semibold, fontSize: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(showError ? Color.gray.opacity(0.3) : PrimaryColor.normal)
                    )
            }
            .disabled(showError)
            .navigationTitle("Sale")
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Sale")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            addressStore.fetchAllAddresses()
            formattedDate = draftModelData.cookDate.formatted(.dateTime.day().month().year())
            _ = formatPrice()
        }
        .onChange(of: addressStore.selectedAddress) { _ in
            addressSelect = addressStore.selectedAddress?.specificLocation ?? ""
            validateFields()
        }
        .alert(isPresented: $showDraftAlert) {
            Alert(
                title: Text("Save this as a draft?"),
                message: Text("If you choose to discard, you will lose this post and it can't be edited again."),
                primaryButton: .default(Text("Save Draft")) {
                    draftModelData.saveDraft(in: modelContext)
                    dismissToRoot()
                },
                secondaryButton: .destructive(Text("Discard Post")) {
                    draftModelData.clearDraft(from: modelContext)
                    dismissToRoot()
                }
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: handleCancel) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    

    private func handleCancel() {
        if hasDraftData {
            showDraftAlert = true
        } else {
            dismiss()
        }
    }
    
    private var hasDraftData: Bool {
        return !draftModelData.foodName.isEmpty ||
        !draftModelData.descriptionText.isEmpty ||
        !draftModelData.selectedImages.isEmpty ||
        draftModelData.selectedLevel != nil ||
        draftModelData.selectedCuisine != nil ||
        draftModelData.selectedCategory != nil ||
        draftModelData.duration > 0 ||
        draftModelData.amount > 0 ||
        draftModelData.price > 0 ||
        !draftModelData.location.isEmpty ||
        draftModelData.isForSale
    }
    
    private func validateFields() {
        showError = draftModelData.amount == 0 || ingret.price == 0 || addressStore.selectedAddress == nil
    }

    private func getCurrencyPlaceholder() -> String {
        return ingret.selectedCurrency == 0 ? "0" : "0.00"
    }

    // MARK: Function to format the price based on currency selection
    private func formatPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = ingret.selectedCurrency == 0 ? 4 : 2
        formatter.groupingSeparator = ingret.selectedCurrency == 1 ? "," : ""
        return formatter.string(from: NSNumber(value: ingret.price)) ?? ""
    }

    // MARK: Function to filter and format the price input based on the selected currency
    private func filterPriceInput(_ input: String) -> String {
        let maxDecimalPlaces = ingret.selectedCurrency == 0 ? 4 : 2
        var filtered = input.filter { "0123456789.".contains($0) }
        
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

    // MARK: Function to convert the price based on selected currency
    private func convertCurrency(_ price: Double) -> Double {
        if ingret.selectedCurrency == 0 {
            // If currency is Riel, return the price as is
            return price
        } else {
            // If currency is USD, convert the Riel price to USD
            return price / conversionRate
        }
    }
}





//    private func formatPrice() -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.minimumFractionDigits = 0
//        formatter.maximumFractionDigits = ingret.selectedCurrency == 0 ? 4 : 2
//        formatter.groupingSeparator = ingret.selectedCurrency == 1 ? "," : ""
//        return formatter.string(from: NSNumber(value: draftModelData.price)) ?? "0"
//    }
//
//    private func filterPriceInput(_ input: String) -> Double {
//        let maxDecimalPlaces = ingret.selectedCurrency == 0 ? 4 : 2
//        var filtered = input.filter { "0123456789.".contains($0) }
//
//        let components = filtered.components(separatedBy: ".")
//        guard components.count <= 2 else { return draftModelData.price }
//
//        if components.count == 2 {
//            let decimalPart = String(components[1].prefix(maxDecimalPlaces))
//            filtered = "\(components[0]).\(decimalPart)"
//        }
//
//        return Double(filtered) ?? 0.0
//    }
