//
//  DeliveryCardDetailViewModel.swift
//  Kroya
//
//  Created by KAK-LY on 11/10/24.
//

import SwiftUI

class DeliveryCardDetailViewModel: ObservableObject {
    
    @Published var deliveryInfo: DeliveryInfo
    
    init(deliveryInfo: DeliveryInfo) {
        self.deliveryInfo = deliveryInfo
    }
    
}
