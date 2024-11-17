import Foundation

class FeedbackViewModel: ObservableObject {
    @Published var selectedRating: Int = 0
    @Published var commentText: String = ""
    @Published var isFeedbackSubmitted: Bool = false
    @Published var isCommentAllowed: Bool = true
    @Published var feedbackDetails: FeedBackModel? // Store retrieved feedback details
    @Published var getAllUserFeedback : [FeedBackModel] = []
    @Published var errorMessage: String? // For error handling
    @Published var isLoading: Bool = false // To indicate loading state
    @Published var isFeedbackLocked: Bool = false // Prevents further updates if feedback exists
    
    // MARK: - Submit Rating
    func submitRating(itemType: String, foodId: Int, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        FeedbackService.shared.feedbackOnFood(
            itemType: itemType,
            foodId: foodId,
            ratingValue: selectedRating,
            commentText: nil
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.isFeedbackSubmitted = true
                    self.isCommentAllowed = true
                    print("Rating submitted successfully!")
                    
                    // Fetch updated feedback
                    self.getFeedback(itemType: itemType, foodId: foodId) { success, message in
                        if success {
                            print("Updated feedback fetched successfully!")
                        } else {
                            print("Error fetching updated feedback: \(message)")
                        }
                    }
                    completion(true, "Rating submitted successfully!")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    
    // MARK: - Submit Comment
    func submitComment(itemType: String, foodId: Int, completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        FeedbackService.shared.feedbackOnFood(
            itemType: itemType,
            foodId: foodId,
            ratingValue: nil,
            commentText: commentText
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.isCommentAllowed = false
                    print("Comment submitted successfully!")
                    
                    // Fetch updated feedback
                    self.getFeedback(itemType: itemType, foodId: foodId) { success, message in
                        if success {
                            print("Updated feedback fetched successfully!")
                        } else {
                            print("Error fetching updated feedback: \(message)")
                        }
                    }
                    completion(true, "Comment submitted successfully!")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Get Feedback
      func getFeedback(itemType: String, foodId: Int, completion: @escaping (Bool, String) -> Void) {
          FeedbackService.shared.getFeedback(itemType: itemType, foodId: foodId) { result in
              DispatchQueue.main.async {
                  switch result {
                  case .success(let feedback):
                      self.feedbackDetails = feedback
                      self.selectedRating = feedback.ratingValue ?? 0 // Update selectedRating
                      self.commentText = feedback.commentText ?? "" // Update commentText
                      self.isFeedbackLocked = feedback.ratingValue != nil // Lock feedback if already provided
                      self.isCommentAllowed = feedback.commentText == nil // Allow comments only if none exist
                      completion(true, "Feedback loaded successfully!")
                  case .failure(let error):
                      self.selectedRating = 0 // Reset to 0 if no feedback found
                      self.commentText = "" // Reset comment
                      self.isFeedbackLocked = false // Unlock for new feedback
                      self.isCommentAllowed = true // Allow comments
                      completion(false, error.localizedDescription)
                  }
              }
          }
      }
    // MARK: - Submit Feedback (Unified)
    func submitFeedback(itemType: String, foodId: Int, completion: @escaping (Bool, String) -> Void) {
        if isFeedbackLocked && !commentText.isEmpty {
            print("Submitting comment only since rating is locked.")
            submitComment(itemType: itemType, foodId: foodId) { success, message in
                if success {
                    print("Comment submitted successfully!")
                    self.getFeedback(itemType: itemType, foodId: foodId) { _, _ in
                        print("Feedback refreshed after comment submission.")
                    }
                    completion(true, "Comment submitted successfully!")
                } else {
                    completion(false, message)
                }
            }
        } else {
            print("Submitting rating and comment.")
            FeedbackService.shared.feedbackOnFood(
                itemType: itemType,
                foodId: foodId,
                ratingValue: selectedRating,
                commentText: commentText
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.isFeedbackLocked = true
                        self.getFeedback(itemType: itemType, foodId: foodId) { _, _ in
                            print("Feedback refreshed after submission.")
                        }
                        completion(true, "Feedback submitted successfully!")
                    case .failure(let error):
                        completion(false, error.localizedDescription)
                    }
                }
            }
        }
    }

    //MARK: in Case Feedback respone
    private func handleFeedbackResponse(result: Result<FeedBackModel, Error>, completion: @escaping (Bool, String) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success(let feedback):
                print("Feedback submitted successfully!")
                self.feedbackDetails = feedback // Store the updated feedback
                self.selectedRating = feedback.ratingValue ?? 0
                self.commentText = feedback.commentText ?? ""
                self.isFeedbackSubmitted = true
                self.isFeedbackLocked = feedback.ratingValue != nil
                completion(true, "Feedback submitted successfully!")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error submitting feedback: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            }
        }
    }

    // MARK: - Get All Feedback
       func fetchAllFeedback(itemType: String, foodId: Int, completion: @escaping (Bool, String) -> Void) {
           isLoading = true
           FeedbackService.shared.getAllFeedback(itemType: itemType, foodId: foodId) { result in
               DispatchQueue.main.async {
                   self.isLoading = false
                   switch result {
                   case .success(let feedback):
                       self.getAllUserFeedback = feedback
                       completion(true, "All feedback loaded successfully!")
                   case .failure(let error):
                       self.errorMessage = error.localizedDescription
                       self.getAllUserFeedback = [] // Reset feedback data
                       completion(false, error.localizedDescription)
                   }
               }
           }
       }
}
