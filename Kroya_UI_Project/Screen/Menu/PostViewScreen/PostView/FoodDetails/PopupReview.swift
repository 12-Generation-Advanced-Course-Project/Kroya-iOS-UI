//
//  PopupReview.swift
//  Kroya_UI_Project
//
//  Created by PVH_003 on 20/10/24.
//

import SwiftUI

struct PopupReview: View {
    
    var profile: String
    var userName: String
    @State var description: String
    @Binding var isReviewPopupOpen: Bool
    var isPopup: Bool = false
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            VStack{
                // Close button
                Button(action: {
                    // Action to dismiss the popup
                    isReviewPopupOpen = false
                    
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                        .padding(.bottom, 700) // Adjust to place it at the top
                        .padding(.leading, 300)
                }
            }
            
            VStack(alignment: .leading){
                
                HStack(spacing: 10){
                    Image(profile)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                    VStack(alignment: .leading,spacing: 6){
                        Text(userName)
                            .font(.customfont(.bold, fontSize: 17))
                            .bold()
                        HStack(spacing: 2) {
                            ForEach(0..<5) { star in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 15))
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 35)
//                .padding(.vertical,10)
                HStack{
                    Button(action: {}){
                        Image("note")
                            .resizable()
                            .frame(width: 17, height: 17)
                        Text("Write a Review").foregroundStyle(Color.yellow)
                            .font(.customfont(.medium, fontSize: 15))
                    }
                }
                VStack(alignment: .trailing){
                    VStack{
                        TextField("Describe your experience", text: $description, axis: .vertical)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .frame(maxWidth: .screenWidth * 0.9,minHeight: 150, alignment: .topLeading)
                            .font(.customfont(.medium, fontSize: 15))
                            .foregroundStyle(.black.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(Color(hex: "#D0DBEA"), lineWidth: 1)
                            )
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.vertical,10)
                    Text("\(description.count)/300")
                        .font(.customfont(.medium, fontSize: 12))
                        .foregroundColor(.black.opacity(0.3))
                    Spacer().frame(height: 90)
                    Button (action: {
                        
                    }){
                        Text("Post")
                            .frame(width: 100,height: 50)
                            .font(.customfont(.semibold, fontSize: 16))
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity,maxHeight: 500)
            .padding()
            
        }
        .edgesIgnoringSafeArea(.all)

    }
}

//#Preview {
//    PopupReview(profile: "ahmok1", userName: "Chhoy Sreynoch", description: "", isReviewPopupOpen: $isPopup)
//}
