import UIKit
class TabBarCell: UICollectionViewCell {
    private var constraintCenterHorizontalIcon : NSLayoutConstraint?
    private var constraintLeadingIcon : NSLayoutConstraint?
    private lazy var iconTabbar : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(named: "gray")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelTabbar : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "gray")
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewBackgroundTabbar : UIView =  {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        addViewBackgroundToTabbar()
        addLabelToViewBackgroundTabbar()
        addIconToViewBackgroundTabbar()
    }
    
    func configCell(item : TabBar) {
        if let image = UIImage(named: item.iconTabbar) {
            iconTabbar.image = image.withRenderingMode(.alwaysTemplate)
            labelTabbar.text = item.nameTabbar
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if let red = UIColor(named: "red"),
               let gray = UIColor(named: "gray") {
                viewBackgroundTabbar.backgroundColor = isSelected ?
                    red.withAlphaComponent(0.4) : .white
                if let horizontalIcon = constraintCenterHorizontalIcon,
                   let leftIcon = constraintLeadingIcon {
                    horizontalIcon.isActive = !isSelected
                    leftIcon.isActive = isSelected
                }
                iconTabbar.tintColor = isSelected ? red : gray
                labelTabbar.textColor = isSelected ? red : gray
                labelTabbar.isHidden = !isSelected
                animationIconItemTabBarSelected()
            }
        }
    }
    
    private func animationIconItemTabBarSelected() {
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    private func addViewBackgroundToTabbar() {
        addSubview(viewBackgroundTabbar)
        viewBackgroundTabbar.contentHuggingPriority(for: .horizontal)
        NSLayoutConstraint.activate([
            viewBackgroundTabbar.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20),
            viewBackgroundTabbar.widthAnchor.constraint(
                equalToConstant: frame.width),
            viewBackgroundTabbar.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -20)
        ])
        viewBackgroundTabbar.layer.cornerRadius = (frame.height - 40) / 2
    }
    
    private func addLabelToViewBackgroundTabbar() {
        viewBackgroundTabbar.addSubview(labelTabbar)
        NSLayoutConstraint.activate([
            labelTabbar.leadingAnchor.constraint(
                equalTo: iconTabbar.trailingAnchor,
                constant: 5),
            labelTabbar.trailingAnchor.constraint(
                equalTo: viewBackgroundTabbar.trailingAnchor),
            labelTabbar.centerYAnchor.constraint(
                equalTo: iconTabbar.centerYAnchor)
        ])
        labelTabbar.isHidden = true
    }
    
    private func addIconToViewBackgroundTabbar() {
        viewBackgroundTabbar.addSubview(iconTabbar)
        constraintLeadingIcon = iconTabbar.leadingAnchor.constraint(
            equalTo: viewBackgroundTabbar.leadingAnchor,
            constant: 5)
        constraintCenterHorizontalIcon = iconTabbar.centerXAnchor.constraint(
            equalTo: centerXAnchor)
        if let horizontalIcon = constraintCenterHorizontalIcon,
           let leftIcon = constraintLeadingIcon {
            horizontalIcon.isActive = true
            leftIcon.isActive = false
        }
        NSLayoutConstraint.activate([
            iconTabbar.widthAnchor.constraint(
                equalToConstant: 35),
            iconTabbar.heightAnchor.constraint(
                equalToConstant: 35),
            iconTabbar.centerYAnchor.constraint(
                equalTo: viewBackgroundTabbar.centerYAnchor)
        ])
    }
}

