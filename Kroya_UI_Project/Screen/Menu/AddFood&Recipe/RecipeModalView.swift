//
//  RecipeView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 10/10/24.
//

import SwiftUI
struct RecipeModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var ingredients = [
        Ingredient(name: "Tomato", quantity: "2", price: "1.00", selectedCurrency: 0),
        Ingredient(name: "Onion", quantity: "1", price: "0.50", selectedCurrency: 1),
        Ingredient(name: "Salt", quantity: "2", price: "1.50", selectedCurrency: 1)
    ]
    @State private var colors: [Color] = [.red, .blue, .green,.yellow]
    @State private var steps: [Step] = [Step(description: "")]
    @State private var dragginItem: Color?
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                // Ingredients Section
                Text("Ingredients")
                    .font(.customfont(.bold, fontSize: 15))
                    .padding(.horizontal)
                let Columns = Array(repeating: GridItem(spacing:10), count: 1)
                LazyVGrid(columns: Columns,spacing: 10) {
                    ForEach(ingredients.indices, id: \.self) { index in
                        
//                        GeometryReader{ geometry in
//                            let size = geometry.size
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(color.gradient)
//                               
//                                .draggable(color){
//                                        
//                                }.onAppear{
//                                    dragginItem = color
//                                }
//                                .dropDestination(for: Color.self ){
//                                    item, location in
//                                    return false
//                                }
//                            isTargeted: {
//                                status in
//                                if let dragginItem, status, dragginItem != color{
//                                    if let sourceIndex = colors.firstIndex(of: dragginItem), let destinationIndex = colors.firstIndex(of: color){
//                                        withAnimation(.bouncy){
//                                            let sourceItem = colors.remove(at: sourceIndex)
//                                            colors.insert(sourceItem, at: destinationIndex)
//                                        }
//                                    }
//                                }
//                            }
//                        }
                        IngredientEntryView(ingredient: $ingredients[index])
                    }
                    
                    
                    
                    // Button to add new ingredient
                    Button(action: {
                        
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
                    
                    // Steps Section
                    Text("Steps")
                        .font(.customfont(.bold, fontSize: 15))
                        .padding(.horizontal)
                    
                    // Loop through steps and display each entry
                    ForEach(steps.indices, id: \.self) { index in
                        StepEntryView(step: $steps[index], index: index) // Pass 'index' instead of 'Int'
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
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Recipe")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Back Button
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                    
                    // Skip Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SaleModalView()) {
                            Text("Skip")
                                .foregroundColor(.black.opacity(0.6))
                        }
                    }
                }
            }
        }
    }
}


