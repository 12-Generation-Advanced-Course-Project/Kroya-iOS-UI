//
//  DescriptionView.swift
//  Kroya_UI_Project
//
//  Created by Macbook on 10/23/24.
//

import SwiftUI

struct DescriptionView: View {
    var body: some View {
        GeometryReader{ geometry in
            // Recipe description
            VStack (alignment:.leading, spacing: 10){
                Text("Description")
                    .font(.customfont(.bold, fontSize: 18))
                Text("In the dynamic world of iOS development, harnessing the power of both SwiftUI and UIKit opens up a realm of possibilities. In this tutorial, we’ll delve into the seamless integration of UIKit’s UITableView in SwiftUI, exploring step-by-step how to create a robust and interactive TableView within your SwiftUI project.")
                    .lineLimit(3)
                    .font(.customfont(.regular, fontSize: 14))
                    .opacity(0.6)
                
                
                
            }}
    }
}

//#Preview {
//    DescriptionView()
//}
