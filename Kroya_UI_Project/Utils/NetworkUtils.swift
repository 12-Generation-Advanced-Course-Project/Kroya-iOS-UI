//
//  NetworkUtils.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 27/9/24.
//

// NetworkUtils.swift
import Network

struct NetworkUtils {
    static func isConnectedToInternet() -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
        }
        monitor.start(queue: queue)
        return isConnected
    }
}
