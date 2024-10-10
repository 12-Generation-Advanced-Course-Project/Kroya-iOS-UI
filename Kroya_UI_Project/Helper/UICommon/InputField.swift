//
//  InputField.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 1/10/24.
//

import SwiftUI

struct InputField: View {
    var iconName: String? = nil // Optional icon name
    var placeholder: String
    @Binding var text: String
    var defaultIconName: String = "questionmark.circle.fill"
    var iconColor: Color = .gray
    var backgroundColor: Color = Color(UIColor.systemGray6)
    var frameHeight: CGFloat = 60
    var frameWidth: CGFloat = 20
    var cornerRadius: CGFloat = 10
    var colorBorder: Color = .gray
    var body: some View {
        HStack {
            // Determine which icon to show: system image, custom image, or default image
            if let iconName = iconName, UIImage(systemName: iconName) != nil {
                // Use system image if available
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .padding(.leading, 20)
            } else if let iconName = iconName, let customImage = UIImage(named: iconName) {
                // Use custom image from resources if available
                Image(uiImage: customImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24) // Customize image size
                    .padding(.leading, 20)
            } else {
                // Use the default icon if no valid image is provided or found
                Image(defaultIconName)
                    .foregroundColor(.red)
                    .padding(.leading, 20)
            }
            
            TextField(placeholder, text: $text)
                .font(.customfont(.regular, fontSize: 18))
                .padding(.vertical, 20)
                .frame(minHeight: frameHeight, alignment: .topLeading)
                .keyboardType(.alphabet)
        }
        .background(backgroundColor)
        .frame(width: frameWidth,height: frameHeight)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    colorBorder,
                    style: StrokeStyle(
                        lineWidth: 1
                    )
                )
        )
        
    }
}

#Preview {
    VStack {
        InputField(placeholder: "Tell me a little about your food", text: .constant(""),backgroundColor: .white,frameHeight: .screenHeight * 0.2, frameWidth:.screenWidth * 0.9,colorBorder: Color(hex: "#D0DBEA"))

    }
  

}


