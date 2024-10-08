//
//  UserBasicInfoView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 7/10/24.
//

import SwiftUI

struct UserBasicInfoView: View {
    
    
    @State private var textName = ""
    @State private var textEmail = ""
    @State private var textLocation = ""
    @Environment(\.dismiss) var dismiss
  
    var body: some View {
        VStack(spacing:20){
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            // Title
            Text("Basic Information")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            //User Input
            VStack(spacing:20){
                VStack(alignment:.leading,spacing: 5){
                    Text("Username")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    InputField(iconName: "person.text.rectangle", placeholder: "Full name", text: $textName)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    InputField(iconName: "mail.fill", placeholder: "example@gmail.com", text: $textEmail)
                }
                
                NavigationLink(destination: MainScreen()){
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Address")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        HStack{
                            Image("pinmap")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                                .padding(.leading,20)
                            Text("Your Location")
                                .font(.customfont(.regular, fontSize: 18))
                                .padding(.vertical,20)
                                .foregroundColor(.gray)
                                .keyboardType(.default)
                                .frame(width: .screenWidth * 0.3)
                            Spacer()
                            
                        } .background(Color(hex: "#F2F2F7"))
                            .cornerRadius(10)
                            .frame(height: 60)
                    }
                }
            }
            // Save Button
            //                CustomButton(title: "Save", action: {},frameWidth: .screenWidth * 0.9)
            //                    .padding(.top,10)
            NavigationLink(destination: MainScreen(), label: {
                Text("Save")
                    .font(.customfont(.semibold, fontSize: 16))
                    .frame(width: .screenWidth * 0.83)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            )
            // Skip Button
            Button(action: {}) {
                Text("Skip")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .padding(.horizontal, 20)
    }
    
}

#Preview {
  
    UserBasicInfoView()
}
