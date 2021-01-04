import Foundation
final class APIRecipe {
    static let apiRecipe = APIRecipe()
    var delegate: RecipeRandomDelegate?
    var searchByName: RecipeSearchDelegate?
    var searchByVideo: VideoRecipeDelegate?
    var igredientAndEquipment : DetailRecipeDelegate?
    var informationRecipe : TextRecipeDelegate?
    
    private func headerAPI(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Instance.rapidapiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(Instance.rapidapiHost, forHTTPHeaderField: "x-rapidapi-host")
        return request
    }
    
    func getRandomRecipe(numberReturn: Int = 5) {
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random?number=\(numberReturn)"
        guard let header = self.headerAPI(urlString: urlString),
              let delegate = self.delegate else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(Recipes.self, from: data)
                delegate.getListRecipe(recipes: response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchRecipeByName(query:String,numberReturn: Int = 10) {
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?query=\(query)&number=\(numberReturn)"
        guard let header = self.headerAPI(urlString: urlString),
              let searchByName = self.searchByName  else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(ResultSearch.self, from: data)
                searchByName.getListRecipe(result: response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchVideoByName(query:String) {
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/videos/search?query=\(query)&number=1"
        guard let header = self.headerAPI(urlString: urlString),
              let searchByVideo = self.searchByVideo else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(Videos.self, from: data)
                searchByVideo.getVideoSearch(result: response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getInformationRecipe(idRecipe: Int) {
        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(idRecipe)/information"
        guard let header = self.headerAPI(urlString: urlString),
              let informationRecipe = self.informationRecipe else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(Information.self, from: data)
                informationRecipe.getInfoRecipe(result: response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getEquipmentAndIngredient(idRecipe: Int) {
        let urlStrings = [ "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(idRecipe)/ingredientWidget.json",
            "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(idRecipe)/equipmentWidget.json"]
        var ingredient : Ingredients?
        var equipment : Equipments?
        let dispatchGroup = DispatchGroup()
        urlStrings.forEach { element in
            dispatchGroup.enter()
            guard let header = self.headerAPI(urlString: element) else { return }
            URLSession.shared.dataTask(with: header) { (data, response, error) in
                do {
                    let decoder = JSONDecoder()
                    guard let data = data else { return }
                    if element.contains("ingredientWidget") {
                        let response = try decoder.decode(Ingredients.self, from: data) as Ingredients
                        DispatchQueue.main.async {
                            ingredient = response
                            dispatchGroup.leave()
                        }
                    } else {
                        let response = try decoder.decode(Equipments.self, from: data) as Equipments
                        DispatchQueue.main.async {
                            equipment = response
                            dispatchGroup.leave()
                        }
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
        dispatchGroup.notify(queue: .main) {
            guard let igredientAndEquipment = self.igredientAndEquipment,
                  let ingredient = ingredient,
                  let equipment = equipment
            else { return }
            igredientAndEquipment.getIngredientAndEquipment(ingredient: ingredient,
                                                            equipment: equipment)
        }
    }
}

