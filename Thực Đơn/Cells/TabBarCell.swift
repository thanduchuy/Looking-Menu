//
//  TabBarCell.swift
//  Thực Đơn
//
//  Created by Huy Than Duc on 25/12/2020.
//

import UIKit

class TabBarCell: UICollectionViewCell {
    lazy var icon : UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor(named: "gray")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var label : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: "gray")
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    lazy var viewBackground : UIView =  {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var horizontalIcon : NSLayoutConstraint?
    var leftIcon : NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewBackground()
        addIconTabBar()
        addLabel()
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                horizontalIcon?.isActive = false
                leftIcon?.isActive = true
                viewBackground.backgroundColor = UIColor(named: "red")?.withAlphaComponent(0.4)
            } else {
                leftIcon?.isActive = false
                horizontalIcon?.isActive = true
                viewBackground.backgroundColor = .white
            }
            if let color = UIColor(named: isSelected ? "red" : "gray") {
                icon.tintColor = color
                label.textColor = color
            }
            
            label.isHidden = !isSelected
            animationIcon()
        }
    }
    func animationIcon() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self!.layoutIfNeeded()
        }
    }
    func addViewBackground() {
        addSubview(viewBackground)
        viewBackground.contentHuggingPriority(for: .horizontal)
        NSLayoutConstraint.activate([
            viewBackground.topAnchor.constraint(equalTo: topAnchor,constant: 20),
            viewBackground.widthAnchor.constraint(equalToConstant: frame.width),
            viewBackground.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -20)
        ])
        viewBackground.layer.cornerRadius = (frame.height-40)/2
    }
    func addLabel() {
        viewBackground.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor,constant: 5),
            label.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: icon.centerYAnchor)
        ])
        label.isHidden = true
    }
    func addIconTabBar() {
        viewBackground.addSubview(icon)
        leftIcon = icon.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor, constant: 5)
        leftIcon?.isActive = false
        horizontalIcon = icon.centerXAnchor.constraint(equalTo: centerXAnchor)
        horizontalIcon?.isActive = true
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 35),
            icon.heightAnchor.constraint(equalToConstant: 35),
            icon.centerYAnchor.constraint(equalTo: viewBackground.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
