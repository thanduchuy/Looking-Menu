import Foundation
struct Diet: Codable {
    var id: Int = 1
    var name: String
    var calor: Double
    var recipeSessions: [RecipeSession]
    
    init(id: Int = 1,
         name: String,
         calor: Double,
         recipeSessions: [RecipeSession]) {
        self.id = id
        self.name = name
        self.calor = calor
        self.recipeSessions = recipeSessions
    }
}

struct RecipeSession: Codable {
    let date: Date
    let recipes: [RecipeDiet]
    
    init(date: Date, recipes: [RecipeDiet]) {
        self.date = date
        self.recipes = recipes
    }
}

struct RecipeDiet: Codable {
    let id: Int
    let title: String
    let image: String
}
