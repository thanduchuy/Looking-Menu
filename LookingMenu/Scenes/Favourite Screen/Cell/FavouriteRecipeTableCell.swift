import UIKit

private enum ConstantFavouriteRecipeCell {
    static let fontSizeTitle = 16
    static let fontSizeMinuteCooking = 18
    static let constantAnchor: CGFloat = 8
    static let radiusView: CGFloat = 10
    static let sizeImageRecipeFavourite: CGFloat = 70
}

final class FavouriteRecipeTableCell: UITableViewCell {
    lazy private var favouriteRecipeBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var favouriteRecipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var favouriteRecipeTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.setUpLabelCell(fontSize: ConstantFavouriteRecipeCell.fontSizeTitle)
        return label
    }()
    
    lazy private var favouriteRecipeMinuteCookingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .redDesign
        label.setUpLabelCell(fontSize: ConstantFavouriteRecipeCell.fontSizeMinuteCooking)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemGray6
        addBackGroundRecipeFavourite()
    }
    
    func configFavouriteRecipeCell(item: Recipe) {
        favouriteRecipeImageView.getImageFromURL(imgURL: item.image)
        favouriteRecipeTitleLabel.text = item.title
        favouriteRecipeMinuteCookingLabel.text = "\(item.readyInMinutes) Minute"
    }
    
    private func addBackGroundRecipeFavourite() {
        addSubview(favouriteRecipeBackground)
        
        NSLayoutConstraint.activate([
            favouriteRecipeBackground.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeBackground.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeBackground.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeBackground.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor)
        ])
        
        favouriteRecipeBackground.layer.cornerRadius = ConstantFavouriteRecipeCell.radiusView
        favouriteRecipeBackground.addShadowView(radius: ConstantFavouriteRecipeCell.radiusView)
        addImageRecipeFavourite()
        addTitleLabelRecipeFavourite()
        addMinuteCookingLabelRecipeFavourite()
    }
    
    private func addImageRecipeFavourite() {
        favouriteRecipeBackground.addSubview(favouriteRecipeImageView)
        
        NSLayoutConstraint.activate([
            favouriteRecipeImageView.leadingAnchor.constraint(
                equalTo: favouriteRecipeBackground.leadingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            favouriteRecipeImageView.heightAnchor.constraint(
                equalToConstant: ConstantFavouriteRecipeCell.sizeImageRecipeFavourite),
            favouriteRecipeImageView.widthAnchor.constraint(
                equalToConstant: ConstantFavouriteRecipeCell.sizeImageRecipeFavourite)
        ])

        favouriteRecipeImageView.cornerCircle()
    }
    
    private func addTitleLabelRecipeFavourite() {
        favouriteRecipeBackground.addSubview(favouriteRecipeTitleLabel)
        
        NSLayoutConstraint.activate([
            favouriteRecipeTitleLabel.leadingAnchor.constraint(
                equalTo: favouriteRecipeImageView.trailingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeTitleLabel.trailingAnchor.constraint(
                equalTo: favouriteRecipeBackground.trailingAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeTitleLabel.topAnchor.constraint(
                equalTo: favouriteRecipeImageView.topAnchor)
        ])
    }
    
    private func addMinuteCookingLabelRecipeFavourite() {
        favouriteRecipeBackground.addSubview(favouriteRecipeMinuteCookingLabel)
        
        NSLayoutConstraint.activate([
            favouriteRecipeMinuteCookingLabel.leadingAnchor.constraint(
                equalTo: favouriteRecipeImageView.trailingAnchor,
                constant: ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeMinuteCookingLabel.trailingAnchor.constraint(
                equalTo: favouriteRecipeBackground.trailingAnchor,
                constant: -ConstantFavouriteRecipeCell.constantAnchor),
            favouriteRecipeMinuteCookingLabel.bottomAnchor.constraint(
                equalTo: favouriteRecipeImageView.bottomAnchor)
        ])
    }
}
