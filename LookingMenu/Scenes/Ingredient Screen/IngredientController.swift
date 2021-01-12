import UIKit

protocol IngredientTableViewDelegate: class {
    func removeIngredientCell(title: String)
}

private enum ConstantIngredientView {
    static let radiusButton: CGFloat = 15
    static let radiusTableView: CGFloat = 20
    static let heightTableIngredient: CGFloat = 60
    static let typeSearch = "ingredient"
    static let idSearchIngredientTableView = "searchIngredientTableView"
    
    enum DataProteinPickerView: String, CaseIterable {
        case chicken = "chicken"
        case duck = "duck"
        case beef = "beef"
        case pork = "pork"
        case fish = "fish"
        case shrimp = "shrimp"
        case crab = "crab"
        case egg = "egg"
        case milk = "milk"
    }
    
    enum DataVitaminPickerView: String, CaseIterable {
        case carrot = "carrot"
        case corn = "corn"
        case broccoli = "broccoli"
        case asparagus = "asparagus"
        case lettuce = "lettuce"
        case potato = "potato"
        case tomato = "tomato"
        case garlic = "garlic"
        case chili = "chili"
    }
}

final class IngredientController: UIViewController {
    @IBOutlet weak private var proteinPickerView: UIPickerView!
    @IBOutlet weak private var vitaminPickerView: UIPickerView!
    @IBOutlet weak private var addProteinButton: UIButton!
    @IBOutlet weak private var addVitaminButton: UIButton!
    @IBOutlet weak private var searchIngredientTableView: UITableView!
    @IBOutlet weak private var searchRecipeByIngredientButton: UIButton!
    
    private var rowSelectVitamin = 0
    private var rowSelectProtein = 0
    private var ingredients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configIngredientView()
    }
    
    private func configIngredientView() {
        [addProteinButton, addVitaminButton].forEach {
            $0?.layer.cornerRadius = ConstantIngredientView.radiusButton
        }
        [proteinPickerView, vitaminPickerView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
        }
        searchIngredientTableView.layer.cornerRadius = ConstantIngredientView.radiusTableView
        searchRecipeByIngredientButton.cornerCircle()
    }
    
    @IBAction private func addItemToIngredients(_ sender: UIButton) {
        let titleAddIgredient = sender.tag == addProteinButton.tag
            ? ConstantIngredientView.DataProteinPickerView.allCases[rowSelectProtein].rawValue
            : ConstantIngredientView.DataVitaminPickerView.allCases[rowSelectVitamin].rawValue
        if !ingredients.contains(titleAddIgredient) {
            ingredients.append(titleAddIgredient)
        }
        searchIngredientTableView.reloadData()
    }
    
    @IBAction private func goToViewSearch(_ sender: Any) {
        guard let searchVC = self.storyboard?.instantiateViewController(
                withIdentifier: IdStoryBoardViews.search) as? SearchViewController
        else { return }
        searchVC.keyWord = ingredients.joined(separator: ",")
        searchVC.typeSearch = ConstantIngredientView.typeSearch
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension IngredientController: UIPickerViewDelegate,
                                UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerView == proteinPickerView
            ? ConstantIngredientView.DataProteinPickerView.allCases.count
            : ConstantIngredientView.DataVitaminPickerView.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return pickerView == proteinPickerView
            ? ConstantIngredientView.DataProteinPickerView.allCases[row].rawValue
            : ConstantIngredientView.DataVitaminPickerView.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        pickerView == proteinPickerView ? (rowSelectProtein = row) : (rowSelectVitamin = row)
    }
}

extension IngredientController: UITableViewDelegate,
                                 UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstantIngredientView.heightTableIngredient
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchIngredientTableView.dequeueReusableCell(
                withIdentifier: ConstantIngredientView.idSearchIngredientTableView,
                for: indexPath)
                as? SearchIngredientTableCell else { return UITableViewCell() }
        cell.configCell(title: ingredients[indexPath.row])
        cell.delegateHandleIngredient = self
        return cell
    }
}

extension IngredientController: IngredientTableViewDelegate {
    func removeIngredientCell(title: String) {
        ingredients = ingredients.filter { $0 != title }
        searchIngredientTableView.reloadData()
    }
}
