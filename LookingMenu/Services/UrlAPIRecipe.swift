import Foundation

final class UrlAPIRecipe {
    static let urlGetRecipeRandom =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random?number=%d"
    static let urlSearchRecipeByName =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?query=%@&number=%d"
    static let urlGetDetailRecipe =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/%d/information"
    static let urlDataVideoRecipe =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/videos/search?query=%@&number=1"
    static let urlDataIngredient =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/%d/ingredientWidget.json"
    static let urlDataEquipment =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/%d/equipmentWidget.json"
}

