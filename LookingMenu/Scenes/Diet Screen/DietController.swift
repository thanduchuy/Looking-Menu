import UIKit

private enum ConstantDietView {
    static let cornerRadius = 5
    static let heightDropDownTableView = 50
    static let idDropDownCell = "idDropDownDietCell"
}

final class DietController: UIViewController {
    @IBOutlet private weak var btnDropDownDiet: UIButton!
    @IBOutlet private weak var listDietTableView: UITableView!
    @IBOutlet private weak var dropDietButton: UIButton!
    @IBOutlet private weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var iconMorningImageView: UIImageView!
    @IBOutlet private weak var iconAfterNoonImageView: UIImageView!
    @IBOutlet private weak var iconEveningImageView: UIImageView!
    @IBOutlet private weak var bottomBarCenterMorningConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomBarCenterAfternoonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomBarCenterEveningConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomBarView: UIView!
    @IBOutlet private weak var dietDatePicker: UIDatePicker!
    @IBOutlet private weak var recipeSessionImageView: UIImageView!
    @IBOutlet private weak var recipeSesssionTitleLabel: UILabel!
    private var listDiet = [Diet]()
    private var isDropDown = true
    private var selectDatePicker = Date()
    private var selectDiet: Diet?
    private var selectRecipeSession = [RecipeDiet]()
    private var selectSession = 0
    private let sqlite3 = SQLiteService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDietView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listDiet.isEmpty() {
            navigationAddDietView()
        }
    }
    
    private func configDietView() {
        btnDropDownDiet.layer.cornerRadius = CGFloat(ConstantDietView.cornerRadius)
        listDiet = sqlite3.readTableDiet()
        heightTableViewConstraint.constant = CGFloat(listDiet.count * ConstantDietView.heightDropDownTableView)
        if listDiet.isEmpty() {
            navigationAddDietView()
        }
        dropDietButton.setTitle(listDiet[0].name, for: .normal)
        listDietTableView.register(DropDownTableCell.self,
                                   forCellReuseIdentifier: ConstantDietView.idDropDownCell)
        listDietTableView.isHidden = true
        listDietTableView.reloadData()
        [ iconMorningImageView,
          iconAfterNoonImageView,
          iconEveningImageView].forEach {
            let gesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(clickIconSession(_:)))
            $0?.isUserInteractionEnabled = true
            $0?.addGestureRecognizer(gesture)
         }
        dietDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        bottomBarView.cornerCircle()
        selectDiet = listDiet[0]
        selectRecipeSession = getDietSessionByDate(datePicker: Date()) ?? [RecipeDiet]()
        setUpRecipeSession(recipe: selectRecipeSession[selectSession])
    }
    
    private func setUpRecipeSession(recipe : RecipeDiet) {
        recipeSessionImageView.getImageFromURL(imgURL: recipe.image)
        recipeSesssionTitleLabel.text = recipe.title
    }
    
    private func getDietSessionByDate(datePicker: Date) -> [RecipeDiet]? {
        var result = [RecipeDiet]()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        selectDiet?.recipeSessions.forEach({
            if formatter.string(from: $0.date) == formatter.string(from: datePicker) {
                result = $0.recipes
            }
        })
        return result
    }
    
    @objc private func handleDatePicker() {
        selectDatePicker = dietDatePicker.date
        selectRecipeSession = getDietSessionByDate(datePicker: selectDatePicker) ?? [RecipeDiet]()
        if selectRecipeSession.isEmpty {
            setUpRecipeSession(recipe: selectRecipeSession[selectSession])
        } else {
            let alert = UIAlertController.createDefaultAlert(title: "Alert", message: "Quantity saved within 7 days", style: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                [unowned self] _ in
                dietDatePicker.setDate(Date(), animated: true)
                selectRecipeSession = getDietSessionByDate(datePicker: Date()) ?? [RecipeDiet]()
                setUpRecipeSession(recipe: selectRecipeSession[selectSession])
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func onTransferRecipeSession(_ sender: UITapGestureRecognizer) {
            [ (imageView: iconMorningImageView,
               constraint: bottomBarCenterMorningConstraint),
              (imageView: iconAfterNoonImageView,
               constraint: bottomBarCenterAfternoonConstraint),
              (imageView:  iconEveningImageView,
               constraint: bottomBarCenterEveningConstraint)].forEach {
            $0.imageView?.tintColor = $0.imageView == sender.view ? .redDesign : .blackDesign
            $0.constraint?.priority = $0.imageView == sender.view ? .defaultHigh : .defaultLow
            if $0.imageView == sender.view {
                selectSession = $0.imageView?.tag ?? 0
                setUpRecipeSession(recipe: selectRecipeSession[selectSession])
            }
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: {
                            self.view.layoutIfNeeded()
                           }, completion: nil)
           }
    }
    
    private func navigationAddDietView() {
        guard let addDietVC = self.storyboard?.instantiateViewController(
                withIdentifier: IdStoryBoardViews.addDiet) as? AddDietViewController
        else { return }
        self.navigationController?.pushViewController(addDietVC, animated: true)
    }
    
    @IBAction private func onShowDropDownDiet(_ sender: Any) {
        listDietTableView.isHidden = !isDropDown
        isDropDown.toggle()
    }
    
    @IBAction private func onNavigationAddDiet(_ sender: Any) {
        navigationAddDietView()
    }
    
    private func confirmDeleteDiet(diet: Diet,index: Int) {
        let alert = UIAlertController.createDefaultAlert(title: "Delete Diet", message: "Are you sure you want to permanently delete \(diet.name)?", style: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:  { [unowned self] action in
            listDiet.remove(at: index)
            if selectDiet?.id == diet.id {
                selectDiet = listDiet.first
                selectRecipeSession = getDietSessionByDate(datePicker: Date()) ?? [RecipeDiet]()
                setUpRecipeSession(recipe: selectRecipeSession[selectSession])
            }
            listDietTableView.reloadData()
            heightTableViewConstraint.constant = CGFloat(listDiet.count * 50)
            sqlite3.deleteDiet(idDiet: diet.id)
        })
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension DietController: UITableViewDelegate,
                           UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDiet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listDietTableView.dequeueReusableCell(
                withIdentifier: ConstantDietView.idDropDownCell,
                for: indexPath) as? DropDownTableCell
        else { return UITableViewCell() }
        cell.configCell(activity: listDiet[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ConstantDietView.heightDropDownTableView)
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let diet = listDiet[indexPath.row]
        dropDietButton
            .setTitle(diet.name, for: .normal)
        listDietTableView.isHidden = true
        selectDiet = diet
        selectRecipeSession = getDietSessionByDate(datePicker: Date()) ?? [RecipeDiet]()
        setUpRecipeSession(recipe: selectRecipeSession[selectSession])
        isDropDown.toggle()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dietToDelete = listDiet[indexPath.row]
            confirmDelete(diet: dietToDelete, index: indexPath.row)
        }
    }
}
