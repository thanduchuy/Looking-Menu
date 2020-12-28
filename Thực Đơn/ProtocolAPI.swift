//
//  ProtocolAPI.swift
//  Thực Đơn
//
//  Created by Huy Than Duc on 27/12/2020.
//

import Foundation

protocol DataDelegate {
    func listRecipeRandom(recipes : Recipes)
}
protocol SearchByName  {
    func getResultSearch(result: ResultSearch)
}
