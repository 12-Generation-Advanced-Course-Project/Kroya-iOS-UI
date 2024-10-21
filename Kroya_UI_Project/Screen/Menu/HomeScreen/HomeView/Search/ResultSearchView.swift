import SwiftUI

struct ResultSearchView: View {
    
    @State private var selectedSegment = 0
    @Binding var isTabBarHidden: Bool
    @Environment(\.dismiss) var dismiss
    var menuName: String = "Somlor"
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(["All", "Food on Sale", "Recipes"], id: \.self) { title in
                            Text(title)
                                .onTapGesture {
                                    selectedSegment = ["All", "Food on Sale", "Recipes"].firstIndex(of: title) ?? 0
                                }
                                .fontWeight(.semibold)
                                .font(.customfont(.semibold, fontSize: 16))
                                .foregroundColor(selectedSegment == (["All", "Food on Sale", "Recipes"].firstIndex(of: title) ?? 0) ? .black.opacity(0.8) : .black.opacity(0.5))
                                .padding(.horizontal, 15)
                        }
                        Spacer()
                    }
                    .padding(.top)
                    // Geometry Reader for Dynamic Line Under the Selected Tab
                    GeometryReader { geometry in
                        Divider()
                        Rectangle()
                            .fill(PrimaryColor.normal)
                            .frame(width: underlineWidth(for: selectedSegment, in: geometry), height: 2)
                            .offset(x: underlineOffset(for: selectedSegment, in: geometry))
                            .animation(.easeInOut(duration: 0.3), value: selectedSegment)
                    }
                    .frame(height: 2)
                    
                    
                }
                .padding(.top, 5)
                
                TabView(selection: $selectedSegment) {
                    FoodSaleView(iselected: selectedSegment)
                        .tag(0)
                    RecipeView(iselected: selectedSegment)
                        .tag(1)
                    FoodSaleView(iselected: selectedSegment)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(menuName)
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
        
    }
    // Calculate the underline width for each tab
    private func underlineWidth(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        switch selectedSegment {
        case 0:
            return geometry.size.width / 7 // All Tab
        case 1:
            return geometry.size.width / 3.5 // Food on Sale Tab
        case 2:
            return geometry.size.width / 4.5 // Recipes Tab
        default:
            return geometry.size.width / 7
        }
    }
    // Calculate the underline offset for each tab
    private func underlineOffset(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        switch selectedSegment {
        case 0:
            return 0 //  "All"
        case 1:
            return geometry.size.width / 6 // "Food on Sale"
        case 2:
            return (geometry.size.width / 2) * 1 // "Recipes"
        default:
            return 0
        }
    }
}

#Preview {
    ResultSearchView(isTabBarHidden: .constant(false))
}
