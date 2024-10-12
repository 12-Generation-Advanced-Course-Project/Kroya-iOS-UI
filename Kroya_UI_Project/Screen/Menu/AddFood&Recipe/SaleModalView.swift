//
//  SaleModalView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 10/10/24.
//

import SwiftUI


struct SaleModalView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
       
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    
                }
                .navigationTitle("Sale")
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
                        
                        
                    }
            }.navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    SaleModalView()
}
