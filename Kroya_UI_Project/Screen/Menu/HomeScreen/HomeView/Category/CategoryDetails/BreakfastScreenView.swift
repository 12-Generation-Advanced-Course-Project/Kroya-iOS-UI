//import SwiftUI
//
//struct BreakfastScreenView: View {
//
//    @State private var selectedSegment = 0
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//
//            VStack {
//                // Tab View
//                VStack {
//                    HStack {
//                        Spacer()
//
//                        Text("Food on Sale")
//                            .fontWeight(.semibold)
//                            .font(.customfont(.semibold, fontSize: 16))
//                            .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
//                            .onTapGesture {
//                                selectedSegment = 0
//                            }
//
//                        Spacer()
//
//                        Text("Recipes")
//                            .fontWeight(.semibold)
//                            .font(.customfont(.semibold, fontSize: 16))
//                            .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
//                            .onTapGesture {
//                                selectedSegment = 1
//                            }
//
//                        Spacer()
//                    }
//                    .padding(.top)
//
//                    // Simple Geometry Reader for Underline
//                    GeometryReader { geometry in
//                        Divider()
//
//                        Rectangle()
//                            .fill(PrimaryColor.normal)
//                            .frame(width: selectedSegment == 0 ? geometry.size.width / 3 : geometry.size.width / 4, height: 2)  // Static width for the underline
//                            .offset(x: selectedSegment == 1
//                                    ? geometry.size.width / 1.65
//                                    : geometry.size.width / 6.5)
//                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
//                    }
//                    .frame(height: 2)
//                }
//                .padding(.top, 5)
//
//                // Tab View Content
//                TabView(selection: $selectedSegment) {
//                    FoodSaleView(iselected: selectedSegment)
//                        .tag(0)
//                    RecipeView(iselected: selectedSegment)
//                        .tag(1)
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            }
//            .navigationBarBackButtonHidden(true)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    HStack {
//                        Button(action: {
//                            dismiss()
//                        }) {
//                            Image(systemName: "arrow.left")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                                .foregroundStyle(.black)
//                        }
//                        VStack(alignment: .leading, spacing: 4) {
//                            Spacer()
//                            Text("Breakfast")
//                                .font(.customfont(.semibold, fontSize: 16))
//                                .foregroundStyle(.black.opacity(0.8))
//                            Group {
//                                Text("Please check your ")
//                                    .font(.customfont(.medium, fontSize: 12)) +
//                                Text("breakfast")
//                                    .font(.customfont(.medium, fontSize: 12))
//                                    .foregroundStyle(.yellow)
//                            }
//                            .font(.customfont(.regular, fontSize: 12))
//                            .foregroundStyle(.black.opacity(0.6))
//                        }
//                    }
//                }
//            }
//
//    }
//}
//
//#Preview {
//    BreakfastScreenView()
//}
//


import SwiftUI

struct BreakfastScreenView: View {
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Tab View
            VStack {
                HStack {
                    Spacer()
                    
                    Text(LocalizedStringKey("Food on Sale"))
                        .fontWeight(.semibold)
                        .font(.system(size: 16))  // Replace with your custom font method if you have one
                        .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 0
                        }
                    
                    Spacer()
                    
                    Text(LocalizedStringKey("Recipes"))
                        .fontWeight(.semibold)
                        .font(.system(size: 16))  // Replace with your custom font method if you have one
                        .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            selectedSegment = 1
                        }
                    
                    Spacer()
                }
                .padding(.top)
                
                // Simple Geometry Reader for Underline
                GeometryReader { geometry in
                    Divider()
                    
                    Rectangle()
                        .fill(Color.yellow)  // Replace with `PrimaryColor.normal` if you have it defined
                        .frame(width: selectedSegment == 0 ? geometry.size.width / 3 : geometry.size.width / 4, height: 2)
                        .offset(x: selectedSegment == 1 ? geometry.size.width / 1.65 : geometry.size.width / 6.5)
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                }
                .frame(height: 2)
            }
            .padding(.top, 5)
            
            // Tab View Content
            TabView(selection: $selectedSegment) {
                FoodSaleView(iselected: selectedSegment)  // Make sure FoodSaleView accepts `iselected`
                    .tag(0)
                RecipeView(iselected: selectedSegment)  // Make sure RecipeView accepts `iselected`
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .principal) { // Center the title
                Text(LocalizedStringKey("Food order"))
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center) // Center alignment
            }
        }
        //        .toolbar {
        //            ToolbarItem(placement: .navigationBarLeading) {
        //                HStack {
        //                    Button(action: {
        //                        dismiss()
        //                    }) {
        //                        Image(systemName: "arrow.left")
        //                            .resizable()
        //                            .scaledToFit()
        //                            .frame(width: 20, height: 20)
        //                            .foregroundColor(.black)  // Replace with `foregroundStyle` if desired
        //                    }
        //                    VStack(alignment: .leading, spacing: 4) {
        //                        Spacer()
        //                        Text("Breakfast")
        //                            .font(.system(size: 16))  // Replace with your custom font method if you have one
        //                            .foregroundColor(.black.opacity(0.8))
        //                        Group {
        ////                            Text("Please check your ")
        ////                                .font(.system(size: 12)) +  // Replace with your custom font method if you have one
        ////                            Text("breakfast")
        ////                                .font(.system(size: 12))  // Replace with your custom font method if you have one
        ////                                .foregroundColor(.yellow)
        //                            HStack{
        //                                Text(LocalizedStringKey("Please check your "))
        //                                    .font(.system(size: 12))
        //                                Text(LocalizedStringKey("Breakfast"))
        //                                    .font(.system(size: 12))
        //                                    .foregroundColor(.yellow)
        //                            }
        //                        }
        //                        .font(.system(size: 12))  // Replace with your custom font method if you have one
        //                        .foregroundColor(.black.opacity(0.6))
        //                    }
        //                }
        //            }
        //        }
    }
}

#Preview {
    BreakfastScreenView()
}
