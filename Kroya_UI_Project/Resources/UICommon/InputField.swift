//
//  InputField.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 1/10/24.
//

import SwiftUI

struct InputField: View {
    var iconName: String
    var placeholder: String
    @Binding var text: String
    var iconColor: Color = .gray
    var backgroundColor: Color = Color(UIColor.systemGray6)
    var frameHeight: CGFloat = 60
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        HStack {
            if UIImage(systemName: iconName) != nil {
                // Use system image if available
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .padding(.leading, 20)
            } else if let customImage = UIImage(named: iconName) {
                // Use custom image if available in resources
                Image(uiImage: customImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24) // Customize image size
                    .padding(.leading, 20)
            } else {
                // Fallback to a default icon if neither system nor custom image exists
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.red)
                    .padding(.leading, 20)
            }
            
            TextField(placeholder, text: $text)
                .font(.customfont(.regular, fontSize: 18))
                .padding(.vertical, 20)
                .padding(.horizontal, 5)
                .keyboardType(.alphabet)
               
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .frame(height: frameHeight)
    }
}

#Preview {
    InputField(iconName: "phone.fill", placeholder: "Enter phone number", text: .constant(""))
}

