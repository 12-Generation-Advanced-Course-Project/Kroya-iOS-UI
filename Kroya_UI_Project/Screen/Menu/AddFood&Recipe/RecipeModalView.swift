//
//  RecipeView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 10/10/24.
//

import SwiftUI

struct RecipeModalView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    
                }
                .navigationTitle("Recipe")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline) // Empty navigation title
                    .toolbar {
                        // Toolbar items
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()}) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.black)
                                    .onTapGesture {
                                        dismiss()
                                    }
                                    .padding(.horizontal, 8)
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            // Search button
                            NavigationLink(destination: SaleModalView()) {
                                Text("Skip")
                                    .foregroundColor(.black)
                            }
                        }
                        
                    }
            }
        }
    }
}

#Preview{
    RecipeModalView()
}
