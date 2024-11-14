import SwiftUI

// MARK: - FoodOnSaleView
struct FoodOnSaleView: View {
    var iselected: Int?
    @StateObject private var foodsellVm = FoodSellViewModel()
  
    var body: some View {
        VStack {
            if foodsellVm.FoodOnSale.isEmpty && !foodsellVm.isLoading {
                Text("No Food Items Available")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(foodsellVm.FoodOnSale) { foodSale in
                            NavigationLink(destination: foodDetailDestination(for: foodSale)) {
                                FoodOnSaleViewCell(foodSale: foodSale)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .overlay(
                    Group {
                        if foodsellVm.isLoading {
                            LoadingOverlay()
                        }
                    }
                )
            }
        }
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
           
        }
    }
    
    // MARK: - Food Detail Destination
    @ViewBuilder
    private func foodDetailDestination(for foodSale: FoodSellModel) -> some View {
        FoodDetailView(
            theMainImage: "ahmok",
            subImage1: "ahmok1",
            subImage2: "ahmok2",
            subImage3: "ahmok3",
            subImage4: "ahmok4",
            showOrderButton: foodSale.isOrderable,
            showPrice: foodSale.isOrderable
        )
    }
}
