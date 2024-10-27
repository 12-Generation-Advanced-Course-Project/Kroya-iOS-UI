//
//  TittleView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct TittleView: View {
    @State private var isEggChecked = true
    @State private var isButterChecked = true
    @State private var isHalfButterChecked = false
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
        //Description
                Text("Description")
                    .font(.customfont(.bold, fontSize: 18))
                Text("In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutorial, we’ll delve into the seamless integration of UIKit’s UITableView in SwiftUI, exploring step-by-step how to create a robust and interactive TableView within your SwiftUI project.")
                    .lineLimit(3)
                    .font(.customfont(.regular, fontSize: 14))
                    .opacity(0.6)
                
        //Ingredients
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
    TittleView()
}
