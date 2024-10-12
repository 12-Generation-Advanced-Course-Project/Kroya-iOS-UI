//
//  InputField.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 1/10/24.
//

import SwiftUI

struct InputField: View {
    var iconName: String? = nil
    var placeholder: String
    @Binding var text: String
//    var defaultIconName: String = "questionmark.circle.fill"
    var iconColor: Color = .gray
    var backgroundColor: Color = Color(UIColor.systemGray6)
    var frameHeight: CGFloat = 60
    var frameWidth: CGFloat = 20
    var cornerRadius: CGFloat = 15
    var colorBorder: Color = .gray
    var isMultiline: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
           
            
            HStack {
                if !isMultiline {
                    if let iconName = iconName, UIImage(systemName: iconName) != nil {
                        Image(systemName: iconName)
                            .foregroundColor(iconColor)
                            .padding(.leading, 16)
                    } else if let iconName = iconName, let customImage = UIImage(named: iconName) {
                        Image(uiImage: customImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .padding(.leading, 16)
                    } else {
//                        Image(defaultIconName)
//                            .foregroundColor(.red)
//                            .padding(.leading, 16)
                    }
                }
                
                // Switch between TextField and TextEditor based on `isMultiline`
                if isMultiline {
                    TextEditor(text: $text)
                        .font(.customfont(.regular, fontSize: 18))
                        .frame(minHeight: frameHeight)
                        .padding(.horizontal,8)
                        .background(Color.clear)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.customfont(.regular, fontSize: 18))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 8)
                }
            }
        }
        .padding(.vertical, 10)
        .frame(height: frameHeight)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(colorBorder, lineWidth: 1)
        )
        .frame(width: frameWidth)
    }
}

#Preview {
    VStack {
        // Single-line example for email with icon
        InputField(iconName: "mail.fill", placeholder: "Email", text: .constant(""), frameHeight: 60, frameWidth: .screenWidth * 0.9, colorBorder: Color(hex: "#D0DBEA"), isMultiline: false)
        
        Spacer().frame(height: 15)
        
        // Multiline example for description with icon
        InputField(placeholder: "Tell me a little about your food", text: .constant(""), frameHeight: .screenHeight * 0.2, frameWidth: .screenWidth * 0.9, colorBorder: Color(hex: "#D0DBEA"), isMultiline: true)
    }
}



