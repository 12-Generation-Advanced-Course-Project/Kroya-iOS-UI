//
//  PaywithKHQRModalView.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 17/10/24.
//

import SwiftUI


struct PaywithKHQRModalView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment:.leading){
            Spacer().frame(height: 40)
            Image("webill365_logo_full 1")
                .resizable()
                .scaledToFit()
                .frame(width: 70,height: 15)
            
            
            VStack {
                Text("Scan QR Code")
                    .font(.customfont(.semibold, fontSize: 24))
                Spacer().frame(height: 10)
                Text("Download this QR Code for payment")
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundStyle(.black.opacity(0.8))
                Spacer().frame(height: 15)
                QRCodeView(text: "00020101021130450016abaakhppxxx@abaa01090045514050208ABA Bank40390006abaP2P0112B7A47E5B00EA02090045514055204000053031165802KH5914OUN BONALIHENG6010Phnom Penh6304AFE1", size: 200)
                Spacer().frame(height: 20)
                Button {
                    print("Payment")
                } label: {
                    HStack{
                        Image(systemName: "arrowshape.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20,height: 20)
                            .accentColor(.white)
                        Text("Download QR Code")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundStyle(.white)
                    }
                }
                
                .frame(maxWidth: .screenWidth,minHeight: 50,alignment: .center)
                .background(PrimaryColor.normal)
                .cornerRadius(10)
                .padding()
                Text("Not Now")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(PrimaryColor.normal)
                    .onTapGesture{
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity,minHeight: .screenHeight * 0.05,alignment: .center)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 20)
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

#Preview {
    PaywithKHQRModalView()
}
