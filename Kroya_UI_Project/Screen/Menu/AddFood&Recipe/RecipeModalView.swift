import SwiftUI

struct RecipeModalView: View {
    @State private var draggedIngredient: RecipeIngredient?
    @State private var draggedStep: CookingStep?
    @Environment(\.dismiss) var dismiss
    let dismissToRoot: () -> Void
    @State private var navigateToNextView: Bool = false
    @State private var showValidationError: Bool = false
    @State private var ingret = SaleIngredient(cookDate: "", amount: 0, price: "", location: "", selectedCurrency: 1)
    @StateObject private var keyboardObserver = KeyboardObserver()
    @ObservedObject var addressVM: AddressViewModel
    @ObservedObject var draftModel: DraftModel
    @State var showDraftAlert: Bool = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    // Ingredients Section
                    Text("Ingredients")
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundColor(.black.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if draftModel.ingredients.isEmpty {
                        Text("No ingredients added yet. Please add some ingredients.")
                            .font(.customfont(.regular, fontSize: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(PrimaryColor.normal)
                            .padding(.top, 20)
                    } else {
                        ForEach($draftModel.ingredients, id: \.id) { $ingredient in
                            IngredientEntryView(
                                ingredient: $ingredient,
                                onEdit: {
                                    print("Editing \(ingredient.name)")
                                },
                                onDelete: {
                                    deleteIngredient(ingredient)
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .contentShape(RoundedRectangle(cornerRadius: 12))
                            .onDrag {
                                self.draggedIngredient = ingredient
                                let provider = NSItemProvider(object: ingredient.name as NSString)
                                provider.suggestedName = ""
                                return provider
                            } preview: {
                                Color.clear.frame(width: 1, height: 1)
                            }
                            .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: ingredient, ingredients: $draftModel.ingredients, draggedItem: $draggedIngredient))
                        }
                    }
                    
                    // Button to add new ingredient
                    Button(action: {
                        addNewIngredient()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(PrimaryColor.normal)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Steps Section
                    Text("Steps")
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundColor(.black.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if draftModel.cookingSteps.isEmpty {
                        Text("Please add some steps to your recipe.")
                            .font(.customfont(.regular, fontSize: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(PrimaryColor.normal)
                            .padding(.top, 20)
                    } else {
                        ForEach($draftModel.cookingSteps) { $step in
                            StepEntryView(
                                cookingStep: $step,
                                index: draftModel.cookingSteps.firstIndex(where: { $0.id == step.id }) ?? 0,
                                onDelete: {
                                    deleteStep(step)
                                }
                            )
                            .onDrag {
                                self.draggedStep = step
                                return NSItemProvider()
                            } preview: {
                                Color.clear.frame(width: 1, height: 1)
                            }
                            .onDrop(of: [.text], delegate: StepDropDelegate(destinationItem: step, steps: $draftModel.cookingSteps, draggedItem: $draggedStep))
                        }
                    }
                    
                    // Button to add new step
                    Button(action: {
                        addNewStep()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(PrimaryColor.normal)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            
            // Global validation error message
            if showValidationError {
                Text("Please fill in all required fields before proceeding.")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom, 10)
            }
            
            // Back and Next Buttons
            HStack(spacing: 10) {
                Button(action: { dismiss() }) {
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
                    validateAndProceed()
                }) {
                    Text("Next")
                        .font(.customfont(.semibold, fontSize: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(allFieldsFilled ? .yellow : .gray.opacity(0.3))
                        )
                        .foregroundColor(.white)
                }
                .disabled(!allFieldsFilled)
            }
            .padding(.horizontal, 20)
            .edgesIgnoringSafeArea(.bottom)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: SaleModalView(
                        dismissToRoot: dismissToRoot,
                        ingret: $ingret,
                        totalRiels: calculateTotal(ingredients: draftModel.ingredients).totalRiels,
                        totalUSD: calculateTotal(ingredients: draftModel.ingredients).totalUSD,
                        addressStore: addressVM,
                        draftModel: draftModel
                    )
                ) {
                    Text("Skip")
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
        .alert(isPresented: $showDraftAlert) {
            Alert(
                title: Text("Save this as a draft?"),
                message: Text("If you choose discard post, you'll lose this post that can't edit again."),
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
        .background(
            NavigationLink(
                destination: SaleModalView(
                    dismissToRoot: dismissToRoot,
                    ingret: $ingret,
                    totalRiels: calculateTotal(ingredients: draftModel.ingredients).totalRiels,
                    totalUSD: calculateTotal(ingredients: draftModel.ingredients).totalUSD,
                    addressStore: addressVM,
                    draftModel: draftModel
                ),
                isActive: $navigateToNextView
            ) {
                EmptyView()
            }
        )
    }
    
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
        // Save draft data logic if required
    }
    
    // MARK: Helper function to add a new ingredient
    private func addNewIngredient() {
        let newIngredient = RecipeIngredient(id: UUID().hashValue, name: "", quantity: 0, price: 0, selectedCurrency: 0)
        draftModel.ingredients.append(newIngredient)
    }

    // MARK: Helper function to add a new step
    private func addNewStep() {
        let newStep = CookingStep(id: UUID().hashValue, description: "")
        draftModel.cookingSteps.append(newStep)
    }

    // MARK: Helper function to delete an ingredient safely
    private func deleteIngredient(_ ingredient: RecipeIngredient) {
        if let index = draftModel.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            guard index < draftModel.ingredients.count else { return }
            draftModel.ingredients.remove(at: index)
        }
    }

    // MARK: Helper function to delete a step safely
    private func deleteStep(_ step: CookingStep) {
        if let index = draftModel.cookingSteps.firstIndex(where: { $0.id == step.id }) {
            guard index < draftModel.cookingSteps.count else { return }
            draftModel.cookingSteps.remove(at: index)
        }
    }

    
    // MARK: Computed property to check if all fields are filled
    private var allFieldsFilled: Bool {
        draftModel.ingredients.allSatisfy { !$0.name.isEmpty && $0.quantity != 0 && $0.price != 0 } &&
        draftModel.cookingSteps.allSatisfy { !$0.description.isEmpty }
    }
    
    //MARK: Validation function to check if all fields are filled before allowing navigation
    private func validateAndProceed() {
        if allFieldsFilled {
            navigateToNextView = true
            showValidationError = false
        } else {
            showValidationError = true
        }
    }
    
    //MARK: Function to calculate the total in Riels and USD across all ingredients
    private func calculateTotal(ingredients: [RecipeIngredient]) -> (totalRiels: Double, totalUSD: Double) {
        let conversionRate = 4100.0
        var totalRiels: Double = 0.0
        var totalUSD: Double = 0.0
        
        for ingredient in ingredients {
            let totalForIngredient = ingredient.price * (ingredient.quantity)
            if ingredient.selectedCurrency == 0 {
                totalRiels += totalForIngredient
                totalUSD += totalForIngredient / conversionRate
            } else {
                totalUSD += totalForIngredient
                totalRiels += totalForIngredient * conversionRate
            }
        }
        return (totalRiels, totalUSD)
    }
}

