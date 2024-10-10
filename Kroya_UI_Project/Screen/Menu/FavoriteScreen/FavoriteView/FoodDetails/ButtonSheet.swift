import SwiftUI

struct BottomSheetView<Content: View>: View {
    let content: Content
    @Binding var isOpen: Bool
    let maxHeight: CGFloat
    let minHeight: CGFloat
    
    @GestureState private var translation: CGFloat = 0
    
    // Calculate the default offset as 2/3 of the screen height
    private var defaultHeight: CGFloat {
        UIScreen.main.bounds.height * 2 / 3
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - defaultHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray)
            .frame(width: 40, height: 5)
            .padding(10)
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isOpen = isOpen
        self.maxHeight = maxHeight
        self.minHeight = 500 // Minimum height when the sheet is collapsed
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: isOpen)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * 0.25
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

struct ContentView: View {
    @State private var isBottomSheetOpen: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                FoodDetailView(theMainImage: "Songvak", subImage1: "Songvak", subImage2: "Songvak", subImage3: "Songvak", subImage4: "Songvak", frameheight: 270, offsetHeight: -90, offsetWidth: 150)
                Spacer()
            }
            .blur(radius: isBottomSheetOpen ? 5 : 0)
            
            // Bottom Sheet Content
            BottomSheetView(isOpen: $isBottomSheetOpen, maxHeight: 900) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Somlor Mju")
                            .font(.title)
                            .bold()
                        Text("$3.05 • 5 May 2023 • Morning • 60 mins")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        // Recipe description
                        Text("Description")
                            .font(.headline)
                        Text("Your recipe has been uploaded. You can see it on your profile. Your recipe has been uploaded. You can see it on your profile.")

                        // Ingredients
                        Text("Ingredients")
                            .font(.headline)
                        VStack(alignment: .leading) {
                            Text("• 4 Eggs")
                            Text("• 1/2 Butter")
                        }

                        // Steps
                        Text("Steps")
                            .font(.headline)
                        VStack(alignment: .leading) {
                            Text("1. Your recipe has been uploaded. You can see it on your profile.")
                            Text("2. Your recipe has been uploaded. You can see it on your profile.")
                        }

                        // Ratings & Reviews section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Ratings & Review")
                                .font(.headline)
                            
                            HStack {
                                Text("4.8")
                                    .font(.largeTitle)
                                    .bold()
                                Spacer()
                                VStack {
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { star in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    Text("2346 Ratings")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }

                            // User review
                            HStack {
                                Text("A very good recipe")
                                    .font(.headline)
                                Spacer()
                                Text("5 stars")
                                    .font(.caption)
                            }
                            Text("Your recipe has been uploaded. You can see it on your profile. Your recipe has been uploaded.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.top)

                        // Write a review button
                        Button(action: {
                            // Action for writing a review
                        }) {
                            Text("Write a Review")
                                .foregroundColor(.orange)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.orange, lineWidth: 2)
                                )
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
          .edgesIgnoringSafeArea(.all)
        }
        .onTapGesture {
            withAnimation {
                isBottomSheetOpen.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
