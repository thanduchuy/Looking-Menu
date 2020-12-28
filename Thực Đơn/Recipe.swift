//
//  Recipe.swift
//  Thực Đơn
//
//  Created by Huy Than Duc on 26/12/2020.
//

import Foundation

struct Recipes : Codable {
    let recipes : [Recipe]
}

struct Recipe : Codable {
    let id : Int
    let title : String
    let readyInMinutes : Int
    let image : String
}
