//
//  Success.swift
//  Kroya
//
//  Created by KAK-LY on 15/10/24.
//

import SwiftUI

struct Success: View {
    var body: some View {
//        VStack {
            // Success Header Section
            VStack{
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(red: 0.242, green: 0.741, blue: 0.307))
                
                Text("Success")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
            }
//        }
    }
}

#Preview {
    Success()
}
