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
    
    func getDataToAPIRecipe<T: Decodable>(from path: String,
                                          completion: @escaping (T) -> ()) {
        guard let header = self.headerAPI(urlString: path)
        else { return }
        URLSession.shared.dataTask(with: header) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                guard let data = data else { return }
                let response = try decoder.decode(T.self, from: data)
                completion(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func getRandomRecipe(offset: Int = 5, getListRecipe:
                            @escaping (_ result : Recipes) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlGetRecipeRandom, offset)
        getDataToAPIRecipe(from: urlString, completion: getListRecipe)
    }
    
    func searchRecipeByName(query:String, offset: Int = 10, getListRecipe:
                                @escaping (_ result : ResultSearch) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlSearchRecipeByName, query, offset)
        getDataToAPIRecipe(from: urlString, completion: getListRecipe)
        
    }
    
    func searchVideoByName(query:String, getVideoSearch:
                            @escaping (_ result : Videos) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlDataVideoRecipe, query)
        getDataToAPIRecipe(from: urlString, completion: getVideoSearch)
    }
    
    func getInformationRecipe(idRecipe: Int, informationRecipe:
                                @escaping (_ result : Information) -> Void) {
        let urlString = String(format: UrlAPIRecipe.urlGetDetailRecipe, idRecipe)
        getDataToAPIRecipe(from: urlString, completion: informationRecipe)
    }
    
    func getEquipmentAndIngredient(idRecipe: Int, getIngredientAndEquipment:
                                    @escaping (_ ingre : Ingredients,_ equip : Equipments) -> Void) {
        let urlStrings = [ String(format: UrlAPIRecipe.urlDataIngredient,
                                  idRecipe),
                           String(format: UrlAPIRecipe.urlDataEquipment,
                                  idRecipe)]
        var ingredient : Ingredients?
        var equipment : Equipments?
        
        func doIngredient(process: Ingredients) -> Void {
            ingredient = process
            dispatchGroup.leave()
        }
        
        func doEquipment(process: Equipments) -> Void {
            equipment = process
            dispatchGroup.leave()
        }
        
        let dispatchGroup = DispatchGroup()
        
        urlStrings.forEach { element in
            dispatchGroup.enter()
            if element.contains("ingredientWidget") {
                DispatchQueue.main.async {
                    self.getDataToAPIRecipe(from: element, completion: doIngredient)
                }
            } else {
                DispatchQueue.main.async {
                    self.getDataToAPIRecipe(from: element, completion: doEquipment)
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            guard let ingredient = ingredient,
                  let equipment = equipment
            else { return }
            getIngredientAndEquipment(ingredient, equipment)
        }
    }
}
