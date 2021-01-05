import Foundation

struct Recipes : Codable {
    let recipes: [Recipe]
}

struct Recipe : Codable {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String
}

