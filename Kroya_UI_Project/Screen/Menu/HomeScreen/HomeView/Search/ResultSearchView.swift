import SwiftUI

struct ResultSearchView: View {
    
    @State private var selectedSegment = 0
    @Binding var isTabBarHidden: Bool
    @Environment(\.dismiss) var dismiss
    var menuName: String
    var foodName: String
    var guestFoodName: String
    @Environment(\.modelContext) var modelContext
    @StateObject private var listFoodRecipe = FoodListVM()
    //@StateObject private var searchFood = SearchVM()
    @ObservedObject var recentSearchesData: RecentSearchesData
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
                    AllFoodTab(isSelected: selectedSegment, foodName: foodName, guestFoodName: guestFoodName)
                        .tag(0)
                    ListFoodSaleTabView(iSselected: selectedSegment, foodName: foodName, guestFoodName: guestFoodName)
                        .tag(1)
                    ListFoodRecipeTab(foodName: foodName, guestFoodName: guestFoodName, iSselected: selectedSegment)
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
                                .foregroundColor(.black)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(menuName)
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Only save non-empty search terms
//            if !menuName.isEmpty {
//                recentSearchesData.saveSearch(menuName, in: modelContext)
//            }
           
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func underlineWidth(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        switch selectedSegment {
        case 0: return geometry.size.width / 7
        case 1: return geometry.size.width / 3.5
        case 2: return geometry.size.width / 4.5
        default: return geometry.size.width / 7
        }
    }
    
    private func underlineOffset(for selectedSegment: Int, in geometry: GeometryProxy) -> CGFloat {
        switch selectedSegment {
        case 0: return 0
        case 1: return geometry.size.width / 6
        case 2: return (geometry.size.width / 2) * 1
        default: return 0
        }
    }
}
