////
////  CardRecipe.swift
////  Kroya_UI_Project
////
////  Created by KAK-LY on 22/10/24.
////
//
//
//import SwiftUI
//
//struct CardRecipe: View {
//    
//    @State private var isFavorite: Bool = false
//    var iselected:Int?
//    var imageName: String?
//    var dishName: String?
//    var cookingDate: String?
//    var status: String?
//    var rating: Double?
//    var reviewCount: Int?
//    var level: String?
//    var framewidth: CGFloat
//    var frameheight: CGFloat
//    var frameWImage: CGFloat
//    var frameHImage: CGFloat
//    var Spacing:CGFloat
//    var offset:CGFloat
//    
//    
//    private let referenceWidth: CGFloat = 375
//    private let referenceHeight: CGFloat = 667
//    
//    var cardWidth: CGFloat {
//        UIScreen.main.bounds.width / referenceWidth * framewidth
//    }
//    
//    var cardHeight: CGFloat {
//        UIScreen.main.bounds.height / referenceHeight * frameheight
//    }
//    
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                // Image Section
//                Image(imageName ?? "")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: frameWImage , height: frameHImage )
//                    .cornerRadius(15, corners: [.topLeft, .topRight])
//                    .clipped()
//                  
//                // Rating and Reviews
//                HStack(spacing: Spacing){
//                    HStack(spacing: 2) {
//                        Image(systemName: "star.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 12, height: 12)
//                            .foregroundColor(.yellow)
//                        
//                        Text(String(format: "%.1f", rating ?? ""))
//                            .font(.customfont(.medium, fontSize: 11))
//                            .foregroundColor(.black)
//                        
//                        Text("(\(reviewCount)+)")
//                            .font(.customfont(.medium, fontSize: 11))
//                            .foregroundColor(.gray)
//
//                    }
//                    .frame(width:  UIScreen.main.bounds.width / referenceWidth * 85, height: UIScreen.main.bounds.height / referenceHeight * 20)
//                    .background(Color.white.opacity(0.8))
//                    .cornerRadius(10)
//                    .shadow(color: PrimaryColor.normal.opacity(0.25),radius: 5,y:4)
//                
//
//                    VStack {
//                        HStack {
//                            Button(action: {
//                                isFavorite.toggle()
//                            }) {
//                                Circle()
//                                    .fill(isFavorite ? Color.red : Color.white.opacity(0.5))
//                                    .frame(width: 25, height: 25)
//                                    .overlay(
//                                        Image(systemName: "heart.fill")
//                                            .foregroundColor(.white)
//                                            .font(.system(size: 16))
//                                    )
//                            }
//                            .shadow(color: isFavorite ? Color.red.opacity(0.5) : Color.gray.opacity(0.5), radius: 4, x: 0, y: 4)
//
//                        }
//
//                    }
//               
//                }.offset(y:offset)
//            }
//            
//            
//            Spacer()
//                .frame(height: 5)
//            // Content Section
//            VStack(alignment: .leading, spacing: 4) {
//                // Dish Name
//                Text(dishName ?? "")
//                    .font(.customfont(.medium, fontSize: 14))  // Dynamic font size
//                    .foregroundColor(.black)
//
//                // Cooking Date Information
//                Text("It will be cooked on ")
//                    .font(.customfont(.light, fontSize:9))
//                    .foregroundColor(.gray) +
//                Text(cookingDate)
//                    .font(.customfont(.light, fontSize: 9))
//                    .foregroundColor(.yellow) +
//                Text(" in the morning.")
//                    .font(.customfont(.medium, fontSize: 9))
//                    .foregroundColor(.gray)
//
//                // Price and Delivery Info
//                HStack {
//                    Text(status)
//                        .font(.customfont(.medium, fontSize: 12))
//                        .foregroundColor(.yellow)
//                    
//                    HStack(spacing: 4) {
//                    
//                        Text(level)
//                            .font(.customfont(.light, fontSize: 12))
//                            .foregroundColor(.gray)
//                    }
//                    Spacer()
//                }
//            }
//            .padding(.bottom,15)
//            .frame(width: cardWidth * 0.9, height: cardHeight * 0.35)
//            .background(Color.white)
//            .cornerRadius(10)
//
//            
//        }
//        .frame(width: cardWidth, height: cardHeight)
//        .background(Color.white)
//        .cornerRadius(15)
//        .overlay {
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(Color(hex: "#E6E6E6"), lineWidth: 0.8)
//        }
//    }
//}
//
//#Preview {
//    CardRecipe(
//        imageName: "SomlorKari",
//        dishName: "Somlor Kari",
//        cookingDate: "30 Sep 2024",
//        status: "Recipe",
//        rating: 5.0,
//        reviewCount: 200,
//        level: "Easy",
//        framewidth:230,
//        frameheight:160,
//        frameWImage:300,
//        frameHImage:135,
//        Spacing:120,
//        offset:-45
//    )
//}
//
