//
//  sale.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct SaleTab: View {
    @EnvironmentObject var addNewFoodVM: AddNewFoodVM
    var isselected:Int?
    
    var body: some View {
        
        VStack{
            FoodOnSaleView()
        }
        
    }
}

#Preview {
   SaleTab()
}
