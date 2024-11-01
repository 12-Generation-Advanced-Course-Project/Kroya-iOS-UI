import SwiftUI

struct Ingret: Identifiable, Codable {
    var id = UUID()
    var cookDate: String
    var amount: String
    var price: String
    var location: String
    var selectedCurrency: Int
}



struct SaleModalView: View {
    let dismissToRoot: () -> Void
    @Environment(\.dismiss) var dismiss
    @Binding var ingret: Ingret
    @State private var isAvailableForSale: Bool? = nil
    @State private var selectedDate = Date()
    @State private var isDatePickerVisible: Bool = false
    @State private var showError: Bool = false
    let totalRiels: Double
    let totalUSD: Double
    let currencies = ["៛", "$"]
    @State private var addressSelect: String = ""
    @ObservedObject var addressStore: AddressViewModel
    @ObservedObject var draftModel: DraftModel
    @State var showDraftAlert: Bool = false
    @State private var formattedDate: String = ""
    private let conversionRate: Double = 4100.0
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .trailing, spacing: 15) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Is this food available for sale?")
                            .font(.customfont(.bold, fontSize: 16))
                        VStack(spacing: 15) {
                            Button(action: {
                                draftModel.isForSale = true
                                isAvailableForSale = true
                            }) {
                                Text("Yes")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(draftModel.isForSale == true ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(draftModel.isForSale == true ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 4)
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 5)
                            
                            Button(action: {
                                draftModel.isForSale = false
                                isAvailableForSale = false
                            }) {
                                Text("No")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(draftModel.isForSale == false ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(draftModel.isForSale == false ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 4)
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 5)
                        }
                        .padding(.vertical, 20)
                    }
                    
                    // Show details only if available for sale is Yes
                    if draftModel.isForSale == true {
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
                                                    selection: $draftModel.CookDate,
                                                    in: Date()...,
                                                    displayedComponents: .date
                                                ) {
                                                    
                                                }
                                                .fixedSize()
                                                .labelsHidden()
                                                .colorMultiply(.clear)
                                                .onChange(of: draftModel.CookDate) { newDate in
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
                                    TextField("", value: $draftModel.amount, format: .number)
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.numberPad)
                                        .font(.customfont(.medium, fontSize: 15))
                                        .foregroundStyle(.gray.opacity(0.8))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onChange(of: draftModel.amount) { _ in
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
                                    
                                    HStack {
                                        TextField(getCurrencyPlaceholder(), text: Binding(
                                            get: { formatPrice() },
                                            set: { newValue in
                                                draftModel.price = filterPriceInput(newValue)
                                            }
                                        ))
                                        .multilineTextAlignment(.leading)
                                        .keyboardType(.decimalPad)
                                        .foregroundStyle(.gray.opacity(0.8))
                                        .font(.customfont(.medium, fontSize: 15))
                                        .onChange(of: draftModel.price) { _ in
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
                                        .onChange(of: ingret.selectedCurrency) { _ in
                                            draftModel.price = convertCurrency(draftModel.price)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                
                                NavigationLink(destination: AddressView(viewModel: addressStore)) {
                                    HStack {
                                        Text("Location")
                                            .font(.customfont(.regular, fontSize: 15))
                                            .foregroundStyle(.black.opacity(0.6))
                                            .frame(maxWidth: 120, alignment: .leading)
                                        
                                        TextField("Choose Location", text: Binding(
                                            get: { addressStore.selectedAddress?.specificLocation ?? "" },
                                            set: { _ in }
                                        ))
                                        .multilineTextAlignment(.leading)
                                        .font(.customfont(.medium, fontSize: 15))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.gray.opacity(0.4))
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
                                // Error message if any required fields are empty
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
                    print("Post Food Created")
                    dismissToRoot()
                }
            }) {
                Text("Post")
                    .font(.customfont(.semibold, fontSize: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(showError ? .gray.opacity(0.3) : PrimaryColor.normal)
                    )
                    .foregroundColor(.white)
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
            formattedDate = draftModel.CookDate.formatted(.dateTime.day().month().year())
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
                    saveDraft()
                    dismissToRoot()
                },
                secondaryButton: .destructive(Text("Discard Post")) {
                    draftModel.clearDraft()
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
    
//    // MARK: Validation function
    private func validateFields() {
        showError = draftModel.amount == 0 || draftModel.price == 0 || addressStore.selectedAddress == nil
    }
//    
    // MARK: Saving Draft
    private func handleCancel() {
        if draftModel.hasDraftData {
            showDraftAlert = true
        } else {
            dismiss()
        }
    }
    
    // MARK: Save Draft
    private func saveDraft() {
        // Implement your logic for saving the draft
    }
    //MARK: Function to get the placeholder based on selected currency
    private func getCurrencyPlaceholder() -> String {
        ingret.selectedCurrency == 0 ? "0.0000" : "0.00"
    }
    
    //MARK: Function to format the price based on selected currency
    private func formatPrice() -> String {
        if draftModel.price != 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = ingret.selectedCurrency == 0 ? 4 : 2
            formatter.groupingSeparator = ingret.selectedCurrency == 0 ? "," : ""
            return formatter.string(from: NSNumber(value: draftModel.price)) ?? ""
        }
        return ""
    }
    
    //MARK: Function to filter price input based on currency selection
    private func filterPriceInput(_ input: String) -> Double {
        let maxDecimalPlaces = ingret.selectedCurrency == 0 ? 4 : 2
        var filtered = input.filter { "0123456789.".contains($0) }
        
        // Ensure only one decimal point
        if filtered.components(separatedBy: ".").count > 2 {
            filtered.removeLast()
        }
        
        // Limit decimal places
        if let decimalIndex = filtered.firstIndex(of: ".") {
            let integerPart = filtered[..<decimalIndex]
            let decimalPart = filtered[decimalIndex...].prefix(maxDecimalPlaces + 1)
            filtered = String(integerPart + decimalPart)
        }
        
        return Double(filtered) ?? 0.0
    }
    
    //MARK: Function to convert currency based on the selected currency type
    private func convertCurrency(_ price: Double) -> Double {
        if ingret.selectedCurrency == 0 {
            // Convert USD to Riels
            return price * conversionRate
        } else {
            // Convert Riels to USD
            return price / conversionRate
        }
    }
    
    // MARK: Validation Function
//    private func validateFields() {
//        showError = draftModel.price == 0 || draftModel.amount == 0 || draftModel.location.isEmpty
//    }
}
