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
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray)
            .frame(width: 40, height: 5)
            .padding(10)
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .offset(y: max(self.offset + self.translation, 0)) // Adjust the sheet's position based on the drag gesture
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }
                    .onEnded { value in
                        let snapDistance = self.maxHeight * 0.25
                        if value.translation.height > snapDistance {
                            // Drag down beyond threshold closes the sheet
                            self.isOpen = false
                        } else if value.translation.height < -snapDistance {
                            // Drag up beyond threshold opens the sheet
                            self.isOpen = true
                        }
                    }
            )
        }
    }
}



struct ContentOnButtonSheet: View {
    @State private var isBottomSheetOpen: Bool = false
    @State private var isEggChecked = true
    @State private var isButterChecked = true
    @State private var isHalfButterChecked = false
    @State private var count = 0
    @State private var currentStep = 1
    @State private var isExpanded = false
    @State private var isReviewExpanded = false
    @State private var isReviewPopupOpen = false
    @Environment(\.dismiss) var dismiss
    
    // Step details
    let steps = [
        "Cut the fish into bite sized pieces and set aside.",
        "Clean and slice the vegetables..",
        "In a large skillet, heat the curry seed oil, amok paste, shrimp paste, and coconut milk. Heat thoroughly, cooking until fragrant."
    ]
    var foodName: String
    var price : Float
    var date : String
    var itemFood : String
    var profile : String
    var userName : String
    var description :String
    var ingredients :String
    var percentageOfRating : Double
    var numberOfRating : Int
    var review :String
    var reviewDetail: String
    var starSize: CGFloat = 60.0
    var activeColor: Color = Color.yellow
    var inactiveColor: Color = Color.gray
    var body: some View {
        ZStack {
            VStack {
                
                // Call FoodDetailView()
                FoodDetailView(theMainImage: "ahmok",
                               subImage1: "ahmok1",
                               subImage2: "ahmok2",
                               subImage3: "ahmok3",
                               subImage4: "ahmok4")
                Spacer()
            }
            .blur(radius: isBottomSheetOpen ? 5 : 0)
            
            // Bottom Sheet Content
            BottomSheetView(isOpen: $isBottomSheetOpen,maxHeight: .screenHeight * 1.00 ,minHeight: .screenHeight * 0.68) {
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 7) {
                        
                        HStack{
                            Text(foodName)
                                .font(.customfont(.bold, fontSize: 20))
                            Spacer()
                            NavigationLink(destination: FoodCheckOutView()) {
                                HStack {
                                    Text("Order")
                                        .font(.customfont(.medium, fontSize: 13))
                                        .foregroundStyle(.white)
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .cornerRadius(12)
                                        .foregroundStyle(Color.white)
                                }
                                .padding(10)
                                .background(PrimaryColor.normal)
                                .cornerRadius(12)
                            }

                        }
                        
                        HStack(spacing: 7){
                            // Group{
                            Text(String(format: "$%.2f", percentageOfRating))
                            
                                .foregroundStyle(Color.yellow)
                                .font(.customfont(.regular, fontSize: 13))
                            Text("\(date)(Morning)")
                                .opacity(0.5)
                            //}
                                .font(.customfont(.regular, fontSize: 13))
                            
                        }.offset(y: -5)
                        
                        HStack(spacing: 10){
                            Text(itemFood)
                            Circle().fill()
                                .frame(width: 6, height: 6)
                            Text("60 mins")
                            
                        }.font(.customfont(.medium, fontSize: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex:"#9FA5C0"))
                        
                        // Profile
                        HStack(spacing: 10){
                            NavigationLink {
                                ViewAccount(profileImage: "Men", userName: userName, email: "ounbonaliheng@gmail.com")
                            } label: {
                                Image("Men")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 38, height: 38)
                                    .clipShape(Circle())
                            }

                            Text(userName)
                                .font(.customfont(.bold, fontSize: 17))
                                .bold()
                        }.padding(.top, 10)
                        
                        // Recipe description
                        Text("Description")
                            .font(.customfont(.bold, fontSize: 18))
                            .padding(.top, 10)
                        Text(description)
                            .font(.customfont(.regular, fontSize: 14))
                            .opacity(0.6)
                            .padding(.bottom, 10)
                        
                        // Ingredients
                        Text("Ingredients")
                            .font(.customfont(.bold, fontSize: 18))
                        VStack(alignment: .leading, spacing: 20) {
                            
                            HStack {
                                Button(action: {}){
                                    Circle()
                                        .fill(isHalfButterChecked ?   Color.green.opacity(0.3): Color.clear)
                                        .stroke(isHalfButterChecked ? Color.clear : Color.gray, lineWidth: 1)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .foregroundColor(isHalfButterChecked ? .green : .clear)
                                        )
                                        .onTapGesture {
                                            isHalfButterChecked.toggle()
                                        }
                                    
                                }
                                Text(ingredients)
                                    .font(.customfont(.regular, fontSize: 16))
                                    .foregroundStyle(Color(hex: "#2E3E5C"))
                                
                            }
                            
                        }.padding([.bottom, .top],5)
                        
                        Divider()
                        
                        //== Steps
                        VStack {
                            HStack {
                                Text("Steps")
                                    .font(.system(size: 17))
                                    .bold()
                                
                                Spacer()
                                
                                // Button to go to the previous step
                                Button(action: {
                                    if currentStep > 1 {
                                        currentStep -= 1
                                    }
                                }) {
                                    Circle()
                                        .stroke(Color(hex: "FECC03"), lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "arrow.backward.to.line")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 15, height: 15)
                                                .foregroundStyle(Color(hex: "FECC03"))
                                                .clipShape(Circle())
                                        )
                                }
                                // Button to go to the next step
                                Button(action: {
                                    if currentStep < steps.count {
                                        currentStep += 1
                                    }
                                }) {
                                    Circle()
                                        .stroke(Color(hex: "FECC03"), lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "arrow.right.to.line")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(Color(hex: "FECC03"))
                                                .clipShape(Circle())
                                        )
                                }
                            }
                            
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(Color(hex: "#2E3E5C"))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Text("\(currentStep)")
                                            .font(.customfont(.bold, fontSize: 14))
                                            .foregroundColor(Color.white)
                                    )
                                    .padding(.bottom, 23)
                                // Display step detail based on the current step
                                Text(steps[currentStep - 1])
                                    .font(.system(size: 16))
                                    .padding(.top, 2)
                                Spacer()
                            }
                        }
                        .padding([.bottom, .top],5)
                        Divider()
                        
                        // Ratings & Reviews section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Ratings & Review")
                                .font(.system(size: 17))
                                .bold()
                            HStack {
                                VStack{
                                    Text(String(format: "%.1f", percentageOfRating))
                                    
                                        .font(.customfont(.bold, fontSize: 34))
                                    Text("out of 5")
                                        .font(.customfont(.semibold, fontSize: 12))
                                    
                                }
                                Spacer()
                                
                                HStack(spacing: 2) {
                                    VStack(alignment: .trailing) {
                                        HStack(spacing: 15){
                                            HStack(spacing: 2){
                                                ForEach(0..<5) { _ in
                                                    Image(systemName: "star.fill")
                                                        .font(.customfont(.regular, fontSize: 10))
                                                        .foregroundColor(.yellow)
                                                }
                                                
                                            }
                                            RoundedCorner()
                                                .foregroundStyle(Color(hex: "#C7D3EB"))
                                                .frame(width: 150, height: 4)
                                        }
                                        
                                        
                                        HStack(spacing: 15){
                                            HStack(spacing: 2){
                                                ForEach(0..<4) { _ in
                                                    Image(systemName: "star.fill")
                                                        .font(.customfont(.regular, fontSize: 10))
                                                        .foregroundColor(.yellow)
                                                }
                                                
                                            }
                                            RoundedCorner()
                                                .foregroundStyle(Color(hex: "#C7D3EB"))
                                                .frame(width: 150, height: 4)
                                        }
                                        
                                        HStack(spacing: 15){
                                            HStack(spacing: 2){
                                                ForEach(0..<3) { _ in
                                                    Image(systemName: "star.fill")
                                                        .font(.customfont(.regular, fontSize: 10))
                                                        .foregroundColor(.yellow)
                                                }
                                                
                                            }
                                            RoundedCorner()
                                                .foregroundStyle(Color(hex: "#C7D3EB"))
                                                .frame(width: 150, height: 4)
                                        }
                                        HStack(spacing: 15){
                                            HStack(spacing: 2){
                                                ForEach(0..<2) { _ in
                                                    Image(systemName: "star.fill")
                                                        .font(.customfont(.regular, fontSize: 10))
                                                        .foregroundColor(.yellow)
                                                }
                                                
                                            }
                                            RoundedCorner()
                                                .foregroundStyle(Color(hex: "#C7D3EB"))
                                                .frame(width: 150, height: 4)
                                        }
                                        
                                        HStack(spacing: 15){
                                            HStack(spacing: 2){
                                                ForEach(0..<1) { _ in
                                                    Image(systemName: "star.fill")
                                                        .font(.customfont(.regular, fontSize: 10))
                                                        .foregroundColor(.yellow)
                                                }
                                                
                                            }
                                            RoundedCorner()
                                                .foregroundStyle(Color(hex: "#C7D3EB"))
                                                .frame(width: 150, height: 4)
                                        }
                                    }
                                }
                            }
                            HStack{
                                Spacer()
                                Text("\(numberOfRating) Ratings")
                                    .font(.customfont(.medium, fontSize: 12))
                                    .foregroundColor(.gray)
                            }
                            Divider()
                            
                            // User review
                            HStack {
                                Text("Tap to Rate")
                                    .font(.customfont(.regular, fontSize: 18))
                                    .foregroundStyle(Color.gray)
                                Spacer()
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { star in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.yellow)
                                        
                                    }
                                }
                            }
                            //=============
                            // User review section
                            VStack(alignment: .leading, spacing: 3) {
                                Text(review)
                                    .font(.customfont(.semibold, fontSize: 13))
                                
                                // Star rating for the user's review
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.customfont(.regular, fontSize: 10))
                                            .foregroundColor(.yellow)
                                    }
                                }.padding(.bottom, 3)
                                
                                // Review detail with "more" functionality
                                Text(reviewDetail)
                                    .font(.customfont(.regular, fontSize: 13))
                                    .foregroundStyle(Color(hex: "#2E3E5C"))
                                    .lineLimit(isReviewExpanded ? nil : 5) // Limit to 5 lines when collapsed
                                //  +
                                Text(isReviewExpanded ? "less" : "more")
                                    .foregroundStyle(Color.yellow)
                                    .font(.customfont(.semibold, fontSize: 13))
                                    .onTapGesture {
                                        withAnimation {
                                            isReviewExpanded.toggle() // Toggle the state when "more" or "less" is clicked
                                        }
                                    }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "#F4F5F7"))
                            )}
                        HStack{
                            Button(action: {
                                isReviewPopupOpen = true
                            }){
                                Image("note")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                                Text("Write a Review").foregroundStyle(Color.yellow)
                                    .font(.customfont(.medium, fontSize: 15))
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .frame(minHeight: .screenHeight * 0.9,maxHeight: .screenHeight * 1)
            .edgesIgnoringSafeArea(.all)
            if isReviewPopupOpen {
                PopupReview(profile: "ahmok1", userName: userName, description: "",isReviewPopupOpen: $isReviewPopupOpen, isPopup: true  )
                               .transition(.move(edge: .bottom))
//                               .onTapGesture {
//                                   isReviewPopupOpen = false 
//                               }
                    .edgesIgnoringSafeArea(.all)
                       }
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            withAnimation {
                isBottomSheetOpen.toggle()
            }
        }
    }
}

#Preview {
    ContentOnButtonSheet(foodName: "Amok Fish", price: 83.2,date: "5 May 2023", itemFood: "Grill", profile: "Songvak", userName: "Sreng Sodane", description: "An amok Khmer recipe is a traditional Khmer (Cambodian) dish usually made with fish, although chicken and beef amok are also popular. ", ingredients: "120 g Fresh boneless fish fillet", percentageOfRating: 2.4, numberOfRating: 838, review: "A very good Recipe", reviewDetail: "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploadedprofile. Your recipe has been uploaded, you can see it on your. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded")
    
    
}

