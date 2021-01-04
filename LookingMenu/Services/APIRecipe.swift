import Foundation

final class APIRecipe {
    static let apiRecipe = APIRecipe()
    
    private func headerAPI(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = HtthpMethod.Get.rawValue
        request.setValue(Instance.rapidapiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(Instance.rapidapiHost, forHTTPHeaderField: "x-rapidapi-host")
        return request
    }
    
    func getRandomRecipe(numberReturn: Int = 5, getListRecipe:
                            @escaping (_ result : Recipes) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlGetRecipeRandom, numberReturn)
        guard let header = headerAPI(urlString: urlString)
        else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(Recipes.self, from: data)
                getListRecipe(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchRecipeByName(query:String, offset: Int = 10, getListRecipe:
                                @escaping (_ result : ResultSearch) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlSearchRecipeByName, query, offset)
        guard let header = headerAPI(urlString: urlString)
        else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(ResultSearch.self, from: data)
                getListRecipe(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchVideoByName(query:String, getVideoSearch:
                            @escaping (_ result : Videos) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlDataVideoRecipe, query)
        guard let header = headerAPI(urlString: urlString)
        else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(Videos.self, from: data)
                getVideoSearch(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getInformationRecipe(idRecipe: Int, informationRecipe:
                                @escaping (_ result : Information) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlGetDetailRecipe, idRecipe)
        guard let header = headerAPI(urlString: urlString)
        else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(Information.self, from: data)
                informationRecipe(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getEquipmentAndIngredient(idRecipe: Int, getIngredientAndEquipment:
                                    @escaping (_ ingre : Ingredients,_ equip : Equipments) -> Void) {
        let urlStrings = [ String(format: UrlAPIRecipe.urlDataIngredient,
                                  idRecipe),
                           String(format: UrlAPIRecipe.urlDataEquipment,
                                  idRecipe)]
        var ingredient : Ingredients?
        var equipment : Equipments?
        let dispatchGroup = DispatchGroup()
        urlStrings.forEach { element in
            dispatchGroup.enter()
            guard let header = headerAPI(urlString: element) else { return }
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
            guard let ingredient = ingredient,
                  let equipment = equipment
            else { return }
            getIngredientAndEquipment(ingredient, equipment)
        }
    }
}

