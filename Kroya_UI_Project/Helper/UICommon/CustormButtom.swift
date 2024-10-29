//
//  CustormButtom.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 1/10/24.
//

import SwiftUI


import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var backgroundColor: Color
    var textColor: Color = .white
    var frameHeight: CGFloat = 60
    var cornerRadius: CGFloat = 10
    var fontSize: CGFloat = 18
    var frameWidth: CGFloat? = nil  // Make frameWidth optional
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.customfont(.semibold, fontSize: fontSize))
                .frame(maxWidth: frameWidth ?? .infinity) // Use the available width
                .frame(height: frameHeight)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(cornerRadius)
        }
    }
}

