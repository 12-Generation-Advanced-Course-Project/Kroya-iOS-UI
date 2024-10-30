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
    @State private var isHalfButterChecked1 = false
    @State private var navigateToCheckout = false // State variable to control navigation
       
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack (alignment:.leading, spacing: 4){
                
                
                HStack{
                    Text("Somlor Mju")
                        .font(.customfont(.bold, fontSize: 20))
                    Spacer()
                    
             // Button Order
                    
                    Button(action : {
                        navigateToCheckout = true // Set to true to trigger navigation
                    })
                    {
                        HStack {
                            Text("Order")
                                .font(.customfont(.medium, fontSize: 16))
                                .foregroundStyle(.white)
                            Image(systemName: "plus")
                                .resizable()
                               .frame(width: 14, height: 14)
                               
                                .foregroundStyle(Color.white)
                            
                        }
                       
                        .frame(width: geometry.size.width * 0.28, height: geometry.size.height * 0.09)
                        .background(PrimaryColor.normal)
                        .cornerRadius(geometry.size.width * 0.022)
                    }
                    
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
                Spacer().frame(height: geometry.size.height * 0.008)
                
        //Description
                Text("Description")
                    .font(.customfont(.bold, fontSize: 18))
                Text("In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutorial, we’ll delve into the seamless integration of UIKit’s UITableView in SwiftUI, exploring step-by-step how to create project.In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutorial, we’ll delve into the seamless integration of UIKit’s UITableView in SwiftUI, exploring step-by-step how to create project.In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutorial, we’ll delve into the seamless integration of UIKit’s UITableView in SwiftUI, exploring step-by-step how to create project.")
                    .font(.customfont(.regular, fontSize: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(10, reservesSpace: true)
                    .opacity(0.6)
                Spacer().frame(height: geometry.size.height * 0.008)
        //Ingredients
                Text("Ingredients")
                    .font(.customfont(.bold, fontSize: 18))
                Spacer().frame(height: geometry.size.height * 0.003)
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
                    HStack {
                        Button(action: {}){
                            Circle()
                                .fill(isHalfButterChecked1 ?   Color.green.opacity(0.3): Color.clear)
                                .stroke(isHalfButterChecked1 ? Color.clear : Color.gray, lineWidth: 1)
                                .frame(width: geometry.size.width * 0.06)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .foregroundColor(isHalfButterChecked1 ? .green : .clear)
                                )
                                .onTapGesture {
                                    isHalfButterChecked1.toggle()
                                }
                            
                        }
                        Text("1/2 Sugar")
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
