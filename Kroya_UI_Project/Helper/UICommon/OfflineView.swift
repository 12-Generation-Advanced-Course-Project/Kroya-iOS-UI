//
//  OfflineView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 5/11/24.
//

import SwiftUI

struct OfflineMessageView: View {
    var retryAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("No connection-bro")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 95, height: 95)
                
                Text("Looks like you are offline")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("Please check your internet connection and try again")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Button(action: retryAction) {
                    Text("Try again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: 280) // Adjust width and max height
            .padding(.vertical, 30) // Top and bottom padding for the content
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 10)
        }
    }
}

struct OfflineMessageView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineMessageView(retryAction: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
