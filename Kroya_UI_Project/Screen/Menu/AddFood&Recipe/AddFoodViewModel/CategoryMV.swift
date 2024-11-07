//
//  CategoryMV.swift
//  Kroya_UI_Project
//
//  Created by kosign on 7/11/24.
//

import Foundation
import Alamofire

class CategoryMV: ObservableObject{
    
    @Published var categoryShow: [CategoryModel]?
    
    @Published var isLoading: Bool = false
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    //MARK: Fetch Category
    func fetchAllCategory(){
        self.isLoading = true
        CategoryService.shared.getAllCategory{ [weak self] result in
            DispatchQueue.main.async{
                self?.isLoading = false
                
            }
        }
    }
}
