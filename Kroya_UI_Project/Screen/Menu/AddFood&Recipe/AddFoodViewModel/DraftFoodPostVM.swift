import SwiftUI

class DraftModel: ObservableObject {
    @ObservedObject var userStore: UserStore
    init(userStore: UserStore) {
        self.userStore = userStore
    }

    // MARK: Fields from AddNewFood
    @Published var foodName: String = ""
    @Published var description: String = ""
    @Published var category: String = ""
    @Published var selectedLevel: String? = nil
    @Published var selectedCuisine: String? = nil
    @Published var selectedCategory: String? = nil
    
    // MARK: Fields from RecipeModal
    @Published var ingredients: [RecipeIngredient] = []
    @Published var cookingSteps: [CookingStep] = []
    
    // MARK: Fields from SaleModalView
    @Published var amount: Double = 0
    @Published var price: Double = 0
    @Published var location: String = ""
    @Published var isForSale: Bool? = nil
    @Published var CookDate: Date = Date()
    
    // MARK: Images
    @Published var selectedImages: [UIImage] = []
    
    // MARK: Check if any fields have values for determining if a draft exists
    var hasDraftData: Bool {
        return !foodName.isEmpty || !description.isEmpty || selectedCategory != nil ||
               !ingredients.isEmpty || !cookingSteps.isEmpty ||
               amount != 0 || price != 0 || !location.isEmpty ||
               !selectedImages.isEmpty || selectedLevel != nil || selectedCuisine != nil || CookDate != Date()
    }

    // MARK: Method to clear draft data when discarded
    func clearDraft() {
        foodName = ""
        description = ""
        category = ""
        ingredients = []
        cookingSteps = []
        amount = 0.00
        price = 0.00
        location = ""
        isForSale = nil
        selectedImages = []
        CookDate = Date()
    }
}
