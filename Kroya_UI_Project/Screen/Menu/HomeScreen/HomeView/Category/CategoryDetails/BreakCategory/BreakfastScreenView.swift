import SwiftUI

struct BreakfastScreenView: View {
    @State private var selectedSegment = 0
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        VStack {
            // Segment Control
            VStack {
                HStack {
                    Spacer()
                    
                    Text("Food on Sale")
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                        .foregroundColor(selectedSegment == 0 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            withAnimation {
                                selectedSegment = 0
                                //                                fetchSegmentData() // Fetch food on sale data
                            }
                        }
                    
                    Spacer()
                    
                    Text("Recipes")
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                        .foregroundColor(selectedSegment == 1 ? .black.opacity(0.8) : .black.opacity(0.5))
                        .onTapGesture {
                            withAnimation {
                                selectedSegment = 1
                                
                                
//                                                                fetchSegmentData() // Fetch recipes data
                            }
                        }
                    
                    Spacer()
                }
                .padding(.top)
                
                GeometryReader { geometry in
                    Divider()
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width / 2, height: 2)
                        .offset(x: selectedSegment == 1 ? geometry.size.width / 2 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                }
                .frame(height: 2)
            }
            .padding(.top, 5)
            
            // Tab View Content
            TabView(selection: $selectedSegment) {
                FoodOnSaleView(iselected: selectedSegment)
                    .tag(0)
        
                
                BreakfastRecipeTab(iselected: selectedSegment)
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
                        .foregroundColor(.black)
                }
            }
        }
    }

}
