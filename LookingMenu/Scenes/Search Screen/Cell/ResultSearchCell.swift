import UIKit

private enum ConstantResultSearchCell {
    static let radiusView: CGFloat = 20
    static let constantAnchor: CGFloat = 4
    static let paddingImageRecipe: CGFloat = 10
    static let topView: CGFloat = 50
}

final class ResultSearchCell: UICollectionViewCell {
    let fontSizeLBMinute = 16
    let fontSizeLBTitle = 20
    private lazy var containerResultCell : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageRecipe : UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var labelMinuteCooking : UILabel = {
        let lb = UILabel()
        lb.textColor = .redDesign
        lb.setUpLabelCell(fontSize: fontSizeLBMinute)
        return lb
    }()
    
    private lazy var labelTitleRecipe : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 3
        lb.textColor = .blackDesign
        lb.setUpLabelCell(fontSize: fontSizeLBTitle)
        return lb
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addContainerView()
    }
    
    func configSearchCell(item: Recipe) {
        imageRecipe.getImageFromURL(imgURL: String(format: UrlAPIRecipe.urlImageRecipe,
                                                   item.image))
        labelMinuteCooking.text = "\(item.readyInMinutes) Minute"
        labelTitleRecipe.text = item.title
    }
    
    private func addLabelMinute() {
        containerResultCell.addSubview(labelMinuteCooking)
        NSLayoutConstraint.activate([
            labelMinuteCooking.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantResultSearchCell.constantAnchor),
            labelMinuteCooking.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantResultSearchCell.constantAnchor),
            labelMinuteCooking.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -(ConstantResultSearchCell.constantAnchor * 2))
        ])
    }
    
    private func addLabelTitle() {
        containerResultCell.addSubview(labelTitleRecipe)
        NSLayoutConstraint.activate([
            labelTitleRecipe.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantResultSearchCell.constantAnchor),
            labelTitleRecipe.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantResultSearchCell.constantAnchor),
            labelTitleRecipe.topAnchor.constraint(
                equalTo: imageRecipe.bottomAnchor,
                constant: ConstantResultSearchCell.constantAnchor),
            labelTitleRecipe.bottomAnchor.constraint(
                equalTo: labelMinuteCooking.bottomAnchor,
                constant: -ConstantResultSearchCell.constantAnchor)
        ])
    }
    
    private func addImageView() {
        containerResultCell.addSubview(imageRecipe)
        NSLayoutConstraint.activate([
            imageRecipe.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageRecipe.widthAnchor.constraint(equalToConstant:
                                                frame.width - ConstantResultSearchCell.paddingImageRecipe),
            imageRecipe.heightAnchor.constraint(equalToConstant:
                                                    frame.width - ConstantResultSearchCell.paddingImageRecipe),
            imageRecipe.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantResultSearchCell.constantAnchor * 2)
        ])
        imageRecipe.layer.cornerRadius =
            (frame.width - ConstantResultSearchCell.paddingImageRecipe) / 2
    }
    
    private func addContainerView() {
        addSubview(containerResultCell)
        NSLayoutConstraint.activate([
            containerResultCell.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantResultSearchCell.paddingImageRecipe),
            containerResultCell.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantResultSearchCell.paddingImageRecipe),
            containerResultCell.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -ConstantResultSearchCell.paddingImageRecipe),
            containerResultCell.topAnchor.constraint(
                equalTo: topAnchor,
                constant: ConstantResultSearchCell.topView)
        ])
        containerResultCell.addShadowView(
            radius: ConstantResultSearchCell.radiusView)
        addImageView()
        addLabelMinute()
        addLabelTitle()
    }
}
