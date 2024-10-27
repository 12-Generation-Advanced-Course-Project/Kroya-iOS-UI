import SwiftUI

struct BottomSheetView<Content: View>: View {
    let content: Content
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var isFullyExpanded: Bool {
        isOpen && translation == 0
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "#D0DBEA"))
            .frame(width: 40, height: 5)
            .padding(.top, 10)
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isOpen = isOpen
        self.maxHeight = maxHeight
        self.minHeight = minHeight
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator
                self.content
                    .padding(.top, 20)
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .offset(y: max(self.offset + self.translation, 0))
            .gesture(
                DragGesture()
                    .updating(self.$translation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let snapDistance = self.maxHeight * 0.25
                        if value.translation.height > snapDistance {
                            self.isOpen = false
                        } else if value.translation.height < -snapDistance {
                            self.isOpen = true
                        }
                    }
            )
        }
    }
}

struct FoodDetailView: View {
    @State private var isFavorite: Bool = false
    @State private var currentImage: String
    @State private var isBottomSheetOpen: Bool = false
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
                                        .frame(width: screenWidth * 0.07, height: screenHeight * 0.07)
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
                                        .frame(width: screenWidth * 0.07, height: screenHeight * 0.07)
                                        .overlay(
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.white)
                                                .font(.system(size: 18))
                                        )
                                }
                                .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
                            }
                            .offset(y: -screenHeight * 0.2)
                            .padding(.horizontal, screenWidth * 0.045)
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
                }
                
                // Blur background when the sheet is fully expanded
                if isBottomSheetOpen {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .blur(radius: isBottomSheetOpen ? 10 : 0)
                }

                // Bottom Sheet Content
                BottomSheetView(isOpen: $isBottomSheetOpen, maxHeight: .screenHeight * 1, minHeight: .screenHeight * 0.74) {
                    List {
                        TittleView()
                            .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.4)
                        StepView()
                            .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.1, maxHeight: .screenHeight * 0.9)
                        RatingView()
                            .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.135)
                        Review()
                            .frame(maxWidth: .infinity, minHeight: .screenHeight * 0.4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listStyle(PlainListStyle())
                    .listRowSeparator(.hidden)
                }
            }
            .navigationBarBackButtonHidden(true)
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
