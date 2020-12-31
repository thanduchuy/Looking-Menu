import Foundation
struct Ingredients : Codable {
    let ingredients : [Detail]
}

struct Detail : Codable {
    let name : String
    let image : String
}
