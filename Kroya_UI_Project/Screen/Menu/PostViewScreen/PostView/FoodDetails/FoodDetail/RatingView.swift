//
//  RatingView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct RatingView: View {
    @State private var selectedRating : Int = 0
    var body: some View {
        //  Reviews section
        GeometryReader { geometry in
            VStack (alignment:.leading, spacing: 10){
                VStack(alignment: .leading, spacing: 15) {
                    Text("Ratings & Review")
                        .font(.system(size: 17))
                        .bold()
                    HStack {
                        VStack{
                            // Text(String(format: "%.1f", percentageOfRating))
                            Text("4.9")
                                .font(.customfont(.bold, fontSize: 34))
                            Text("out of 5")
                                .font(.customfont(.semibold, fontSize: 12))
                            
                        }
                        Spacer()
                        
                        HStack(spacing: 2) {
                            VStack(alignment: .trailing) {
                                HStack(spacing: 15){
                                    HStack(spacing: 2){
                                        ForEach(0..<5) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.customfont(.regular, fontSize: 10))
                                                .foregroundColor(.yellow)
                                        }
                                        
                                    }
                                    RoundedCorner()
                                        .foregroundStyle(Color(hex: "#C7D3EB"))
                                        .frame(width: geometry.size.width * 0.37, height: geometry.size.height * 0.005)
                                }
                                
                                
                                HStack(spacing: 15){
                                    HStack(spacing: 2){
                                        ForEach(0..<4) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.customfont(.regular, fontSize: 10))
                                                .foregroundColor(.yellow)
                                        }
                                        
                                    }
                                    RoundedCorner()
                                        .foregroundStyle(Color(hex: "#C7D3EB"))
                                        .frame(width: geometry.size.width * 0.37, height: geometry.size.height * 0.005)
                                }
                                
                                HStack(spacing: 15){
                                    HStack(spacing: 2){
                                        ForEach(0..<3) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.customfont(.regular, fontSize: 10))
                                                .foregroundColor(.yellow)
                                        }
                                        
                                    }
                                    RoundedCorner()
                                        .foregroundStyle(Color(hex: "#C7D3EB"))
                                        .frame(width: geometry.size.width * 0.37, height: geometry.size.height * 0.005)
                                }
                                HStack(spacing: 15){
                                    HStack(spacing: 2){
                                        ForEach(0..<2) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.customfont(.regular, fontSize: 10))
                                                .foregroundColor(.yellow)
                                        }
                                        
                                    }
                                    RoundedCorner()
                                        .foregroundStyle(Color(hex: "#C7D3EB"))
                                        .frame(width: geometry.size.width * 0.37, height: geometry.size.height * 0.005)
                                }
                                
                                HStack(spacing: 15){
                                    HStack(spacing: 2){
                                        ForEach(0..<1) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.customfont(.regular, fontSize: 10))
                                                .foregroundColor(.yellow)
                                        }
                                        
                                    }
                                    RoundedCorner()
                                        .foregroundStyle(Color(hex: "#C7D3EB"))
                                        .frame(width: geometry.size.width * 0.37, height: geometry.size.height * 0.005)
                                }
                            }
                        }
                    }
                    HStack{
                        Spacer()
                        Text("168 Ratings")
                            .font(.customfont(.medium, fontSize: 12))
                            .foregroundColor(.gray)
                    }
                    
                    
                    
                }
            }
        }
    }}


#Preview {
    RatingView()
}
