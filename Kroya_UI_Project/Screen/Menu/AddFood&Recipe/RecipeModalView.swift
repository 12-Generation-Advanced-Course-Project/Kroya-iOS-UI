import SwiftUI

struct RecipeModalView: View {
    @State private var draggedIngredient: Ingredient?
    @State private var ingredients: [Ingredient] = []
    @State private var newIngredient = Ingredient(name: "", quantity: "", price: "", selectedCurrency: 0)
    @State private var steps: [Step] = []
    @State private var draggedStep: Step?
    @Environment(\.dismiss) var dismiss
    let dismissToRoot: () -> Void
    @State private var navigateToNextView: Bool = false
    @State private var showValidationError: Bool = false
    @State private var ingret = Ingret(cookDate: "", amount: "", price: "", location: "", selectedCurrency: 0)
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    // Ingredients Section
                    Text("Ingredients")
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundColor(.black.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if ingredients.isEmpty {
                        Text("No ingredients added yet. Please add some ingredients.")
                            .font(.customfont(.regular, fontSize: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(PrimaryColor.normal)
                            .padding(.top, 20)
                    } else {
                        ForEach($ingredients) { $ingredient in
                            IngredientEntryView(
                                ingredient: $ingredient,
                                onEdit: {
                                    print("Editing \(ingredient.name)")
                                },
                                onDelete: {
                                    if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                        ingredients.remove(at: index)
                                    }
                                }
                            )
                            .onDrag {
                                self.draggedIngredient = ingredient
                                return NSItemProvider(object: ingredient.name as NSString)
                            }
                            .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: ingredient, ingredients: $ingredients, draggedItem: $draggedIngredient))
                        }
                    }

                    // Button to add new ingredient
                    Button(action: {
                        ingredients.append(newIngredient)
                        newIngredient = Ingredient(name: "", quantity: "", price: "", selectedCurrency: 0)
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
                    
                    if steps.isEmpty {
                        Text("Please add some steps to your recipe.")
                            .font(.customfont(.regular, fontSize: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(PrimaryColor.normal)
                            .padding(.top, 20)
                    } else {
                        ForEach(steps.indices, id: \.self) { index in
                            StepEntryView(
                                step: $steps[index],
                                index: index,
                                onEdit: {
                                    print("Editing \(steps[index].description)")
                                },
                                onDelete: {
                                    if index < steps.count { // Safe deletion check
                                        steps.remove(at: index)
                                    }
                                }
                            )
                            .onDrag {
                                self.draggedStep = steps[index]
                                return NSItemProvider()
                            }
                            .onDrop(of: [.text], delegate: StepDropDelegate(destinationItem: steps[index], steps: $steps, draggedItem: $draggedStep))
                        }
                    }
                    
                    // Button to add new step
                    Button(action: {
                        steps.append(Step(description: ""))
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
                                .fill(allFieldsFilled ? .yellow : .gray.opacity(0.3)) // Yellow if all fields are filled, gray otherwise
                        )
                        .foregroundColor(.white)
                }
                .disabled(!allFieldsFilled) // Disable the button if not all fields are filled

            }
            .padding(.horizontal, 20)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: dismissToRoot) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SaleModalView(dismissToRoot: dismissToRoot, ingret: $ingret)) {
                    Text("Skip")
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
        .background(
            NavigationLink(destination: SaleModalView(dismissToRoot: dismissToRoot, ingret: $ingret), isActive: $navigateToNextView) {
                EmptyView()
            }
        )
    }

    // Computed property to check if all fields are filled
    private var allFieldsFilled: Bool {
        ingredients.allSatisfy { !$0.name.isEmpty && !$0.quantity.isEmpty && !$0.price.isEmpty } &&
        steps.allSatisfy { !$0.description.isEmpty }
    }

    // Validation function to check if all fields are filled before allowing navigation
    private func validateAndProceed() {
        if allFieldsFilled {
            navigateToNextView = true
            showValidationError = false
        } else {
            showValidationError = true
        }
    }
}

