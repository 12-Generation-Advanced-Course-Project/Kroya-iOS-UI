import SwiftUI

struct FoodDetailView: View {
    @State private var isFavorite: Bool = false
    @State private var currentImage: String // State variable to track the currently selected main image
    var theMainImage: String
    var subImage1: String
    var subImage2: String
    var subImage3: String
    var subImage4: String
    @Environment(\.dismiss) var dismiss
    // Reference height for BottomSheetView
    private let maxSheetHeight: CGFloat = 600
    
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
            let frameHeight = screenHeight * 0.4 // Use 40% of screen height for the main image height
            let frameWidth = screenWidth * 1
            let offsetHeight = .screenHeight * -(0.19) // Adjust overlay offset
            let offsetWidth = screenWidth * 0.38 // Adjust overlay offset width
            
            ZStack {
                // Main Food Detail Content
                VStack {
                    Image(currentImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: frameWidth, height: frameHeight) // Dynamically set height
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                        .overlay(
                            RoundedRectangle(cornerRadius: 11)
                                .fill(Color.white.opacity(0.5))
                                .frame(width: screenWidth * 0.5, height: 53) // Adjust width dynamically
                                .overlay(
                                    HStack(spacing: 7) {
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
                                        .frame(width: screenWidth * 0.1, height: screenWidth * 0.1) // Adjust image size
                                        .cornerRadius(7)
                                    }
                                )
                                .offset(y: 35)
                        )
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Circle()
                            .fill(.white)
                            .frame(width: 25, height: 25)
                            .padding(10)
                            .overlay(
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                            )
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Circle()
                            .fill(isFavorite ? Color(hex: "#FE724C") : Color.white.opacity(0.5))
                            .frame(width: 25, height: 25)
                            .padding(15)
                            .overlay(
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            )
                    }
                    .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)

                }
            }
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
