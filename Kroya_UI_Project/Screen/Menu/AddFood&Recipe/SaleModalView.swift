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
    let displayCurrencies = ["៛", "$"]
    let parameterCurrencies = ["RIEL", "DOLLAR"]
    @State private var userInputAddress: String?
    @State private var selectedAddress: Address?
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
    @State private var showAddressSheet = false
    @StateObject private var keyboardResponder = KeyboardResponder()
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
                                                .frame(minWidth: 40, alignment: .leading)
                                            Spacer()
                                            TextField("", text: $formattedDate)
                                                .customFontMediumLocalize(size: 13)
                                                .multilineTextAlignment(.leading)
                                                .foregroundStyle(.gray.opacity(0.8))
                                                .disabled(true)
                                                .frame(maxWidth: .infinity)
                                            
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
                                                            displayedComponents: [.date, .hourAndMinute]
                                                        ) {
                                                            
                                                        }
                                                        .fixedSize()
                                                        .labelsHidden()
                                                        .datePickerStyle(.compact)
                                                        .colorMultiply(.clear)
                                                        .onChange(of: draftModelData.cookDate) { newDate in
                                                            formattedDate = newDate.formatted(.dateTime.day().month().year().hour().minute())
                                                            validateDetailsFields()
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
                                                .foregroundStyle(.black.opacity(0.8))
                                                .frame(maxWidth: 90, alignment: .leading)
                                            TextField("", value: $draftModelData.amount, format: .number)
                                                .customFontMediumLocalize(size: 13)
                                                .multilineTextAlignment(.leading)
                                                .keyboardType(.numberPad)
                                                .foregroundStyle(.gray.opacity(0.8))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .onChange(of: draftModelData.amount) { _ in
                                                    validateDetailsFields()
                                                }

                                        }
                                        .padding(.horizontal)
                                        Divider()
                                        
                                        // Price Input Section
                                        HStack {
                                            Text("Price")
                                                .customFontLightLocalize(size: 16)
                                                .foregroundStyle(.black.opacity(0.8))
                                                .frame(maxWidth: 90, alignment: .leading)
                                            
                                            TextField(getCurrencyPlaceholder(), text: Binding(
                                                get: {
                                                    // Convert price to formatted string for display
                                                    formatPrice(value: draftModelData.price)
                                                },
                                                set: { newValue in
                                                    // Sanitize input and update price
                                                    priceText = filterPriceInput(newValue)
                                                    let price = Double(priceText) ?? 0.0
                                                    ingret.price = price
                                                    draftModelData.price = price
                                                }
                                            ))
                                            .customFontMediumLocalize(size: 13)
                                            .multilineTextAlignment(.leading)
                                            .keyboardType(.decimalPad)
                                            .foregroundStyle(.gray.opacity(0.8))
                                            .onChange(of: draftModelData.price) { _ in
                                                validateDetailsFields()
                                            }

                                            
                                            Picker("", selection: $ingret.selectedCurrency) {
                                                ForEach(0..<displayCurrencies.count) { index in
                                                    Text(displayCurrencies[index])
                                                        .tag(index)
                                                        .customFontMediumLocalize(size: 20)
                                                }
                                            }
                                            .pickerStyle(SegmentedPickerStyle())
                                            .frame(width: 60)
                                            .onChange(of: ingret.selectedCurrency) { newCurrency in
                                                updateCurrencyAndPrice(newCurrency: newCurrency)
                                                // Save draft when currency changes
                                                draftModelData.saveDraft(in: modelContext)
                                            }
                                        }
                                        .padding(.horizontal)

                                        Divider()
                                        HStack {
                                            Text("Location")
                                                .customFontLightLocalize(size: 15)
                                                .foregroundStyle(.black.opacity(0.8))
                                                .frame(maxWidth: 90, alignment: .leading)
                                            
                                            Button {
                                                // Open the address selection sheet
                                                showAddressSheet.toggle()
                                            } label: {
                                                Text(draftModelData.location.isEmpty ? "Choose Location" : draftModelData.location)
                                                    .customFontMediumLocalize(size: 13)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .foregroundStyle(draftModelData.location.isEmpty ? .gray.opacity(0.8) : .gray.opacity(0.8))
                                                    .padding(.vertical, 8)
                                                    .lineLimit(2)
                                                    .onChange(of: draftModelData.location) { _ in
                                                        validateDetailsFields() // Validate fields whenever location changes
                                                    }

                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                        .sheet(isPresented: $showAddressSheet) {
                                            NavigationStack {
                                                AddressView(
                                                    onAddressSelected: { selected in
                                                        // Handle selected address
                                                        selectedAddress = selected
                                                        userInputAddress = selectedAddress?.addressDetail
                                                        draftModelData.location = selectedAddress?.addressDetail ?? ""
                                                        showAddressSheet = false
                                                    },
                                                    isFromEditingProfileView: true
                                                )
                                            }
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)

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
                                                    .customFontLightLocalize(size: 8)
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        Spacer()
                                        VStack {
                                            HStack{
                                                Text("Ingredient ")
                                                    .customFontMediumLocalize(size: 10)
                                                    .foregroundColor(.black.opacity(0.4))
                                                Text("\(totalRiels, specifier: "%.2f") ៛")
                                                    .foregroundStyle(.yellow)
                                                    .customFontMediumLocalize(size: 11)
                                                Text("(\(totalUSD, specifier: "%.2f")$)")
                                                    .customFontMediumLocalize(size: 11)
                                                    .foregroundColor(.black.opacity(0.4))
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            hideKeyboard()
                        }
                    )
                    .padding(.bottom, min(keyboardResponder.currentHeight, 0))
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
                    
                    // Post Button
                    Button(action: {
                        if draftModelData.isForSale {
                            uploadImagesAndPostRecipe()
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
                                    .fill(canPost ? PrimaryColor.normal : Color.gray.opacity(0.3))
                            )
                    }
                    .disabled(!canPost)
                }
                .padding()
            }
            .ignoresSafeArea(.keyboard)
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
            formattedDate = draftModelData.cookDate.formatted(.dateTime.day().month().year())
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
    //MARK: Func for change Currency
    private func updateCurrencyAndPrice(newCurrency: Int) {
        if newCurrency == 1 {
            ingret.price = convertCurrency(ingret.price)
            draftModelData.Currency = "DOLLAR"  // Set to "DOLLAR"
        } else {
            ingret.price = ingret.price * conversionRate
            draftModelData.Currency = "RIEL"  // Set to "RIEL"
        }
        draftModelData.price = ingret.price
        validateFields()
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Specify the desired format
        return formatter.string(from: date)
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
            // Print the request structure
            print("Posting Food Recipe with request data: \(foodRecipeRequest)")
            
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
        } else {
            print("Failed to create FoodRecipeRequest.")
        }
    }

    
    // MARK: Post Food Sell
    private func postFoodSell(foodRecipeId: Int) {
        if let foodSellRequest = draftModelData.toFoodSellRequest() {
            let currencyType = draftModelData.Currency  // Use the mapped currency here
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
                        draftModelData.location.isEmpty || // Validate location
                        draftModelData.cookDate < Date()
        } else {
            showError = false
        }
    }
    private func validateDetailsFields() {
        showError = draftModelData.foodName.isEmpty ||
                    draftModelData.descriptionText.isEmpty ||
                    draftModelData.selectedImages.isEmpty ||
                    draftModelData.selectedLevel == nil ||
                    draftModelData.selectedCuisineId == nil ||
                    draftModelData.selectedCategoryId == nil ||
                    draftModelData.duration <= 0 ||
                    draftModelData.amount <= 0 ||
                    draftModelData.price <= 0 ||
                    draftModelData.location.isEmpty ||
                    draftModelData.cookDate < Date()
    }
    
    private var canPost: Bool {
        !draftModelData.foodName.isEmpty &&                // Food name must be filled
        !draftModelData.descriptionText.isEmpty &&         // Description must be filled
        !draftModelData.selectedImages.isEmpty &&          // At least one image must be selected
        draftModelData.selectedLevel != nil &&             // Level must be selected
        draftModelData.selectedCuisineId != nil &&         // Cuisine ID must be selected
        draftModelData.selectedCategoryId != nil &&        // Category ID must be selected
        draftModelData.duration > 0 &&                     // Duration must be greater than 0
        draftModelData.amount > 0 &&                       // Amount must be greater than 0
        draftModelData.price > 0 &&                        // Price must be greater than 0
        !draftModelData.location.isEmpty &&                // Location must not be empty
        draftModelData.cookDate >= Date()                  // Cook date must not be in the past
    }



    private func getCurrencyPlaceholder() -> String {
        return ingret.selectedCurrency == 0 ? "0" : "0.00"
    }
    
    // MARK: Function to format the price based on currency selection
    private func formatPrice(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = ingret.selectedCurrency == 0 ? 4 : 2
        formatter.groupingSeparator = ingret.selectedCurrency == 1 ? "," : ""
        return formatter.string(from: NSNumber(value: value)) ?? ""
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

