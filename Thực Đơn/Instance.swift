//
//  Instance.swift
//  Thực Đơn
//
//  Created by Huy Than Duc on 25/12/2020.
//

import Foundation

class Instance {
    static let rapidapiKey = "64d053b7f8mshd1658251aeae910p1375c4jsn85fd7ab7b280"
    static let rapidapiHost = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    static let idResultSearchCell = "ResultSearchCell"
    static let idTabBarCell = "TabBarCell"
    static let idRecipeHomeCell = "RecipeHomeCell"
    static let tabBars : [TabBar] = [
        TabBar(icon: "home", label: "Home"),
        TabBar(icon: "favorite", label: "Saved"),
        TabBar(icon: "circular", label: "Diet"),
        TabBar(icon: "vegetarian", label: "Items")
    ]
}
