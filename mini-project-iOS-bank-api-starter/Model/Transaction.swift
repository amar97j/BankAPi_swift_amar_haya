import Foundation

struct Transaction: Codable {
    let senderId: Int?
    let receiverId: Int?
    let amount: Double
    let type: String
}

