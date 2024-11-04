import SwiftData
import SwiftUI

class DraftModelData: ObservableObject {
    @ObservedObject var userStore: UserStore
    
    init(userStore: UserStore) {
           self.userStore = userStore
           self.ingredients = [RecipeIngredient(id: UUID().hashValue, name: "", quantity: 0, price: 0, selectedCurrency: 0)]
           self.cookingSteps = [CookingStep(id: UUID().hashValue, description: "")]
       }
    
    //MARK: Fields for AddNewFood
    @Published var foodName: String = ""
    @Published var descriptionText: String = ""
    @Published var selectedLevel: String? = nil
    @Published var selectedCuisine: String? = nil
    @Published var selectedCategory: String? = nil
    @Published var duration: Double = 0
    
    //MARK: Fields for RecipeModal
    @Published var ingredients: [RecipeIngredient]
    @Published var cookingSteps: [CookingStep]
    
    //MARK: Fields for SaleModalView
    @Published var amount: Double = 0
    @Published var price: Double = 0
    @Published var location: String = ""
    @Published var isForSale: Bool = false
    @Published var cookDate: Date = Date()
    
    //MARK: Images
    @Published var selectedImages: [UIImage] = []
    
    // MARK: - Save Draft
    func saveDraft(in context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
                   print("No user email found. Cannot save draft.")
                   return
               }
        // Encode selectedImages as a single Data object with image names
        var imageDetails = [(data: Data, name: String)]()
        selectedImages.forEach { image in
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                // Generate a unique name for each image
                let imageExtension = detectImageFormat(data: imageData)
                let imageName = "\(UUID().uuidString).\(imageExtension)"
                imageDetails.append((data: imageData, name: imageName))
                print("Generated Image Name: \(imageName)")
            }
        }
        
        // Serialize images to JSON for storage
        let imageDataArray = imageDetails.map { $0.data }
        let imagesData = try? JSONEncoder().encode(imageDataArray)
        
        // Fetch existing draft if it exists
        let fetchRequest = FetchDescriptor<Draft>()
        do {
            let drafts = try context.fetch(fetchRequest)
            if let existingDraft = drafts.first(where: { $0.email == email }) {
                // Update the existing draft
                existingDraft.foodName = foodName
                existingDraft.descriptionText = descriptionText
                existingDraft.selectedLevel = selectedLevel
                existingDraft.selectedCuisine = selectedCuisine
                existingDraft.selectedCategory = selectedCategory
                existingDraft.duration = duration
                existingDraft.amount = amount
                existingDraft.price = price
                existingDraft.location = location
                existingDraft.isForSale = isForSale
                existingDraft.cookDate = cookDate
                existingDraft.selectedImagesData = imagesData
                existingDraft.ingredients = ingredients
                existingDraft.cookingSteps = cookingSteps
                
                print("Draft updated in SwiftData!")
            } else {
                // Create a new draft if none exists
                let draft = Draft(
                    email: email,
                    foodName: foodName,
                    descriptionText: descriptionText,
                    selectedLevel: selectedLevel,
                    selectedCuisine: selectedCuisine,
                    selectedCategory: selectedCategory,
                    duration: duration,
                    amount: amount,
                    price: price,
                    location: location,
                    isForSale: isForSale,
                    cookDate: cookDate,
                    selectedImagesData: imagesData,
                    ingredients: ingredients,
                    cookingSteps: cookingSteps
                )

                context.insert(draft)
                print("New draft saved to SwiftData!")
            }

            try context.save()
            // Log details to verify data
            print("Draft saved to SwiftData with details:")
            print("foodName: \(foodName)")
            print("descriptionText: \(descriptionText)")
            print("selectedLevel: \(String(describing: selectedLevel))")
            print("selectedCuisine: \(String(describing: selectedCuisine))")
            print("selectedCategory: \(String(describing: selectedCategory))")
            print("duration: \(duration)")
            print("amount: \(amount)")
            print("price: \(price)")
            print("location: \(location)")
            print("isForSale: \(isForSale)")
            print("cookDate: \(cookDate)")

        } catch {
            print("Failed to save draft: \(error.localizedDescription)")
        }
    }

    // MARK: - Load Draft
    func loadDraft(from context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
                   print("No user email found. Cannot load draft.")
                   return
               }
        let fetchRequest = FetchDescriptor<Draft>()
        do {
            let drafts = try context.fetch(fetchRequest)
            if let draft = drafts.first(where: { $0.email == email }) {
                self.foodName = draft.foodName
                self.descriptionText = draft.descriptionText
                self.selectedLevel = draft.selectedLevel
                self.selectedCuisine = draft.selectedCuisine
                self.selectedCategory = draft.selectedCategory
                self.duration = draft.duration
                self.amount = draft.amount
                self.price = draft.price
                self.location = draft.location
                self.isForSale = draft.isForSale
                self.cookDate = draft.cookDate
                self.ingredients = draft.ingredients
                self.cookingSteps = draft.cookingSteps
                
                // Decode images from JSON data
                if let imagesData = draft.selectedImagesData {
                    let imageDataArray = try? JSONDecoder().decode([Data].self, from: imagesData)
                    self.selectedImages = imageDataArray?.compactMap { UIImage(data: $0) } ?? []
                } else {
                    print("Error decoding images from JSON")
                }
                print("Draft loaded from SwiftData!")
            }
        } catch {
            print("Failed to load draft: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Clear Draft
    func clearDraft(from context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot clear draft.")
            return
        }

        let fetchRequest = FetchDescriptor<Draft>()
        do {
            let drafts = try context.fetch(fetchRequest)
            for draft in drafts where draft.email == email {
                context.delete(draft)
            }
            try context.save()
            print("Draft cleared for user: \(email)")
        } catch {
            print("Failed to clear draft for user \(email): \(error.localizedDescription)")
        }
        
        // Clear local data
        foodName = ""
        descriptionText = ""
        selectedLevel = nil
        selectedCuisine = nil
        selectedCategory = nil
        duration = 0
        ingredients = []  // Clear ingredients
        cookingSteps = [] // Clear cooking steps
        amount = 0
        price = 0
        location = ""
        isForSale = false
        cookDate = Date()
        selectedImages = []
    }
    
    // MARK: Helper function to detect image format and return file extension
    private func detectImageFormat(data: Data) -> String {
        let headerBytes = [UInt8](data.prefix(1))
        switch headerBytes {
        case [0x89]:
            return "png"
        case [0xFF]:
            return "jpg"
        default:
            return "jpeg"
        }
    }
}
