import SwiftUI

struct FoodDetailView: View {
    @State private var bottomSheetShown = false
    @State private var isFavorite: Bool = false
    @State private var currentImage: String // State variable to track the currently selected main image
    var theMainImage: String
    var subImage1: String
    var subImage2: String
    var subImage3: String
    var subImage4: String
    var frameheight: CGFloat
    var offsetHeight: CGFloat
    var offsetWidth: CGFloat

    // Reference height for BottomSheetView
    private let maxSheetHeight: CGFloat = 600
    
    init(theMainImage: String, subImage1: String, subImage2: String, subImage3: String, subImage4: String, frameheight: CGFloat, offsetHeight: CGFloat, offsetWidth: CGFloat) {
        self.theMainImage = theMainImage
        self.subImage1 = subImage1
        self.subImage2 = subImage2
        self.subImage3 = subImage3
        self.subImage4 = subImage4
        self.frameheight = frameheight
        self.offsetHeight = offsetHeight
        self.offsetWidth = offsetWidth
        _currentImage = State(initialValue: theMainImage)
    }
    
    var body: some View {
        ZStack {
            // Main Food Detail Content
            VStack {
                Image(currentImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: frameheight)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
                    .overlay(
                        Button(action: {
                            isFavorite.toggle()
                        }) {
                            Circle()
                                .fill(isFavorite ? Color(hex: "#FE724C") : Color.white.opacity(0.5))
                                .frame(width: 25, height: 25)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                )
                        }
                            .offset(x: offsetWidth, y: offsetHeight)
                            .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 11)
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 200, height: 53)
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
                                    .frame(width: 41, height: 41)
                                    .cornerRadius(7)
                                }
                            )
                            .offset(y: 35)
                    )
                Spacer()
            }

            // Bottom Sheet Content
//            BottomSheetView(isOpen: $bottomSheetShown, maxHeight: maxSheetHeight) {
//                VStack(alignment: .leading) {
//                    Text("Food Details")
//                        .font(.headline)
//                    Text("Here you can show more detailed information about the food, reviews, or any additional content you wish to display in the bottom sheet.")
//                    
//                    Button(action: {
//                        // Example button action
//                    }) {
//                        Text("Order Now")
//                            .foregroundColor(.orange)
//                            .bold()
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.orange, lineWidth: 2)
//                            )
//                    }
//                }
//                .padding()
//            }
            .edgesIgnoringSafeArea(.all)
        }
        .onTapGesture {
            withAnimation {
                bottomSheetShown.toggle()
            }
        }
    }
}

#Preview {
    FoodDetailView(theMainImage: "Songvak", subImage1: "ahmok", subImage2: "brohok", subImage3: "SomlorKari", subImage4: "Songvak", frameheight: 270, offsetHeight: -150, offsetWidth: 150)
}
