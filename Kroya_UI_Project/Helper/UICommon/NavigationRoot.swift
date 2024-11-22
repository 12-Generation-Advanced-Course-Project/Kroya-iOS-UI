//
//  NavigationRoot.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 21/11/24.
//

import Foundation
import Combine

enum NavigationPath {
    case first
}
class NavigationManager: ObservableObject {
    @Published var currentPath: NavigationPath = .first
    
    @Published var navigationStack: [NavigationPath] = []
    
    // Navigate to a specific view
    func navigate(to path: NavigationPath) {
        navigationStack.append(currentPath)
        currentPath = path
    }
    
    func goBack() {
        guard !navigationStack.isEmpty else {
            currentPath = .first
            return
        }
        
        
        currentPath = navigationStack.removeLast()
    }
    
    // Navigate back to a specific view
    func navigateBack(to path: NavigationPath) {
        if let index = navigationStack.lastIndex(of: path) {
            // Remove views after the target view
            navigationStack.removeSubrange(index+1..<navigationStack.count)
            currentPath = path
        } else {
            currentPath = path
            navigationStack.removeAll()
        }
    }
    
    func resetNavigation() {
        currentPath = .first
        navigationStack.removeAll()
    }
}
