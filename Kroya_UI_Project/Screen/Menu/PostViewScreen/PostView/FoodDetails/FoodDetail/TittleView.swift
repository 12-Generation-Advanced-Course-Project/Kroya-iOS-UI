//
//  TittleView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct TittleView: View {
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack (alignment:.leading, spacing: 10){
                
                
                HStack{
                    Text("Somlor Mju")
                        .font(.customfont(.bold, fontSize: 20))
                    Spacer()
                    
             // Button Order
//                    Button(action : {})
//                    {
//                        HStack {
//                            Text("Order")
//                                .font(.customfont(.regular, fontSize: 16))
//                                .foregroundStyle(.white)
//                            Image(systemName: "plus")
//                                .resizable()
//                               .frame(width: 14, height: 14)
//                               
//                                .foregroundStyle(Color.white)
//                            
//                        }
//                       
//                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.0389)
//                        .cornerRadius(geometry.size.width * 0.5)
//                        .background(PrimaryColor.normal)
//                        
//                    }
                }
                
                HStack(spacing: 10){
                    // Group{
                    Text("$3.05")
                        .foregroundStyle(Color.yellow)
                        .font(.customfont(.regular, fontSize: 13))
                    Text("5 May 2023 (Morning)")
                        .opacity(0.5)
                
                        .font(.customfont(.regular, fontSize: 13))
                    
                }
                
                
                HStack(spacing: 10){
                    Text("Soup")
                    Circle().fill()
                        .frame(width: 6, height: 6)
                    Text("60 mins")
                    
                }.font(.customfont(.medium, fontSize: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(Color(hex:"#9FA5C0"))
                
         // Profile
                Spacer().frame(height: geometry.size.height * 0.012)
               
                HStack(spacing: 10){
                    Image("Men")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.14 )
                        .clipShape(Circle())
                    
                    Text("Sreng Sodanne")
                        .font(.customfont(.bold, fontSize: 17))
                        .bold()
                }
            }
            
            
        }
    }
}

//#Preview {
//    TittleView()
//}
