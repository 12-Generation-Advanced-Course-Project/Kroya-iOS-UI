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
                GeometryReader { geometry in
                    Divider()
                    
                    Rectangle()
                        .fill(Color.yellow) // Use your defined color here
                        .frame(width: geometry.size.width / 2, height: 2) // Two segments
                        .offset(x: selectedSegment == 1 ? geometry.size.width / 2 : 0)
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
        .navigationTitle("Breakfast")
        .navigationBarTitleDisplayMode(.inline)
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
        }
    }
}

#Preview {
    BreakfastScreenView()
}
