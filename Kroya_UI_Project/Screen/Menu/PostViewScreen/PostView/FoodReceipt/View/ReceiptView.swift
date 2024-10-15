
//
//  ReceiptView.swift
//  Kroya_UI_Project
//
//  Created by KAK-LY on 15/10/24.
//

import SwiftUI

struct ReceiptView: View {
    // Inject the ViewModel
    @ObservedObject var viewModel = ReceiptViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                
                Success()
                
            
                ReceiptCard()
    
               
            }
            .padding(.bottom, 50)
            .navigationTitle("Receipt")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    ReceiptView()
}
