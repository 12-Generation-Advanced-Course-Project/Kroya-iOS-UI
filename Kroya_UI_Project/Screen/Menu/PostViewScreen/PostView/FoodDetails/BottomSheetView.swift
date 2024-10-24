import SwiftUI

struct FoodDetailView: View {
    @State private var isFavorite: Bool = false
    @State private var currentImage: String
    @State private var showBottomSheet = true // State to control the sheet

    var theMainImage: String
    var subImage1: String
    var subImage2: String
    var subImage3: String
    var subImage4: String
    @Environment(\.dismiss) var dismiss

    init(theMainImage: String, subImage1: String, subImage2: String, subImage3: String, subImage4: String) {
        self.theMainImage = theMainImage
        self.subImage1 = subImage1
        self.subImage2 = subImage2
        self.subImage3 = subImage3
        self.subImage4 = subImage4
        _currentImage = State(initialValue: theMainImage)
    }

    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let screenWidth = geometry.size.width
            let frameHeight = screenHeight * 0.4
            
            ZStack {
                // Main Food Detail Content
                VStack {
                    Image(currentImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth, height: frameHeight)
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                        .overlay {
                            HStack {
                                Button(action: {
                                    dismiss()
                                }) {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: screenWidth * 0.08, height: screenHeight * 0.08)
                                        .overlay(
                                            Image(systemName: "arrow.left")
                                                .foregroundColor(.black)
                                                .font(.system(size: 17))
                                        )
                                }
                                Spacer()
                                Button(action: {
                                    isFavorite.toggle()
                                }) {
                                    Circle()
                                        .fill(isFavorite ? Color(hex: "#FE724C") : Color.white.opacity(0.5))
                                        .frame(width: screenWidth * 0.08, height: screenHeight * 0.08)
                                        .overlay(
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                        )
                                }
                                .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
                            }
                            .offset(y: -screenHeight * 0.2)
                            .padding(.horizontal, screenWidth * 0.04)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 11)
                                .fill(Color.white.opacity(0.5))
                                .frame(width: screenWidth * 0.55, height: screenHeight * 0.069)
                                .overlay(
                                    HStack(spacing: 5) {
                                        Group {
                                            Image(subImage1)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage1
                                                }
                                            Image(subImage2)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage2
                                                }
                                            Image(subImage3)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage3
                                                }
                                            Image(subImage4)
                                                .resizable()
                                                .onTapGesture {
                                                    currentImage = subImage4
                                                }
                                        }
                                        .frame(width: screenWidth * 0.12, height: screenWidth * 0.11)
                                        .cornerRadius(7)
                                    }
                                )
                                .offset(y: screenHeight * 0.04)
                        )
                    Spacer()

                    // Button to show the native bottom sheet
                    Button("Show More Details") {
                        showBottomSheet.toggle()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        // Native sheet modifier
        .sheet(isPresented: $showBottomSheet) {
            // Content for the sheet
            VStack(spacing: 20) {
                Text("More Details")
                    .font(.title)
                    .bold()

                Text("Ingredients and additional details about the food will be displayed here.")
                    .multilineTextAlignment(.center)
                    .padding()

//                Button("Close") {
//                    showBottomSheet.toggle()
//                }
//                .padding()
//                .background(Color.red)
//                .foregroundColor(.white)
//                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            //.presentationDetents([ .fraction(0.8), .height(550)]) // Sheet size options
            .presentationDetents([.medium, .large])
                            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
    }
}

#Preview {
    FoodDetailView(
        theMainImage: "Songvak",
        subImage1: "ahmok",
        subImage2: "brohok",
        subImage3: "SomlorKari",
        subImage4: "Songvak"
    )
}
