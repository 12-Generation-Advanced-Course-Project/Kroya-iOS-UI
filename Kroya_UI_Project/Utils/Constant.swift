//
//  Untitled.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 27/9/24.
//

struct Constants {
    // Base URL for the API
    static let baseURL = "http://35.247.138.88:8080/api/v1/"
 
    // Address URLs
    static let AddressListUrl = "\(baseURL)address/list"
    static let AddressCreateUrl = "\(baseURL)address/create"
    static let AddressDeleteUrl = "\(baseURL)address/delete/"
    static let AddressByIdUrl = "\(baseURL)address/"
    static let AddressUpdateUrl = "\(baseURL)address/update/"

    // Auth
    static let KroyaUrlAuth = "\(baseURL)auth/"
    static let KroyaUrlUser = "\(baseURL)user/"
    static let KroyaAddress = "\(baseURL)address/"
    static let fileupload = "\(baseURL)fileView/"
    static let FoodRecipeUrl = "\(baseURL)food-recipe/"
    static let CuisineUrl = "\(baseURL)cuisine/"
    static let CategoryUrl = "\(baseURL)category/"
    static let FoodRecipeByCategoryUrl = "\(baseURL)food-recipe/cuisine/"
    static let SearchFoodRecipeByNameUrl = "\(baseURL)food-recipe/search/"
    static let UserFoodUrl = "\(baseURL)user/"

    // Food Sell
    static let FoodSellUrl = "\(baseURL)food-sell/"
    static let FoodSellCategoryUrl = "\(baseURL)food-sell/cuisine/"
    static let guestSeelCuisine = "\(baseURL)guest-user/food-sell/"

    // Popular Dishes
    static let PopularDishes = "\(baseURL)foods/"
    static let FoodsUrl = "\(baseURL)foods/"
    static let FoodsUrlForGuest = "\(baseURL)guest-user/foods/"

    // Feedback
    static let FeedBack = "\(baseURL)feedback"

    // Favorite
    static let FavoriteFoodUrl = "\(baseURL)favorite/"

    // Purchase
    static let PurchaseeUrl = "\(baseURL)purchase/"
    static let SearchPurchaseeByNameUrl = "\(baseURL)purchase/search/"
    static let PurchaseOrderUrl = "\(baseURL)purchase/orders/"
    static let PurchaseSalesUrl = "\(baseURL)purchase/seller/"
    static let Purchase = "\(baseURL)purchase"
    static let OrderRequestUrl = "\(baseURL)purchase/orders/seller/"

    // Guest food popular
    static let GuestFoodPopularUrl = "\(baseURL)guest-user/foods"

    // Guest food by category
    static let GuestFoodByCategoryIdUrl = "\(baseURL)guest-user/foods/"

    // Search food by name
    static let FoodNameUrl = "\(baseURL)foods/"

    // Guest food sell
    static let GuestFoodSellUrl = "\(baseURL)guest-user/food-sell"

    // Sales Report
    static let SalesReportUrl = "\(baseURL)sale-report/"

    // Guest Category
    static let GuestCategoryUrl = "\(baseURL)category/"

    // WeBill Integration
    static let ConnectWeBillUrl = "\(baseURL)user/connectWebill"
    static let GetCredentialUserWeBillAccountUrl = "\(baseURL)user/webill-acc-no"

    // Notifications
    static let NotificationUrl = "\(baseURL)notifications"

    // Guest food recipe
    static let GuestFoodRecipeUrl = "\(baseURL)guest-user/food-recipe"
    static let GuestFoodRecipeByCuisineUrl = "\(baseURL)guest-user/food-recipe/"

    // Guest Search All Food
    static let GuestSearchAllFoodUrl = "\(baseURL)guest-user"

    // Guest Search All Food By Name
    static let GuestSearchAllFoodByNameUrl = "\(baseURL)guest-user/foods/"
    static let allFoodName = "\(baseURL)guest-user/foods/food-name-all"
}
