//
//  SplashScreen.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 1/10/24.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var isActive = false
    @StateObject private var userStore = UserStore()
    var body: some View {
        if isActive {
            LoginScreenView(userStore: userStore)
                           .environmentObject(userStore)
        } else {
            ZStack {
                Color(.yellow)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("KroyaWhiteLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
            }
            
            .onAppear {
                // Delay for 3 seconds then switch to LoginView
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
