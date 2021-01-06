import UIKit

final class DetailRecipeController: UIViewController {
    @IBOutlet private weak var equipLabel: UILabel!
    @IBOutlet private weak var ingreLabel: UILabel!
    @IBOutlet private weak var goDetailRecipeTextButton: UIButton!
    @IBOutlet private weak var goDetailRecipeVideoButton: UIButton!
    @IBOutlet private weak var bottomBarViewCenterEquipConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomBarViewCenterIngreConstraint: NSLayoutConstraint!
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var nameRecipeLabel: UILabel!
    @IBOutlet private weak var minuteCookingLabel: UILabel!
    @IBOutlet private weak var ingredientTableView: UITableView!
    @IBOutlet private weak var equipmentTableView: UITableView!
    @IBOutlet private weak var bottomBarView: UIView!
    
    var recipe : Recipe?
    private var ingredients = [Detail]()
    private var equipments = [Detail]()
    private let idTableIngredient = "TableIngredient"
    private let idTableEquipment = "TableEquipment"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDetailRecipeView()
        addEventLabel()
        setDataToElementView()
    }
    
    private func setDataToElementView() {
        guard let recipe = recipe else { return }
        if recipe.image.contains("recipeImages") {
            recipeImage.getImageFromURL(imgURL: recipe.image)
        } else {
            recipeImage.getImageFromURL(imgURL:
                                            String(format: UrlAPIRecipe.urlImageRecipe,
                                                   recipe.image))
        }
        nameRecipeLabel.text = recipe.title
        minuteCookingLabel.text = "\(recipe.readyInMinutes) minute"
    }
    
    private func configDetailRecipeView() {
        guard let recipe = recipe else { return }
        bottomBarView.layer.cornerRadius = bottomBarView.frame.height / 2
        goDetailRecipeTextButton.cornerCircle()
        goDetailRecipeVideoButton.cornerCircle()
        
        APIRecipe.apiRecipe.getEquipmentAndIngredient(idRecipe: recipe.id) { [unowned self]
            (ingredient, equipment) in
            self.ingredients = ingredient.ingredients
            self.equipments = equipment.equipment
            
            self.ingredientTableView.reloadData()
            self.equipmentTableView.reloadData()
        }
        
        [ingredientTableView, equipmentTableView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
        }
        
        ingredientTableView.register(DetailRecipeCell.self,
                              forCellReuseIdentifier: idTableIngredient)
        equipmentTableView.register(DetailRecipeCell.self,
                             forCellReuseIdentifier: idTableEquipment)
        ingredientTableView.alpha = 0.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recipeImage.layer.cornerRadius = recipeImage.frame.width / 2
    }
    
    private func addEventLabel() {
        let tapEquip = UITapGestureRecognizer(target: self,
                                              action: #selector(clickLabel(_:)))
        let tapIngre = UITapGestureRecognizer(target: self,
                                              action: #selector(clickLabel(_:)))
        equipLabel.isUserInteractionEnabled = true
        equipLabel.addGestureRecognizer(tapEquip)
        ingreLabel.isUserInteractionEnabled = true
        ingreLabel.addGestureRecognizer(tapIngre)
    }
    
    @objc private func clickLabel(_ sender: UITapGestureRecognizer) {
        guard let textLabel = sender.view  else { return }
        let checkLabel = textLabel == equipLabel
        equipLabel.textColor = checkLabel ? .redDesign : .blackDesign
        ingreLabel.textColor = checkLabel ? .blackDesign : .redDesign
        bottomBarViewCenterEquipConstraint.priority = checkLabel ? .defaultHigh : .defaultLow
        bottomBarViewCenterIngreConstraint.priority = checkLabel ? .defaultLow : .defaultHigh
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                        self.equipmentTableView.alpha = checkLabel ? 1.0 : 0.0
                        self.ingredientTableView.alpha = checkLabel ? 0.0 : 1.0
                       }, completion: nil)
    }
    
    @IBAction private func goViewTextRecipe(_ sender: Any) {
        guard let textVC = storyboard?
                .instantiateViewController(
                    withIdentifier: IdStoryBoardViews.textRecipe)
                as? TextRecipeController else { return }
        textVC.recipe = recipe
        navigationController?.pushViewController(textVC, animated: true)
    }
    
    @IBAction private func goViewVideoRecipe(_ sender: Any) {
        guard let videoVC = self.storyboard?
                .instantiateViewController(
                    withIdentifier: IdStoryBoardViews.videoRecipe)
                as?  VideoRecipeController else { return }
        videoVC.recipeFromDetail = recipe
        navigationController?.pushViewController(videoVC, animated: true)
    }
    
    @IBAction func goBackView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailRecipeController : UITableViewDelegate,
                                   UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tableView == ingredientTableView ? ingredients.count : equipments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.ingredientTableView {
            guard let cell = ingredientTableView.dequeueReusableCell(
                    withIdentifier: idTableIngredient,
                    for: indexPath) as? DetailRecipeCell
            else { return UITableViewCell() }
            let item = ingredients[indexPath.row]
            cell.configDetailRecipeCell(item: item,
                                        typeDetailCell: true)
            return cell
        } else {
            guard let cell = equipmentTableView.dequeueReusableCell(
                    withIdentifier: idTableEquipment,
                    for: indexPath) as? DetailRecipeCell
            else { return UITableViewCell() }
            let item = equipments[indexPath.row]
            cell.configDetailRecipeCell(item: item,
                                        typeDetailCell: false)
            return cell
        }
    }
}
