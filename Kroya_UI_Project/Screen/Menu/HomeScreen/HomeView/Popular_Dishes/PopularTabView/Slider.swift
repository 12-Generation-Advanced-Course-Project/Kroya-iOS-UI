//
//  Slider.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/14/24.
//

import SwiftUI

struct Slide: View {
    @State private var currentPage = 0
    let images = ["slide1", "slide2", "slide3"]
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        GeometryReader{ geometry in
            let screenHeight = geometry.size.height
            let frameHeight = screenHeight * 0.2
        
        VStack(alignment:.leading){
            TabView(selection: $currentPage) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(maxWidth: .infinity, maxHeight: frameHeight) // Dynamically set height
            .cornerRadius(12)
            .onReceive(timer) { _ in
                withAnimation {
                    currentPage = (currentPage + 1) % images.count
                }
            }}
        }.border(.cyan)
    }
}

//#Preview {
//    Slide()
//}
