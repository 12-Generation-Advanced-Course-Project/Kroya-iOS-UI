//
//  NetworkUtils.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 27/9/24.
//

// NetworkUtils.swift
import Network
import SwiftUI

class NetworkUtils {
    
    static func isConnectedToInternet() -> Bool {
        let monitor = NWPathMonitor()
        var isConnected = false
        monitor.pathUpdateHandler = { path in
            isConnected = (path.status == .satisfied)
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        return isConnected
    }
    
    static func showNoInternetPopup() -> some View {
        VStack {
            Text("No Internet Connection")
                .font(.headline)
                .padding()
            Button(action: {
               
            }) {
                Text("Retry")
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
