import Foundation

protocol RecipeRandomDelegate {
    func getListRecipe(recipes : Recipes)
}

protocol RecipeSearchDelegate {
    func getListRecipe(result: ResultSearch)
}

protocol DetailRecipeDelegate {
    func getIngredientAndEquipment(
        ingredient : Ingredients,
        equipment : Equipments)
}

protocol VideoRecipeDelegate {
    func getVideoSearch(result: Videos)
}

protocol TextRecipeDelegate {
    func getInfoRecipe(result: Information)
}

