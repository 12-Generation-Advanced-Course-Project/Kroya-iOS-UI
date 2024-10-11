import SwiftUI


struct BottomSheetView<Content: View>: View {
    let content: Content
    @Binding var isOpen: Bool
    let maxHeight: CGFloat
    let minHeight: CGFloat
    @GestureState private var translation: CGFloat = 0
    
    // Calculate the default offset as 2/3 of the screen height
    private var defaultHeight: CGFloat {
        UIScreen.main.bounds.height * 7.2 / 10
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
        self.minHeight = 600 // Minimum height when the sheet is collapsed
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
    @State private var isEggChecked = true
    @State private var isButterChecked = true
    @State private var isHalfButterChecked = false
    @State private var count = 0
    var rating: Int
     var maxRating: Int = 5
     var starSize: CGFloat = 60.0
     var activeColor: Color = Color.yellow
     var inactiveColor: Color = Color.gray
     
     private var stars: [Bool] {
         var result = [Bool]()
         for i in 1...maxRating {
             result.append(i <= rating)
         }
         return result
     }
    var body: some View {
        ZStack {
            VStack {
                
               // Call FoodDetailView()
                FoodDetailView(theMainImage: "ahmok", subImage1: "ahmok1", subImage2: "ahmok2", subImage3: "ahmok3", subImage4: "ahmok4", frameheight: 270, offsetHeight: -155, offsetWidth: 150)
                Spacer()
            }
            .blur(radius: isBottomSheetOpen ? 5 : 0)
            
            // Bottom Sheet Content
            BottomSheetView(isOpen: $isBottomSheetOpen, maxHeight: 900) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack{
                            Text("Amok Fish")
                                .font(.system(size: 18))
                                .bold()
                            Spacer()
                            Button(action:{})
                            {
                                Circle()
                                    .fill(Color(hex: "FECC03"))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                          Image(systemName: "plus")
                                              .resizable()
                                              .aspectRatio(contentMode: .fill)
                                              .frame(width: 18, height: 18)
                                              .foregroundStyle(Color.white)
                                              .clipShape(Circle())
                                      )
                                
                            }
                        }
                        
                        HStack(spacing: 10){
                            Group{
                                Text("$3.05")
                                
                                    .foregroundStyle(Color(hex: "FECC03"))
                                
                                Text("5 May 2023") +
                                Text("(Morning)")
                            }.font(.system(size: 13))
                        }
                       
                        HStack(spacing: 10){
                            Text("Soup")
                            Text("60 mins")
                            
                        }.font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex:"9FA5C0"))

                        HStack(spacing: 10){
                            Image("Songvak")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Text("Sreng Sodane")
                                .font(.system(size: 15))
                                .bold()
                        }
                        // Recipe description
                        Text("Description")
                            .font(.headline)
                        Text("Your recipe has been uploaded. You can see it on your profile. Your recipe has been uploaded. You can see it on your profile.")
                        Divider()
                        
                        
                        // Ingredients
                        Text("Ingredients")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 20) {
                          
                            HStack {
                                Circle()
                                    .fill(isHalfButterChecked ?   Color.green.opacity(0.3): Color.clear)
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(isHalfButterChecked ? .green : .clear)
                                    )
                                Text("1/2 Butter")
                                    .font(.body)
                                    .onTapGesture {
                                        isHalfButterChecked.toggle()
                                    }
                            }
                            
                                }
                        
                        Divider()
                        // Steps
                        
                        HStack{
                            Text("Steps")
                                .font(.system(size: 17))
                                .bold()
                            Spacer()
                            Button(action:{})
                            {
                                Circle()
                                    .stroke(Color(hex: "FECC03"), lineWidth: 3)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                          Image(systemName: "arrow.backward.to.line")
                                              .resizable()
                                              .aspectRatio(contentMode: .fill)
                                              .frame(width: 16, height: 16)
                                              .fontWeight(.bold)
                                              .foregroundStyle(Color(hex: "FECC03"))
                                              .clipShape(Circle())
                                      )
                                
                            }
                            Button(action:{})
                            {
                                Circle()
                                    .stroke(Color(hex: "FECC03"), lineWidth: 3)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                          Image(systemName: "arrow.right.to.line")
                                              .resizable()
                                              .aspectRatio(contentMode: .fill)
                                              .frame(width: 16, height: 16)
                                              .fontWeight(.bold)
                                            
                                              .foregroundStyle(Color(hex: "FECC03"))
                                              .clipShape(Circle())
                                      )
                            }
                        }
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(hex: "2E3E5C"))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text("2")
                                        .font(.system(size: 14))
                                          .foregroundStyle(Color.white)
                                          .clipShape(Circle())
                                ).padding(.bottom, 23)
                            Text("Your recipe has been uploaded. You can see it on your profile.")
                        }

                        // Ratings & Reviews section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Ratings & Review")
                                .font(.system(size: 17))
                                .bold()
                            HStack {
                                Text("4.8")
                                    .font(.largeTitle)
                                    .bold()
                                Spacer()
                                VStack {
                                    
                                                                        
            
                                    
//                                                                        ForEach(0..<stars.count, id: \.self) { index in
//                                                                                     Image(systemName: stars[index] ? "star.fill" : "star")
//                                                                                         .resizable()
//                                                                                         .scaledToFit()
//                                                                                         .foregroundColor(stars[index] ? activeColor : inactiveColor)
//                                                                                         .frame(width: starSize, height: starSize)
//                                                                                         .accessibility(label: Text(stars[index] ? "Estrella completa" : "Estrella vacía"))
//                                                                                 }
                                    
                                    Text("2346 Ratings")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            Divider()
                            // User review
                            HStack {
                                Text("Tap to Rate")
                                    .foregroundStyle(Color.gray)
                                Spacer()
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { star in
                                        Image(systemName: "star.fill")
                                        //.frame(width: 30, height: 30)
                                            .foregroundColor(.yellow)
                                        
                                    }
                                }
                            }
                            VStack(alignment: .leading){
                                Text("A very good recipe")
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { star in
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                    }
                                }
                                Text("Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your. Your recipe has been uploaded, you      ")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "F4F5F7"))
                                
                            )
                        }
                        .padding(.top)
                      
                    }
                    .padding()
                    .padding(.bottom)
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
    ContentView(
        
        rating: 1
        
       
    )
}
