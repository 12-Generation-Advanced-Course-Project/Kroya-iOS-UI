//
//  IngredientsView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct IngredientsView: View {
    @State private var isEggChecked = true
    @State private var isButterChecked = true
    @State private var isHalfButterChecked = false
    var body: some View {
        
        GeometryReader{ geometry in
            VStack (alignment:.leading, spacing: 10){
                
                Text("Ingredients")
                    .font(.customfont(.bold, fontSize: 18))
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        Button(action: {}){
                            Circle()
                                .fill(isHalfButterChecked ?   Color.green.opacity(0.3): Color.clear)
                                .stroke(isHalfButterChecked ? Color.clear : Color.gray, lineWidth: 1)
                                .frame(width: geometry.size.width * 0.06)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .foregroundColor(isHalfButterChecked ? .green : .clear)
                                )
                                .onTapGesture {
                                    isHalfButterChecked.toggle()
                                }
                            
                        }
                        Text("Egg")
                            .font(.customfont(.regular, fontSize: 17))
                            .foregroundStyle(Color(hex: "#2E3E5C"))
                        
                    }
                    
                }
            }
            
            
        }
    }
}

#Preview {
    IngredientsView()
}
