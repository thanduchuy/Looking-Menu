import Foundation
protocol DataDelegate {
    func listRecipeRandom(recipes : Recipes)
}

protocol SearchByName  {
    func getResultSearch(result: ResultSearch)
}

protocol SearchVideoByID  {
    func getResultSearch(result: Videos)
}

protocol IngredientAndEquipment  {
    func getIngredientAndEquipment(
        ingredient : Ingredients,
        equipment : Equipments)
}
