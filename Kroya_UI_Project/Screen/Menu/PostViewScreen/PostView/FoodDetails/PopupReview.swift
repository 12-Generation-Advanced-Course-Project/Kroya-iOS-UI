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
    @State var description: String = ""
    @State var showWarning = false
    @Binding var isReviewPopupOpen: Bool
    
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
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
                            .onChange(of: description){ userInput in
                                if userInput.count > 300{
                                    description = String(userInput.prefix(300))
                                    showWarning = true
                                } else {
                                    showWarning = false
                                }
                                
                                
                            }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.vertical,10)
                    HStack{
                        // Warning Message
                        if showWarning {
                            Text("Maximum character limit of 300 exceeded")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("\(description.count)/300")
                          
                            .foregroundColor(.black.opacity(0.3))
                    }  .font(.customfont(.medium, fontSize: 12))
                    Spacer().frame(height: 70)
                    HStack{
                        Button (action: {
                            isReviewPopupOpen = false
                        }){
                            Text("Cencel")
                                .frame(width: 100,height: 45)
                                .font(.customfont(.semibold, fontSize: 16))
                                .background(Color(hex: "#F4F5F7"))
                                .cornerRadius(10)
                                .foregroundColor(.black)
                                .opacity(0.8)
                        }
                        Button (action: {
                            isReviewPopupOpen = false
                        }){
                            Text("Post")
                                .frame(width: 100,height: 45)
                                .font(.customfont(.semibold, fontSize: 16))
                                .background(Color.yellow)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
        
    }
}

