//
//  APIService.swift
//  Thực Đơn
//
//  Created by Huy Than Duc on 26/12/2020.
//

import Foundation

class APIRecipe {

    var delegate: DataDelegate?
    static let apiRecipe = APIRecipe()
    var searchByName: SearchByName?
    
    func headerAPI(urlString: String) -> URLRequest {
        guard let url = URL(string: urlString) else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Instance.rapidapiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(Instance.rapidapiHost, forHTTPHeaderField: "x-rapidapi-host")
        return request
    }
    
    func getRandomRecipe(number: Int = 5) {
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random?number=\(number)"
        let header = self.headerAPI(urlString: urlString)
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Recipes.self, from: data!)
                self.delegate?.listRecipeRandom(recipes: response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchRecipeByName(query:String,number: Int = 10) {
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?query=\(query)&number=\(number)"
        let header = self.headerAPI(urlString: urlString)
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ResultSearch.self, from: data!)
                self.searchByName?.getResultSearch(result: response)
            } catch {
                print(error)
            }
        }.resume()
    }
}
