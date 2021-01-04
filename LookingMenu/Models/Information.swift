import Foundation

struct Information : Codable {
    let readyInMinutes : Int
    let servings : Int
    let pricePerServing : Float
    let analyzedInstructions : [Steps]
}

struct Step : Codable {
    let number : Int
    let step : String
}

struct Steps : Codable {
    let steps : [Step]
}

