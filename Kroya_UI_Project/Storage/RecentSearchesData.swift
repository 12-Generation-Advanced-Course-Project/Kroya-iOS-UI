//
//  RecentSearchesData.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 14/11/24.
//

import SwiftData
import SwiftUI

class RecentSearchesData: ObservableObject {
    @Published var recentSearches: [String] = []
    
    func saveSearch(_ title: String, in context: ModelContext) {
        // Avoid duplicates by checking if the title already exists
        if !recentSearches.contains(title) {
            let newSearch = RecentSearchesModel(title: title)
            context.insert(newSearch)
            recentSearches.append(title)
            
            do {
                try context.save()
                print("Saved recent search: \(title)")
            } catch {
                print("Failed to save recent search: \(error.localizedDescription)")
            }
        }
    }
    
    func loadSearches(from context: ModelContext) {
        let fetchRequest = FetchDescriptor<RecentSearchesModel>()
        
        do {
            let searches = try context.fetch(fetchRequest)
            self.recentSearches = searches.map { $0.title }
            print("Loaded recent searches: \(recentSearches)")
        } catch {
            print("Failed to load recent searches: \(error.localizedDescription)")
        }
    }
    
    func clearSearch(_ title: String, from context: ModelContext) {
        let fetchRequest = FetchDescriptor<RecentSearchesModel>()
        
        do {
            let searches = try context.fetch(fetchRequest)
            if let searchToDelete = searches.first(where: { $0.title == title }) {
                context.delete(searchToDelete)
                recentSearches.removeAll { $0 == title }
                
                try context.save()
                print("Cleared recent search: \(title)")
            }
        } catch {
            print("Failed to clear recent search: \(error.localizedDescription)")
        }
    }
    
    func clearAllSearches(from context: ModelContext) {
        let fetchRequest = FetchDescriptor<RecentSearchesModel>()
        
        do {
            let searches = try context.fetch(fetchRequest)
            searches.forEach { context.delete($0) }
            recentSearches.removeAll()
            
            try context.save()
            print("Cleared all recent searches")
        } catch {
            print("Failed to clear all recent searches: \(error.localizedDescription)")
        }
    }
}
