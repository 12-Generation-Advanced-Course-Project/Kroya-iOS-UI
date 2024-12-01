import SwiftData
import SwiftUI

class RecentSearchesData: ObservableObject {
    @Published var recentSearches: [String] = []
    
    private var isLoaded = false

    func saveSearch(_ title: String, in context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot save search.")
            return
        }

        // Avoid duplicates by checking if the title already exists for this email
        let predicate = #Predicate<RecentSearchesModel> { $0.email == email && $0.title == title }
        let fetchDescriptor = FetchDescriptor<RecentSearchesModel>(predicate: predicate)
        
        do {
            let results = try context.fetch(fetchDescriptor)
            if results.isEmpty {
                // Insert new search
                let newSearch = RecentSearchesModel(title: title, email: email)
                context.insert(newSearch)
                recentSearches.append(title)
                
                try context.save()
                print("Saved recent search: \(title) for email: \(email)")
            } else {
                print("Search \(title) already exists for email: \(email)")
            }
        } catch {
            print("Failed to save recent search: \(error.localizedDescription)")
        }
    }
    
    func loadSearches(from context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot load searches.")
            return
        }
        
        // Prevent loading if already done
        if isLoaded { return }
        
        let predicate = #Predicate<RecentSearchesModel> { $0.email == email }
        let fetchDescriptor = FetchDescriptor<RecentSearchesModel>(predicate: predicate)
        
        do {
            let searches = try context.fetch(fetchDescriptor)
            self.recentSearches = searches.map { $0.title }
            isLoaded = true
            print("Loaded recent searches for email \(email): \(recentSearches)")
        } catch {
            print("Failed to load recent searches: \(error.localizedDescription)")
        }
    }
    
    func clearSearch(_ title: String, from context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot clear search.")
            return
        }
        
        let predicate = #Predicate<RecentSearchesModel> { $0.email == email && $0.title == title }
        let fetchDescriptor = FetchDescriptor<RecentSearchesModel>(predicate: predicate)
        
        do {
            let searches = try context.fetch(fetchDescriptor)
            if let searchToDelete = searches.first {
                context.delete(searchToDelete)
                recentSearches.removeAll { $0 == title }
                
                try context.save()
                print("Cleared recent search: \(title) for email: \(email)")
            }
        } catch {
            print("Failed to clear recent search: \(error.localizedDescription)")
        }
    }
    
    func clearAllSearches(from context: ModelContext) {
        guard let email = Auth.shared.getCredentials().email else {
            print("No user email found. Cannot clear all searches.")
            return
        }
        
        let predicate = #Predicate<RecentSearchesModel> { $0.email == email }
        let fetchDescriptor = FetchDescriptor<RecentSearchesModel>(predicate: predicate)
        
        do {
            let searches = try context.fetch(fetchDescriptor)
            searches.forEach { context.delete($0) }
            recentSearches.removeAll()
            
            try context.save()
            print("Cleared all recent searches for email: \(email)")
        } catch {
            print("Failed to clear all recent searches: \(error.localizedDescription)")
        }
    }
}
