import SwiftUI

struct FoodOnSaleView: View {
    
    // Properties
    var iselected: Int?
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    @StateObject private var foodsellVm = FoodSellViewModel()
    
    var body: some View {
        VStack {
            if foodsellVm.FoodOnSale.isEmpty && !foodsellVm.isLoading {
                Text(LocalizedStringKey("No Food Items Available"))
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(foodsellVm.FoodOnSale) { foodSale in
                        ZStack {
                            FoodOnSaleViewCell(foodSale: foodSale)
                            NavigationLink(destination: FoodDetailView(
                                theMainImage: "ahmok",
                                subImage1: "ahmok1",
                                subImage2: "ahmok2",
                                subImage3: "ahmok3",
                                subImage4: "ahmok4",
                                showOrderButton: foodSale.isOrderable,
                                showPrice: foodSale.isOrderable
                            )) {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, -6)
                    }
                    .overlay(
                        // Show a loading indicator if data is being fetched
                        Group {
                            if foodsellVm.isLoading {
                                ZStack {
                                    Color.white
                                        .edgesIgnoringSafeArea(.all)
                                    
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: PrimaryColor.normal))
                                        .scaleEffect(2)
                                        .offset(y: -50)
                                }
                                .padding()
                            }
                        }
                    )
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onAppear {
            foodsellVm.getAllFoodSell()
        }
    }
}
