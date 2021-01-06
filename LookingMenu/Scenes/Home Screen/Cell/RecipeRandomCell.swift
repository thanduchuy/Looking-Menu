import UIKit

private enum ConstantRecipeRandomCelll : CGFloat {
    case radiusView = 30
    case constantAnchor = 4
    case multiplierWidthBackGroundView = 0.75
    case multiplierHeightImageRecipe = 0.55
    case multiplierTopImageRecipe = 0.15
}

final class RecipeRandomCell: UICollectionViewCell {
    let fontSizeTitle = 24
    let fontSizeMinute = 16
    lazy private var backgroundViewRecipeCell : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = ConstantRecipeRandomCelll.radiusView.rawValue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var labelMinute : UILabel = {
        let lb = UILabel()
        lb.setUpLabelCell(fontSize: fontSizeMinute)
        return lb
    }()
    
    lazy private var labelTitle : UILabel = {
        let lb = UILabel()
        lb.setUpLabelCell(fontSize: fontSizeTitle)
        lb.numberOfLines = 3
        return lb
    }()
    
    lazy private var imageOfRecipe : UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = ConstantRecipeRandomCelll.radiusView.rawValue
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBackgroundView()
        addImageRecipe()
        addLabelMinuteCook()
        addLabelTitleRecipe()
    }
    
    func configItemRecipeRandom(item : Recipe) {
        imageOfRecipe.getImageFromURL(imgURL: item.image)
        labelTitle.text = item.title
        labelMinute.text = "\(item.readyInMinutes) Minute"
    }
    
    private func addBackgroundView() {
        addSubview(backgroundViewRecipeCell)
        NSLayoutConstraint.activate([
            backgroundViewRecipeCell.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundViewRecipeCell.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundViewRecipeCell.widthAnchor.constraint(
                equalToConstant:
                    frame.width - ( ConstantRecipeRandomCelll.constantAnchor.rawValue * 4 )),
            backgroundViewRecipeCell.heightAnchor.constraint(
                equalToConstant:
                    frame.height * ConstantRecipeRandomCelll.multiplierWidthBackGroundView.rawValue)
        ])
        backgroundViewRecipeCell.addShadowView(radius: ConstantRecipeRandomCelll.radiusView.rawValue)
    }
    
    private func addImageRecipe() {
        backgroundViewRecipeCell.addSubview(imageOfRecipe)
        NSLayoutConstraint.activate([
            imageOfRecipe.topAnchor.constraint(
                equalTo: backgroundViewRecipeCell.topAnchor,
                constant:
                    -( frame.width * ConstantRecipeRandomCelll.multiplierTopImageRecipe.rawValue )),
            imageOfRecipe.centerXAnchor.constraint(equalTo: backgroundViewRecipeCell.centerXAnchor),
            imageOfRecipe.widthAnchor.constraint(
                equalToConstant:
                    frame.width - ( ConstantRecipeRandomCelll.constantAnchor.rawValue * 10 )),
            imageOfRecipe.heightAnchor.constraint(
                equalToConstant:
                    frame.height * ConstantRecipeRandomCelll.multiplierHeightImageRecipe.rawValue)
        ])
    }
    
    private func addLabelTitleRecipe() {
        backgroundViewRecipeCell.addSubview(labelTitle)
        labelTitle.textColor = .blackDesign
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(
                equalTo: imageOfRecipe.bottomAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor.rawValue),
            labelTitle.leadingAnchor.constraint(
                equalTo: backgroundViewRecipeCell.leadingAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor.rawValue),
            labelTitle.trailingAnchor.constraint(
                equalTo: backgroundViewRecipeCell.trailingAnchor,
                constant: -ConstantRecipeRandomCelll.constantAnchor.rawValue),
            labelTitle.bottomAnchor.constraint(
                equalTo: labelMinute.topAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor.rawValue)
        ])
    }
    
    private func addLabelMinuteCook() {
        backgroundViewRecipeCell.addSubview(labelMinute)
        labelMinute.textColor = .redDesign
        NSLayoutConstraint.activate([
            labelMinute.bottomAnchor.constraint(
                equalTo: backgroundViewRecipeCell.bottomAnchor,
                constant: -( ConstantRecipeRandomCelll.constantAnchor.rawValue * 2 )),
            labelMinute.leadingAnchor.constraint(
                equalTo: backgroundViewRecipeCell.leadingAnchor,
                constant: ConstantRecipeRandomCelll.constantAnchor.rawValue),
            labelMinute.trailingAnchor.constraint(
                equalTo: backgroundViewRecipeCell.trailingAnchor,
                constant: -ConstantRecipeRandomCelll.constantAnchor.rawValue)
        ])
    }
}
