import SwiftUI
import SwiftData

struct AddFoodView: View {
    @Binding var rootIsActive1: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var DurationValure: Double = 5
    @State private var selectedLevel: Int? = nil
    @State private var selectedCuisines: Int? = nil
    @State private var selectedCategories: Int? = nil
    @State private var isImagePickerPresented = false
    @State private var showValidationMessage: Bool = false
    @State private var navigateToNextView: Bool = false
    @State private var showDraftAlert = false
    
    let dismissToRoot: () -> Void
    var levels: [String] = ["Hard", "Medium", "Easy"]
    var cuisines: [String] = ["Soup", "Salad", "Dessert", "Grill"]
    var categories: [String] = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    @ObservedObject var addressVM: AddressViewModel
    @ObservedObject var draftModelData: DraftModelData
    @ObservedObject var addNewFoodVM: AddNewFoodVM
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer().frame(height: 15)
                    
                    // Image selection and display
                    VStack {
                        VStack {
                            if !draftModelData.selectedImages.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(draftModelData.selectedImages, id: \.self) { image in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(10)
                                                    .padding(5)
                                                
                                                // "X" button to delete image
                                                Button(action: {
                                                    if let index = draftModelData.selectedImages.firstIndex(of: image) {
                                                        draftModelData.selectedImages.remove(at: index)
                                                    }
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .background(Color.white)
                                                        .clipShape(Circle())
                                                        .foregroundColor(.gray)
                                                        .offset(x: -2, y: -5)
                                                }
                                            }
                                        }
                                        VStack {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(PrimaryColor.normal)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    isImagePickerPresented.toggle()
                                                }
                                        }
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(Color(PrimaryColor.normal),
                                                              style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
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
                                    .onTapGesture {
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
                                .strokeBorder(Color(hex: "#D0DBEA"), style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                        )
                        HStack{
                            if showValidationMessage && draftModelData.selectedImages.isEmpty {
                                validationMessage("Image cannot be empty")
                            }
                        }.frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.horizontal,20)
                    }
                    
                    Spacer().frame(height: 15)
                    VStack(alignment: .leading) {
                        Text("Food Name")
                            .font(.customfont(.bold, fontSize: 16))
                        Spacer().frame(height: 15)
                        InputField(placeholder: "Enter food name", text: $draftModelData.foodName,
                                   backgroundColor: .white, frameHeight: 60,
                                   frameWidth: 0.9 * CGFloat.screenWidth, colorBorder: Color(hex: "#D0DBEA"),
                                   isMultiline: false)
                        if showValidationMessage && draftModelData.foodName.isEmpty {
                            validationMessage("Please enter your food name")
                        }
                    }
                    
                    Spacer().frame(height: 15)
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.customfont(.bold, fontSize: 16))
                        Spacer().frame(height: 15)
                        
                        TextField("Tell me a little about your food", text: $draftModelData.descriptionText, axis: .vertical)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .frame(maxWidth: .screenWidth * 0.9, minHeight: 150, alignment: .topLeading)
                            .font(.customfont(.medium, fontSize: 15))
                            .foregroundStyle(.black.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                            )
                        if showValidationMessage && draftModelData.descriptionText.isEmpty {
                            validationMessage("Please describe your food")
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
                                .foregroundStyle(PrimaryColor.normal)
                            Spacer()
                            Text("\(Int(draftModelData.duration))")
                                  .font(.customfont(.bold, fontSize: 16))
                                  .foregroundStyle(PrimaryColor.normal)
                            Spacer()
                            Text(">100")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(PrimaryColor.normal)
                        }
                        .padding(.horizontal, 20)
                        
                        Slider(value: $draftModelData.duration, in: 0...100, step: 1)
                            .accentColor(PrimaryColor.normal)
                            .padding(.horizontal, 20)
                            .onChange(of: draftModelData.duration) { newValue in
                                
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
                                ForEach(levels, id: \.self) { level in
                                    ChipCheckView(text: level, isSelected: draftModelData.selectedLevel == level) {
                                        draftModelData.selectedLevel = draftModelData.selectedLevel == level ? nil : level
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
                                ForEach(cuisines.indices, id: \.self) { index in
                                    let cuisine = cuisines[index]
                                    ChipCheckView(text: cuisine, isSelected: draftModelData.selectedCuisine == cuisine) {
                                        draftModelData.selectedCuisine = draftModelData.selectedCuisine == cuisine ? nil : cuisine
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
                                ForEach(categories.indices, id: \.self) { index in
                                    let category = categories[index]
                                    ChipCheckView(text: category, isSelected: draftModelData.selectedCategory == category) {
                                        draftModelData.selectedCategory = draftModelData.selectedCategory == category ? nil : category
                                    }
                                }
                            }.padding(.leading, .screenWidth * 0.02)
                        }
                    }
                    .padding(.leading, .screenWidth * 0.02)
                    
                    Spacer().frame(height: 35)
                    Button(action: {
                        if draftModelData.foodName.isEmpty || draftModelData.descriptionText.isEmpty || draftModelData.selectedImages.isEmpty {
                            showValidationMessage = true
                        } else {
                            showValidationMessage = false
                            navigateToNextView = true
                        }
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
                        Button(action: handleCancel) {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black)
                        }
                    }
                }
                .alert(isPresented: $showDraftAlert) {
                    Alert(
                        title: Text("Save this as a draft?"),
                        message: Text("If you choose discard post, you'll lose this post that can't edit again."),
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
                .background(
                    NavigationLink(destination: RecipeModalView(dismissToRoot: dismissToRoot, addressVM: addressVM, draftModelData: draftModelData, addNewFoodVM: addNewFoodVM), isActive: $navigateToNextView) {
                        EmptyView()
                    }
                )
            }
            .fullScreenCover(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImages: $draftModelData.selectedImages)
            }
        }
    }
    
    private var hasDraftData: Bool {
           return !draftModelData.foodName.isEmpty ||
                  !draftModelData.descriptionText.isEmpty ||
                  draftModelData.selectedImages.isEmpty == false ||
                  draftModelData.selectedLevel != nil ||
                  draftModelData.selectedCuisine != nil ||
                  draftModelData.selectedCategory != nil ||
                  draftModelData.duration > 0 ||
                  draftModelData.amount > 0 ||
                  draftModelData.price > 0 ||
                  !draftModelData.location.isEmpty ||
                  draftModelData.isForSale
       }

       private func handleCancel() {
           if hasDraftData {
               showDraftAlert = true
           } else {
               dismiss()
           }
       }
    
    private func validationMessage(_ text: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
            Text(text).foregroundColor(.red).font(.caption)
        }
    }
}

