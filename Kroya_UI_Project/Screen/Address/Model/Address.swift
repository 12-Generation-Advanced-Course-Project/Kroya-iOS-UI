import Foundation

struct AddressResponse: Codable {
    let message: String
    let payload: [Address]
    let statusCode: String
    let timestamp: String
}

struct SingleAddressResponse: Codable {
    let message: String
    let payload: Address
    let statusCode: String
    let timestamp: String
}

struct Address: Codable, Identifiable {
    var id: Int
    var addressDetail: String
    var specificLocation: String
    var tag: String
    var latitude: Double
    var longitude: Double
}
