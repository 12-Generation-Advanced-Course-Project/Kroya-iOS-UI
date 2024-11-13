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
    @StateObject private var addressStore = AddressViewModel()
    @ObservedObject var draftModelData: DraftModelData
    @Environment(\.modelContext) var modelContext
    @State var showDraftAlert: Bool = false
    @State private var formattedDate: String = ""
    private let conversionRate: Double = 4100.0
    @State private var priceText: String = ""
    @StateObject private var recipeVM = RecipeViewModel()
    @StateObject private var saleVM = FoodSellViewModel()
    @StateObject private var imageVM = ImageUploadViewModel()
    @State private var showLoadingOverlay = false
    @State private var showSuccessPopup = false
    
    var body: some View {
        ZStack{
            VStack{
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .trailing, spacing: 15) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Is this food available for sale?")
                                    .customFontBoldLocalize(size: 16)
                                
                                VStack(spacing: 15) {
                                    Button(action: {
                                        draftModelData.isForSale = true
                                        isAvailableForSale = true
                                    }) {
                                        Text("Yes")
                                            .customFontSemiBoldLocalize(size: 16)
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
                                    }) {
                                        Text("No")
                                            .customFontSemiBoldLocalize(size: 16)
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
                                        .customFontBoldLocalize(size: 16)
                                        .padding(.vertical, 10)
                                    VStack(spacing: 10) {
                                        // Cook Date Section
                                        HStack(spacing: 10) {
                                            Text("Cook date")
                                                .customFontLightLocalize(size: 15)
                                                .foregroundStyle(.black.opacity(0.6))
                                                .frame(minWidth: 100, alignment: .leading)
                                            Spacer()
                                            TextField("", text: $formattedDate)
                                                .customFontMediumLocalize(size: 15)
                                                .multilineTextAlignment(.leading)
                                                .foregroundStyle(.gray.opacity(0.8))
                                                .disabled(true)
                                            
                                            Button {
                                                isDatePickerVisible.toggle()
                                            } label: {
                                                Image(systemName: "calendar")
                                                    .customFontLightLocalize(size: 25)
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
                                                .customFontLightLocalize(size: 15)
                                                .foregroundStyle(.black.opacity(0.6))
                                                .frame(maxWidth: 120, alignment: .leading)
                                            TextField("", value: $draftModelData.amount, format: .number)
                                                .customFontMediumLocalize(size: 15)
                                                .multilineTextAlignment(.leading)
                                                .keyboardType(.numberPad)
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
                                                .customFontLightLocalize(size: 16)
                                                .foregroundStyle(.black.opacity(0.6))
                                                .frame(maxWidth: 120, alignment: .leading)
                                            
                                            TextField(getCurrencyPlaceholder(), text: Binding(
                                                get: { formatPrice() },
                                                set: { newValue in
                                                    priceText = filterPriceInput(newValue)
                                                    let price = Double(priceText) ?? 0.0
                                                    ingret.price = price
                                                    draftModelData.price = price // Save to draftModelData
                                                }
                                            ))
                                            .customFontMediumLocalize(size: 15)
                                            .multilineTextAlignment(.leading)
                                            .keyboardType(.decimalPad)
                                            .foregroundStyle(.gray.opacity(0.8))
                                            .onChange(of: draftModelData.price) { _ in
                                                validateFields()
                                            }
                                            
                                            Picker("", selection: $ingret.selectedCurrency) {
                                                ForEach(0..<currencies.count) { index in
                                                    Text(currencies[index])
                                                        .tag(index)
                                                        .customFontMediumLocalize(size: 20)
                                                }
                                            }
                                            .pickerStyle(SegmentedPickerStyle())
                                            .frame(width: 60)
                                            .onChange(of: ingret.selectedCurrency) { newCurrency in
                                                // Convert currency on selection change
                                                if newCurrency == 1 {
                                                    ingret.price = convertCurrency(ingret.price)
                                                } else {
                                                    ingret.price = ingret.price * conversionRate
                                                }
                                                draftModelData.price = ingret.price
                                                validateFields()
                                            }
                                        }
                                        .padding(.horizontal)
                                        Divider()
                                        NavigationLink(destination: AddressView(viewModel: addressStore)) {
                                            HStack {
                                                Text("Location")
                                                    .customFontLightLocalize(size: 15)
                                                    .foregroundStyle(.black.opacity(0.8))
                                                    .frame(maxWidth: 120, alignment: .leading)
                                                TextField("Choose Location", text: Binding(
                                                    get: { draftModelData.location },
                                                    set: { newValue in draftModelData.location = newValue }
                                                ))
                                                .customFontMediumLocalize(size: 15)
                                                .multilineTextAlignment(.leading)
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
                                                    .customFontLightLocalize(size: 10)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        Spacer()
                                        VStack {
                                            HStack{
                                                Text("Ingredient ")
                                                    .customFontMediumLocalize(size: 13)
                                                    .foregroundColor(.black.opacity(0.4))
                                                Text("\(totalRiels, specifier: "%.2f") ៛")
                                                    .foregroundStyle(.yellow)
                                                    .customFontMediumLocalize(size: 13)
                                                Text("(\(totalUSD, specifier: "%.2f")$)")
                                                    .customFontMediumLocalize(size: 13)
                                                    .foregroundColor(.black.opacity(0.4))
                                            }
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
                            .customFontSemiBoldLocalize(size: 16)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gray.opacity(0.3))
                            )
                            .foregroundColor(.black)
                    }
                    //MARK: Buttom Post-FoodRecipe and FoodSell
                    Button(action: {
                        if draftModelData.isForSale {
                            validateFields()
                            if !showError {
                                uploadImagesAndPostRecipe()
                            }
                        } else {
                            uploadImagesAndPostRecipe()
                        }
                    }) {
                        Text("Post")
                            .customFontSemiBoldLocalize(size: 16)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(showError ? Color.gray.opacity(0.3) : PrimaryColor.normal)
                            )
                    }
                    .disabled(draftModelData.isForSale && showError)
                    
                }
                .padding()
            }
            // Loading Overlay
            if showLoadingOverlay {
                LoadingOverlay()
            }
            
            // Success Popup
            if showSuccessPopup {
                PopupMessage()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessPopup = false
            
                        }
                    }
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Sale")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            addressStore.fetchAllAddresses()
            formattedDate = draftModelData.cookDate.formatted(.dateTime.day().month().year())
            draftModelData.location = addressStore.selectedAddress?.specificLocation ?? "" // Set location on appear
            _ = formatPrice()
        }
        
        .onChange(of: addressStore.selectedAddress) { newAddress in
            // Set location on address selection
            draftModelData.location = newAddress?.specificLocation ?? ""
            // Re-validate fields after location change
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
    
    //MARK: Logic for Add Food as Recipe
    private func uploadImagesAndPostRecipe() {
        showLoadingOverlay = true // Start loading
        imageVM.uploadImages(draftModelData.selectedImages) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let uploadedImageNames):
                    draftModelData.selectedImageNames = uploadedImageNames
                    postRecipe()
                case .failure(let error):
                    showLoadingOverlay = false // End loading on error
                    print("Image upload failed: \(error.localizedDescription)")
                    recipeVM.showError = true
                    recipeVM.errorMessage = "Failed to upload images."
                }
            }
        }
    }
    
    
    
    // MARK: Post Recipe
    private func postRecipe() {
        if let foodRecipeRequest = draftModelData.toFoodRecipeRequest() {
            FoodRecipeService.shared.saveFoodRecipe(foodRecipeRequest) { result in
                DispatchQueue.main.async {
                    self.showLoadingOverlay = false
                    switch result {
                    case .success(let response):
                        if let foodRecipeId = response.payload?.id {
                            if draftModelData.isForSale {
                                postFoodSell(foodRecipeId: foodRecipeId)
                            } else {
                                showSuccessPopup = true
                                draftModelData.clearDraft(from: modelContext)
                            }
                        }
                        dismissToRoot()
                    case .failure(let error):
                        print("Failed to create food recipe: \(error.localizedDescription)")
                        recipeVM.showError = true
                        recipeVM.errorMessage = "Failed to post food recipe."
                    }
                }
            }
        }
    }
    
    // MARK: Post Food Sell
    private func postFoodSell(foodRecipeId: Int) {
        if let foodSellRequest = draftModelData.toFoodSellRequest() {
            let currencyType = draftModelData.price > 1000 ? "RIEL" : "DOLLAR"
            FoodSellService.shared.postFoodSell(foodSellRequest, foodRecipeId: foodRecipeId, currencyType: currencyType) { result in
                DispatchQueue.main.async {
                    showLoadingOverlay = false // End loading on success or error
                    switch result {
                    case .success:
                        showSuccessPopup = true
                        draftModelData.clearDraft(from: modelContext)
                        dismissToRoot()
                    case .failure(let error):
                        print("Failed to create food sell: \(error.localizedDescription)")
                        recipeVM.showError = true
                        recipeVM.errorMessage = "Failed to post food for sale."
                    }
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
        if draftModelData.isForSale {
            showError = draftModelData.amount <= 0 ||
            draftModelData.price <= 0 ||
            addressStore.selectedAddress == nil ||
            draftModelData.location.isEmpty ||
            draftModelData.cookDate < Date()
        } else {
            showError = false
        }
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

