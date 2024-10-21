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
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isOpen = isOpen
        self.maxHeight = maxHeight
        self.minHeight = 650 // Minimum height when the sheet is collapsed
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
            .offset(y: max(self.offset + self.translation, 0)) // Move the sheet with the drag
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    let snapDistance = self.maxHeight * 0.25
                    if value.translation.height > snapDistance {
                        // If user drags down by a significant amount, close the sheet
                        self.isOpen = false
                    } else if value.translation.height < -snapDistance {
                        // If user drags up by a significant amount, open the sheet
                        self.isOpen = true
                    }
                }
            )
            .onAppear {
                          let defaultHeight = geometry.size.height  // Set the defaultHeight to 70% of the parent height
                          print("defaultHeight: \(defaultHeight)")
                      }
        }
    }
}

struct ContentOnButtonSheet: View {
    @State private var isBottomSheetOpen: Bool = false
    @State private var isEggChecked = true
    @State private var isButterChecked = true
    @State private var isHalfButterChecked = false
    @State private var count = 0
    
    var foodName: String
    var price : Float
    var date : String
    var itemFood : String
    var profile : String
    var userName : String
    var description :String
    var ingredients :String
    var stepNember : Int
    var stepDetail : String
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
                FoodDetailView(theMainImage: "Songvak",
                               subImage1: "ahmok",
                               subImage2: "brohok",
                               subImage3: "SomlorKari",
                               subImage4: "Songvak")
                Spacer()
            }
            .blur(radius: isBottomSheetOpen ? 5 : 0)
            
            // Bottom Sheet Content
            BottomSheetView(isOpen: $isBottomSheetOpen, maxHeight: 950) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 7) {
                        
                        HStack{
                            Text(foodName)
                                .font(.customfont(.bold, fontSize: 20))
                            Spacer()
                            Button(action:{})
                            {
                                Circle()
                                    .fill(Color(hex: "FECC03"))
                                    .frame(width: 32, height: 32)
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
                            Image(profile)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
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
                        VStack{
                            HStack{
                                Text("Steps")
                                    .font(.system(size: 17))
                                    .bold()
                                Spacer()
                                Button(action:{})
                                {
                                    Circle()
                                        .stroke(Color(hex: "FECC03"), lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "arrow.backward.to.line")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 15, height: 15)
                                                .fontWeight(.bold)
                                                .foregroundStyle(Color(hex: "FECC03"))
                                                .clipShape(Circle())
                                        )
                                    
                                }
                                
                                //Button Step
                                Button(action:{})
                                {
                                    Circle()
                                        .stroke(Color(hex: "FECC03"), lineWidth: 2)
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
                                Circle().fill(Color(hex: "#2E3E5C")).frame(width: 30, height: 30)
                                    .overlay(
                                        Text("\(stepNember )")
                                            .font(.customfont(.bold, fontSize: 14))
                                            .foregroundColor(Color.white)
                                    )
                                    .padding(.bottom, 23)
                                Text(stepDetail)
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
                                Text("\(numberOfRating)")
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
                            VStack(alignment: .leading, spacing: 3){
                                Text(review)
                                    .font(.customfont(.semibold, fontSize: 13))
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { star in
                                        Image(systemName: "star.fill")
                                            .font(.customfont(.regular, fontSize: 10))
                                            .foregroundColor(.yellow)
                                    }
                                }.padding(.bottom, 3)
                                Text(reviewDetail)
                                    .font(.customfont(.regular, fontSize: 13))
                                    .foregroundStyle(Color(hex: "#2E3E5C"))
                                +
                                Text("more") .foregroundStyle(Color.yellow)
                                    .font(.customfont(.semibold, fontSize: 13))
                            } .padding(.vertical, 10)
                                .padding(.horizontal, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "#F4F5F7"))
                            )
                        }.padding([.top, .bottom], 7)
                        HStack{
                            Button(action: {}){
                                Image("note")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                                Text("Write a Review").foregroundStyle(Color.yellow)
                                    .font(.customfont(.medium, fontSize: 15))
                            }
                        }
                    }
                    .padding(.horizontal,17)
                    .padding(.bottom, 10)
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
    ContentOnButtonSheet(foodName: "Songvak", price: 83.2,date: "5 May 2023", itemFood: "Soup", profile: "Songvak", userName: "Sreng Sodane", description: "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your", ingredients: "1/2 Sugar", stepNember: 1, stepDetail: "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your", percentageOfRating: 2.4, numberOfRating: 838, review: "A very good Recipe", reviewDetail: "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your. Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded,")
    
    
}
//let date = dateFormatter.date(from: "01/16/2023")
