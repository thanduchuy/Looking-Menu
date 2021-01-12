import UIKit

final class SearchIngredientTableCell: UITableViewCell {
    @IBOutlet weak private var titleIngredientLabel: UILabel!
    @IBOutlet weak private var ingredientBackgroundView: UIView!
    
    weak var delegateHandleIngredient: IngredientTableViewDelegate?
    var titleIngredient = ""
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ingredientBackgroundView.layer.cornerRadius = 10
    }
    
    func configCell(title: String) {
        titleIngredient = title
        titleIngredientLabel.text = titleIngredient
    }
    
    @IBAction private func removeIngredientCell(_ sender: Any) {
        delegateHandleIngredient?.removeIngredientCell(title: titleIngredient)
    }
}
