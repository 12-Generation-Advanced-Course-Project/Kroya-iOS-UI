//
//  ProfileView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 30/9/24.
//

import SwiftUI

struct ProfileView:View {
    
    @State private var showingCredits = false
    @State private var selectedLanguage: String? = nil
    
    let languages = [
        ("English", "English"),
        ("Khmer", "ភាសាខ្មែរ"),
        ("Korean", "한국")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height:.screenHeight * 0.04)
                HStack{
                    NavigationLink(destination: FavoriteViewCart()){
                        UserInfoCardView( title: "Favorite",
                                          subtitle: "List of their favorite dishes",
                                          width: .screenWidth * 0.44,
                                          height: .screenHeight * 0.11,
                                          isTextCenter: false
                        )
                    }
                    UserInfoCardView( title: "Addresses",
                                      subtitle: "List of your addresses",
                                      width: .screenWidth * 0.44,
                                      height: .screenHeight * 0.11,
                                      isTextCenter: false
                    )
                }
                HStack{
                    NavigationLink(destination: SaleReportView()) {
                        UserInfoCardView( title: "Sale Reports",
                                          subtitle: "List of their favorite dishes",
                                          width: .screenWidth * 0.9,
                                          height: .screenHeight * 0.11,
                                          isTextCenter: true
                        )
                    }
                }
                Spacer().frame(height:.screenHeight * 0.03)
                VStack(alignment:.leading){
                    Text("Payment Method")
                        .font(.customfont(.medium, fontSize: 14))
                    Spacer().frame(height:.screenHeight * 0.02)
                    HStack(spacing:10){
                        Image("ico_link")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("Connected")
                            .font(.customfont(.medium, fontSize: 16))
                        Spacer().frame(width:.screenWidth * 0.25)
                        Text("weBill365")
                            .font(.customfont(.medium, fontSize: 16))
                            .foregroundStyle(.black.opacity(0.75))
                        Image("Rightarrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        
                    }
                    .frame(width: .screenWidth * 0.9,height: .screenHeight * 0.05)
                    .background(Color(hex: "#F4F5F7"))
                    .cornerRadius(15)
                }
                
                Spacer().frame(height:.screenHeight * 0.03)
                VStack(alignment:.leading){
                    Text("App Settings")
                        .font(.customfont(.medium, fontSize: 14))
                    Spacer().frame(height:.screenHeight * 0.02)
                    AppSettingView(
                        imageName: "VectorLocation", title: "Change Location",iconName: "Rightarrow"
                    )

                    NavigationLink {
                        AllowNotificationView()
                    } label: {
                        AppSettingView(
                            imageName: "notification 1", title: "Notifications",iconName: "Rightarrow"
                        )
                    }.accentColor(.black)

                    Button {
                        showingCredits.toggle()
                    } label: {
                       
                        AppSettingView(
                            imageName: "languageIcon", title: "Language",iconName: "Rightarrow"
                        )
                    }.sheet(isPresented: $showingCredits) {
                        ChangeLanguageView()
                    }.accentColor(.black)
                   
                }
                Spacer().frame(height:.screenHeight * 0.04)
                CustomButton(title: "Log out", action: {print("Logout")},backgroundColor: .red, frameWidth: .screenWidth * 0.9)
                Spacer()
            }
            
            
            .navigationTitle("")
            .toolbar {
                // Toolbar items
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("Men")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading){
                            Text("Oun Bonaliheng")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(.black)
                            Spacer().frame(height: 5)
                            Text("Since Oct, 2024")
                                .font(.customfont(.light, fontSize: 12))
                                .foregroundStyle(.black)
                            
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Search button
                    Button(action: { }) {
                        Text("Edit")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundStyle(PrimaryColor.normal)
                    }
                }
            }.padding(.horizontal,10)
        }
    }
}


#Preview {
    ProfileView()
}


