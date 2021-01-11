import UIKit

private enum Activities: String {
    static let allCases : [Activities] = [
        sedentary,
        light,
        moderate,
        activez,
        very,
        extra
    ]
    case sedentary =  "Sedentary: little or no exercise"
    case light = "Light: exercise 1-3 times/week"
    case moderate = "Moderate: exercise 4-5 times/week"
    case activez = "Active: daily exercise or intense exercise 3-4 times/week"
    case very = "Very Active: intense exercise 6-7 times/week"
    case extra = "Extra Active: very intense exercise daily, or physical job"
    
    var activityValue: Double {
        switch self {
        case .sedentary: return 1.232
        case .light: return 1.411
        case .moderate: return 1.504
        case .activez: return 1.591
        case .very : return 1.771
        case .extra: return 1.950
        }
    }
}

private enum ConstantAddDietView {
    static let radiusView: CGFloat = 10
    static let calorieMale = 5
    static let calorieFemale = -161
    static let calorieHeight = 6.25
    static let calorieWeight = 10.0
    static let calorieAge = 5
    static let heightDropDownTableCell: CGFloat = 50
    static let iconCheck = "checkmark.circle.fill"
    static let iconUnCheck = "xmark.circle.fill"
    static let idDropDownActivityCell = "DropDownActivityCell"
    static let textFieldHeightPlaceholder = "Insert in cm"
    static let textFieldWeightPlaceholder = "Insert in kg"
    static let textFieldAgePlaceholder = "Insert in year"
}

final class AddDietViewController: UIViewController {
    @IBOutlet private weak var heightOfUserTextField: UITextField!
    @IBOutlet private weak var weightOfUserTextField: UITextField!
    @IBOutlet private weak var ageOfUserTextField: UITextField!
    @IBOutlet private weak var checkGenreMaleButton: UIButton!
    @IBOutlet private weak var checkGenreFemaleButton: UIButton!
    @IBOutlet private weak var dropDownActivityButton: UIButton!
    @IBOutlet private weak var dropDownActivityTableView: UITableView!
    @IBOutlet private weak var createDietButton: UIButton!
    private let sqlite3 = SQLiteService()
    private let activities = Activities.allCases
    private var selectActivity = Activities.sedentary.activityValue
    private var selectedGender = true
    private var isDropDownActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configAddDietView()
    }
    
    private func configAddDietView() {
        [ heightOfUserTextField,
          weightOfUserTextField,
          ageOfUserTextField
        ].forEach {
            $0?.paddingLeftTextField()
            $0?.layer.masksToBounds = true
            $0?.cornerCircle()
        }
        heightOfUserTextField.colorPlaceHoder(text: ConstantAddDietView.textFieldHeightPlaceholder)
        weightOfUserTextField.colorPlaceHoder(text: ConstantAddDietView.textFieldWeightPlaceholder)
        ageOfUserTextField.colorPlaceHoder(text: ConstantAddDietView.textFieldAgePlaceholder)
        dropDownActivityButton.cornerCircle()
        dropDownActivityTableView.register(DropDownTableCell.self,
                                           forCellReuseIdentifier: ConstantAddDietView.idDropDownActivityCell)
        dropDownActivityTableView.layer.cornerRadius = ConstantAddDietView.radiusView
        dropDownActivityTableView.isHidden = true
        createDietButton.cornerCircle()
    }
    
    @IBAction private func onClickBtnDropActivity(_ sender: Any) {
        dropDownActivityTableView.isHidden = !isDropDownActivity
        isDropDownActivity.toggle()
    }
    
    @IBAction private func onClickGenreMale(_ sender: Any) {
        selectedGender = true
        guard let checkImage = UIImage(systemName:
                                        ConstantAddDietView.iconCheck),
              let unCheckImage = UIImage(systemName:
                                            ConstantAddDietView.iconUnCheck)
        else { return }
        checkGenreMaleButton.tintColor = .green
        checkGenreFemaleButton.tintColor = .red
        checkGenreMaleButton.setBackgroundImage(checkImage,
                                                for: .normal)
        checkGenreFemaleButton.setBackgroundImage(unCheckImage,
                                                  for: .normal)
    }
    
    @IBAction private func onClickGenreFemale(_ sender: Any) {
        selectedGender = false
        guard let checkImage = UIImage(systemName:
                                        ConstantAddDietView.iconCheck),
              let unCheckImage = UIImage(systemName:
                                            ConstantAddDietView.iconUnCheck)
        else { return }
        checkGenreMaleButton.tintColor = .red
        checkGenreFemaleButton.tintColor = .green
        checkGenreMaleButton.setBackgroundImage(unCheckImage,
                                                for: .normal)
        checkGenreFemaleButton.setBackgroundImage(checkImage,
                                                  for: .normal)
    }
    
    @IBAction private func goBackDietView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func calculatorCalor() -> Double {
        guard let weight = weightOfUserTextField.text,
              let height = heightOfUserTextField.text,
              let age = ageOfUserTextField.text
        else { return 0.0 }
        let calorByHeight = ConstantAddDietView.calorieHeight * Double( (height as NSString).integerValue)
        let calorByWeight = ConstantAddDietView.calorieWeight * Double((weight as NSString).integerValue)
        let calorByAge = ConstantAddDietView.calorieAge * Int((age as NSString).integerValue)
        let calorByGenre = selectedGender ? ConstantAddDietView.calorieMale : ConstantAddDietView.calorieMale
        let calorPre = calorByHeight + calorByWeight - Double(calorByAge) + Double(calorByGenre)
        return calorPre * selectActivity
    }
    
    private func getDietSessionMenu(list: inout [RecipeDiet]) -> [RecipeDiet] {
        var result = [RecipeDiet]()
        for _ in 0..<3 {
            let random = Int.random(in: 0..<list.count)
            result.append(list[random])
            list.remove(at: random)
        }
        return result
    }
    
    private func createRecipeDietForSession(list: [RecipeDiet]) -> [RecipeSession] {
        var result = [RecipeSession]()
        var listRecipe = list
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        for element in 0..<7 {
            let nextDay = DateComponents(year: now.year, month: now.month, day: now.day ?? 1 + element )
            guard let date = Calendar.current.date(from: nextDay) else { return result }
            let recipes = getDietSessionMenu(list: &listRecipe)
            let recipeSession = RecipeSession(date: date, recipes: recipes)
            result.append(recipeSession)
        }
        return result
    }
    
    private func showAlertSubmitCreateDiet() {
        let alert = UIAlertController.createDefaultAlert(title: "Agree Add Diet ? ", message: "What's name diet?", style: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input diet name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] action in
            if let name = alert.textFields?.first?.text {
                createDataDiet(name: name)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    private func createDataDiet(name: String) {
        let calor = calculatorCalor()
        APIRecipe.apiRecipe.getRecipesByNutrient(calor: calor) { list in
            DispatchQueue.main.async {
                sqlite3.insertQueryDiet(name: name,
                                        calorie: calor,
                                        recipeSessions: createRecipeDietForSession(list: list))
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction private func onClickButtonCreateDiet(_ sender: Any) {
        showAlertSubmitCreateDiet()
    }
}

extension AddDietViewController: UITableViewDelegate,
                                  UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .redDesign
        guard let cell = dropDownActivityTableView.dequeueReusableCell(
                withIdentifier: ConstantAddDietView.idDropDownActivityCell,
                for: indexPath) as? DropDownTableCell
        else { return UITableViewCell() }
        cell.configCell(activity: activities[indexPath.row].rawValue)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstantAddDietView.heightDropDownTableCell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let activity = activities[indexPath.row]
        dropDownActivityButton
            .setTitle(activity.rawValue, for: .normal)
        dropDownActivityTableView.isHidden = true
        selectActivity = activity.activityValue
        isDropDownActivity.toggle()
    }
}
