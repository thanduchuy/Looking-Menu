import Foundation

struct Videos : Codable {
    let videos : [Video]
}

struct Video : Codable {
    let shortTitle : String
    let youTubeId : String
    let rating : Float
    let views : Int
    let thumbnail: String
    let length : Int
}

