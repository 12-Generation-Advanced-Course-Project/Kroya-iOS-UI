//
//
import SwiftUI

struct AddFoodView: View {
    @Binding var rootIsActive1 : Bool
    @Environment(\.dismiss) var dismiss
    @State var Foodname: String = ""
    @State var Description: String = ""
    @State private var DurationValure: Double = 5
    @State private var selectedLevel: Int? = nil
    @State private var selectedCuisines: Int? = nil
    @State private var selectedCategories: Int? = nil
    @State private var isChecked: Bool = false
    @State private var isImagePickerPresented = false
    @State private var selectedImages: [UIImage] = []
    @State private var showValidationMessage: Bool = false
    @State private var navigateToNextView: Bool = false
    let dismissToRoot: () -> Void // Closure for dismissing to root
    var levels: [String] = ["Hard", "Medium", "Easy"]
    var cuisines: [String] = ["Soup", "Salad", "Dessert", "Grill"]
    var categories: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical,showsIndicators: false) {
                VStack {
                    Spacer().frame(height: 15)
                    
                    // Image selection and display
                    VStack {
                        VStack {
                            // Show selected images if available
                            if !selectedImages.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(selectedImages, id: \.self) { image in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(10)
                                                    .padding(5)
                                                
                                                // "X" button to delete image
                                                Button(action: {
                                                    if let index = selectedImages.firstIndex(of: image) {
                                                        selectedImages.remove(at: index)
                                                    }
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .background(Color.white)
                                                        .clipShape(Circle())
                                                        .foregroundColor(.red)
                                                        .offset(x: -5, y: -5)
                                                }
                                            }
                                        }
                                        VStack{
                                            Image(systemName: "plus")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(PrimaryColor.normal)
                                                .clipShape(Circle())
                                                .onTapGesture{
                                                    isImagePickerPresented.toggle()
                                                }
                                            
                                        }.frame(width: 100, height: 100)
                                            .cornerRadius(16)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(
                                                        Color(PrimaryColor.normal),
                                                        style: StrokeStyle(
                                                            lineWidth: 2,
                                                            dash: [10, 5]
                                                        )
                                                    )
                                            )
                                        
                                    }
                                    .padding()
                                    
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                Image("addphoto")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 46, height: 46)
                                    .onTapGesture{
                                        isImagePickerPresented.toggle()
                                    }
                                Spacer().frame(height: 10)
                                Text("Add dishes Photo")
                                    .font(.customfont(.bold, fontSize: 15))
                                    .foregroundStyle(.black.opacity(0.5))
                                Text("(up to 12 Mb)")
                                    .font(.customfont(.medium, fontSize: 12))
                                    .foregroundStyle(.black.opacity(0.5))
                            }
                        }
                        .frame(maxWidth: .screenWidth * 0.89, minHeight: .screenHeight * 0.2)
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
                        // If validation fails, show error message
                        if showValidationMessage && selectedImages.isEmpty {
                            HStack{
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Please add an image of the dish.")
                                    .font(.customfont(.medium, fontSize: 12))
                                    .foregroundColor(.red)
                                    .padding(.top, 5)
                            }.frame(maxWidth: .infinity,alignment: .leading)
                                .padding(.horizontal)
                            
                        }
                    }
                    
                    
                    Spacer().frame(height: 15)
                    VStack(alignment: .leading) {
                        Text("Food Name")
                            .font(.customfont(.bold, fontSize: 16))
                        
                        Spacer().frame(height: 15)
                        
                        // InputField for food name
                        InputField(placeholder: "Enter your name", text: $Foodname, backgroundColor: .white, frameWidth: .screenWidth * 0.9, colorBorder: Color(hex: "#D0DBEA"), isMultiline: false)
                        
                        // Validation message under TextField
                        if showValidationMessage && Foodname.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Food name cannot be empty")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        Spacer().frame(height: 15)
                    }
                    
                    
                    Spacer().frame(height: 15)
                    
                    // Description Section
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.customfont(.bold, fontSize: 16))
                        Spacer().frame(height: 15)
                        
                        TextField("Tell me a little about your food", text: $Description, axis: .vertical)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .frame(maxWidth: .screenWidth * 0.9,minHeight: 150, alignment: .topLeading)
                            .font(.customfont(.medium, fontSize: 15))
                            .foregroundStyle(.black.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                            )
                        // Validation message under TextField
                        if showValidationMessage && Description.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Description cannot be empty")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    Spacer().frame(height: 15)
                    
                    // Duration Section
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .font(.customfont(.bold, fontSize: 16))
                            .padding(.leading, .screenWidth * 0.05)
                        Spacer().frame(height: 15)
                        HStack {
                            Text("<5")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(DurationValure < 5 ? PrimaryColor.light : PrimaryColor.normal)
                            Spacer()
                            Text("\(Int(DurationValure))")  // Dynamically updating text
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(PrimaryColor.normal)
                            Spacer()
                            Text(">100")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(DurationValure > 100 ? PrimaryColor.light : PrimaryColor.normal)
                        }.padding(.horizontal, 20)
                        
                        Slider(value: $DurationValure, in: 0...100, step: 1)
                            .accentColor(PrimaryColor.normal)
                            .padding(.horizontal, 20)
                            .onChange(of: DurationValure) {
                                print(DurationValure)
                            }
                    }
                    
                    // Level, Cuisines, and Category Sections
                    VStack(alignment: .leading) {
                        Text("Level")
                            .font(.customfont(.bold, fontSize: 15))
                            .padding(.leading, .screenWidth * 0.02)
                        Spacer().frame(height: 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<levels.count, id: \.self) { index in
                                    ChipCheckView(text: levels[index], isSelected: selectedLevel == index) {
                                        selectedLevel = selectedLevel == index ? nil : index
                                    }
                                }
                            }.padding(.leading, .screenWidth * 0.02)
                        }
                        
                        Spacer().frame(height: 20)
                        Text("Cuisines")
                            .font(.customfont(.bold, fontSize: 15))
                            .padding(.leading, .screenWidth * 0.02)
                        Spacer().frame(height: 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<cuisines.count, id: \.self) { index in
                                    ChipCheckView(text: cuisines[index], isSelected: selectedCuisines == index) {
                                        selectedCuisines = selectedCuisines == index ? nil : index
                                    }
                                }
                            }.padding(.leading, .screenWidth * 0.02)
                        }
                        
                        Spacer().frame(height: 20)
                        Text("Category")
                            .font(.customfont(.bold, fontSize: 15))
                            .padding(.leading, .screenWidth * 0.02)
                        Spacer().frame(height: 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<categories.count, id: \.self) { index in
                                    ChipCheckView(text: categories[index], isSelected: selectedCategories == index) {
                                        selectedCategories = selectedCategories == index ? nil : index
                                    }
                                }
                            }.padding(.leading, .screenWidth * 0.02)
                        }
                    }.padding(.leading, .screenWidth * 0.02)
                    
                    
                    Spacer().frame(height: 35)
                    
                    Button(action: {

//                        if Foodname.isEmpty || Description.isEmpty {
//                            showValidationMessage = true
//                        } else {
//                            showValidationMessage = false
//                           
//                        }
                        navigateToNextView = true
                    }) {
                        Text("Next")
                            .font(.customfont(.semibold, fontSize: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(PrimaryColor.normal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .navigationTitle("Your dishes")
                .navigationBarBackButtonHidden(true)
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
                }
                .background(
                    NavigationLink(destination: RecipeModalView(dismissToRoot: dismissToRoot), isActive: $navigateToNextView) {
                        EmptyView()
                    }
                )
            }
            .fullScreenCover(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImages: $selectedImages)
            }
        }
    }
}




