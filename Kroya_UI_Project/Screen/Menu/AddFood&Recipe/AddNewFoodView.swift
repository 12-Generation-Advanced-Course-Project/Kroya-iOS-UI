

import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) var dismiss
    @State var Foodname: String = ""
    @State var Description: String = ""
    @State var DurationValure: Double = 50
    @State private var selectedLevel: Int? = nil
    @State private var selectedCuisines: Int? = nil
    @State private var selectedCategories: Int? = nil
    @State private var isChecked: Bool = false
    
    var levels: [String] = ["Hard", "Medium", "Easy"]
    var cuisines: [String] = ["Soup", "Salad", "Dessert", "Grill"]
    var categories: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Spacer().frame(height: 15)
                    
                    // Add Photo Button
                    Button(action: {
                        // Add photo action
                    }) {
                        VStack {
                            Image("addphoto")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 46, height: 46)
                            Spacer().frame(height: 10)
                            Text("Add dishes Photo")
                                .font(.customfont(.bold, fontSize: 15))
                                .foregroundStyle(.black.opacity(0.5))
                            Text("(up to 12 Mb)")
                                .font(.customfont(.medium, fontSize: 12))
                                .foregroundStyle(.black.opacity(0.5))
                        }
                        .frame(width: .screenWidth * 0.9, height: .screenHeight * 0.2)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    Color(hex: "#D0DBEA"),
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        dash: [10, 5]
                                    )
                                )
                        )
                    }
                    
                    // Food Name Section
                    VStack(alignment: .leading) {
                        Text("Food Name")
                            .font(.customfont(.bold, fontSize: 16))
                        Spacer().frame(height: 15)
                        InputField(placeholder: "Enter your name", text: $Foodname, backgroundColor: .white, frameWidth: .screenWidth * 0.9, colorBorder: Color(hex: "#D0DBEA"),isMultiline: false)
                    }
                    Spacer().frame(height: 15)
                    
                    // Description Section
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.customfont(.bold, fontSize: 16))
                        Spacer().frame(height: 15)
                        InputField(placeholder: "Tell me a little about your food", text: $Description, backgroundColor: .white, frameHeight: .screenHeight * 0.2, frameWidth: .screenWidth * 0.9, colorBorder: Color(hex: "#D0DBEA"),isMultiline: true)
                    }
                    Spacer().frame(height: 15)
                    
                    // Duration Section
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .font(.customfont(.bold, fontSize: 16))
                            .padding(.leading,.screenWidth * 0.05)
                        Spacer().frame(height: 15)
                        HStack {
                            Text("<5")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(PrimaryColor.normal)
                            Spacer()
                            Text("50")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(PrimaryColor.normal)
                            Spacer()
                            Text(">100")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(PrimaryColor.normal)
                        }.padding(.horizontal, 20)
                        
                        Slider(value: $DurationValure, in: 0...100, step: 1)
                            .accentColor(PrimaryColor.normal)
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                print(DurationValure)
                            }
                    }
                    
                    // Level, Cuisines, and Category Sections
                    VStack(alignment: .leading) {
                        Text(" Level")
                            .font(.customfont(.bold, fontSize: 15))
                            .padding(.leading,.screenWidth * 0.02)
                        Spacer().frame(height: 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<levels.count, id: \.self) { index in
                                    ChipCheckView(text: levels[index], isSelected: selectedLevel == index) {
                                        selectedLevel = selectedLevel == index ? nil : index
                                    }
                                }
                            }.padding(.leading,.screenWidth * 0.02)
                        }
                        Spacer().frame(height: 20)
                        Text("Cuisines")
                            .font(.customfont(.bold, fontSize: 15))
                            .padding(.leading,.screenWidth * 0.02)
                        Spacer().frame(height: 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<cuisines.count, id: \.self) { index in
                                    ChipCheckView(text: cuisines[index], isSelected: selectedCuisines == index) {
                                        selectedCuisines = selectedCuisines == index ? nil : index
                                    }
                                }
                            }.padding(.leading,.screenWidth * 0.02)
                        }
                        Spacer().frame(height: 20)
                        Text("Category")
                            .font(.customfont(.bold, fontSize: 15))
                            .padding(.leading,.screenWidth * 0.02)
                        Spacer().frame(height: 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<categories.count, id: \.self) { index in
                                    ChipCheckView(text: categories[index], isSelected: selectedCategories == index) {
                                        selectedCategories = selectedCategories == index ? nil : index
                                    }
                                }
                            }.padding(.leading,.screenWidth * 0.02)
                        }
                    }.padding(.leading,.screenWidth * 0.02)
                    
                    Spacer().frame(height: 35)
                    //Next
                    NavigationLink(destination: RecipeModalView(), label: {
                        Text("Next")
                            .font(.customfont(.semibold, fontSize: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    )
                    
                }
                .navigationTitle("Your dishes")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                dismiss()
                            }
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
    }
}

#Preview {
    AddFoodView()
}

