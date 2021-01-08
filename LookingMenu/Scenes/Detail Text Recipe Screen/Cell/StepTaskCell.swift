import UIKit

final class StepTaskCell: UITableViewCell {
    @IBOutlet private weak var numberStepTaskLabel: UILabel!
    @IBOutlet private weak var contentStepTaskLabel: UILabel!
    @IBOutlet private weak var backgroundStepTaskCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configStepTaskCell(item : Step) {
        numberStepTaskLabel.text = "\(item.number)"
        contentStepTaskLabel.text = "\(item.step)"
        backgroundStepTaskCell.layer.cornerRadius = 10
        backgroundStepTaskCell.addShadowView(radius: 10)
    }
}
