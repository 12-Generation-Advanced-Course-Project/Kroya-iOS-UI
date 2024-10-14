import SwiftUI

struct ResultSearchView: View {
    
    @State private var selectedSegment = 0
    @Binding var isTabBarHidden: Bool // Add this binding
    @Environment(\.dismiss) var dismiss // Environment dismiss variable
    
    var body: some View {
        VStack {
            HStack {
                Text("All")
                    .onTapGesture { selectedSegment = 0 }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .font(.custom("CustomFontName", size: 16)) // Replace with actual font name
                    .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                
                Text("Food on Sale")
                    .onTapGesture { selectedSegment = 1 }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .font(.custom("CustomFontName", size: 16)) // Replace with actual font name
                    .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                
                Text("Recipes")
                    .onTapGesture { selectedSegment = 2 }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .font(.custom("CustomFontName", size: 16)) // Replace with actual font name
                    .foregroundColor(selectedSegment == 2 ? .black.opacity(0.8) : .black.opacity(0.5))
            }
            .padding(.top)
            
            GeometryReader { geometry in
                Divider()
                Rectangle()
                    .fill(Color.primary) // Replace with PrimaryColor.normal if needed
                    .frame(width: geometry.size.width / 3, height: 2)
                    .padding(.horizontal, 10)
                    .offset(x: CGFloat(selectedSegment) * geometry.size.width / 3)
                    .animation(.easeInOut(duration: 0.3), value: selectedSegment)
            }
            .frame(height: 2)
        }
        .padding(.top, 5)
        
        // TabView to show content based on selected segment
        TabView(selection: $selectedSegment) {
            AllView(iselected: selectedSegment)
                .tag(0)
            FoodSaleView(iselected: selectedSegment)
                .tag(1)
            RecipeView(iselected: selectedSegment)
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            isTabBarHidden = true // Correctly hide the tab bar when this view appears
        }
        .onDisappear {
            isTabBarHidden = false // Optionally restore the tab bar when this view disappears
        }
    }
}

// Placeholder views
struct AllView: View {
    var iselected: Int
    var body: some View {
        FoodSaleView()
            .padding()
    }
}
//
//struct FoodSaleView: View {
//    var iselected: Int
//    var body: some View {
//        Text("Food Sale View")
//            .padding()
//    }
//}
//
//struct RecipeView: View {
//    var iselected: Int
//    var body: some View {
//        Text("Recipe View")
//            .padding()
//    }
//}

#Preview {
    ResultSearchView(isTabBarHidden: .constant(false)) // Provide a default value for the binding
}
