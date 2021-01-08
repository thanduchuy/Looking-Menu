import UIKit
final class TextRecipeController: UIViewController{
    @IBOutlet private weak var minuteReadyLabel: UILabel!
    @IBOutlet private weak var titleRecipeLabel: UILabel!
    @IBOutlet private weak var priceRecipeLabel: UILabel!
    @IBOutlet private weak var numberServingLabel: UILabel!
    @IBOutlet private weak var stepTaskTabelView: UITableView!
    var recipeFromDetail : Recipe?
    var stepTaskRecipe = [Step]()
    private let idStepTaskTabelView = "StepTaskTableView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextRecipeView()
    }
    
    private func configTextRecipeView() {
        guard let recipe = recipeFromDetail else {
            return
        }
        titleRecipeLabel.text = recipe.title
        APIRecipe.apiRecipe.getinformationRecipeRecipe(idRecipe: recipe.id) { [unowned self] info in
            DispatchQueue.main.async {
                self.minuteReadyLabel.text = "\(info.readyInMinutes) minute"
                self.priceRecipeLabel.text = "\(info.pricePerServing) $"
                self.numberServingLabel.text = "\(info.servings)"
                self.stepTaskRecipe = info.analyzedInstructions[0].steps
                self.stepTaskTabelView.reloadData()
            }
        }
    }
    
    @IBAction private func goBackDetailRecipeView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TextRecipeController : UITableViewDelegate,
                                 UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return stepTaskRecipe.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = stepTaskTabelView.dequeueReusableCell(withIdentifier: idStepTaskTabelView,
                                                        for: indexPath) as? StepTaskCell
        else { return UITableViewCell() }
        let item = stepTaskRecipe[indexPath.row]
        cell.configStepTaskCell(item: item)
        return cell
    }
}
