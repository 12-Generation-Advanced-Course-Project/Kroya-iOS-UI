import SwiftUI

struct RecipeModalView: View {
    @State private var draggedIngredient: Ingredient?
    @State private var ingredients: [Ingredient] = [
        Ingredient(name: "Tomato", quantity: "2", price: "1.00", selectedCurrency: 0),
        Ingredient(name: "Onion", quantity: "1", price: "0.50", selectedCurrency: 1),
        Ingredient(name: "Salt", quantity: "2", price: "1.50", selectedCurrency: 1)
    ]
    @State private var newIngredient = Ingredient(name: "", quantity: "", price: "", selectedCurrency: 0)
    
    @Environment(\.dismiss) var dismiss
    
    @State private var steps: [Step] = [Step(description: "Noodle"),
                                        Step(description: "Fried Rice"),
                                        Step(description: "Bread")]
    @State private var draggedStep: Step?
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    // Ingredients Section
                    Text("Ingredients")
                        .font(.customfont(.bold, fontSize: 15))
                        .foregroundColor(.black.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    // Ingredients List with drag-and-drop support
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
                            })
                        .onDrag {
                            self.draggedIngredient = ingredient
                            // Return NSItemProvider but add an empty drag preview to avoid shadow
                            return NSItemProvider(object: ingredient.name as NSString)
                        } preview: {
                            
                            Color.clear.frame(width: 1, height: 1)
                        }
                        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: ingredient, ingredients: $ingredients, draggedItem: $draggedIngredient))
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
                    
                    // Steps List with drag-and-drop support
                    ForEach(steps.indices, id: \.self) { index in
                        StepEntryView(
                            step: $steps[index],
                            index: index, 
                            onEdit: {
                                print("Editing \(steps[index].description)")
                            },
                            onDelete: {
                                steps.remove(at: index)
                            }
                        )
                        .onDrag {
                            self.draggedStep = steps[index]
                            return NSItemProvider()
                        }
                        .onDrop(of: [.text], delegate: StepDropDelegate(destinationItem: steps[index], steps: $steps, draggedItem: $draggedStep))
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
                    
                    // Back and Next Buttons
                    HStack(spacing: 10) {
                        Button(action: {}){
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
                        }){
                            Text("Next")
                                .font(.customfont(.semibold, fontSize: 16))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.yellow)
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EmptyView()) {
                    Text("Skip")
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
    }
}

