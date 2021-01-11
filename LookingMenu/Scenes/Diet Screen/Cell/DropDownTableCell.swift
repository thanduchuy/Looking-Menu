import UIKit

private enum ConstantDropDownCell: CGFloat {
    case fontsizeTitle = 20
    case constantAnchor = 8
}

final class DropDownTableCell: UITableViewCell {
    private lazy var titleActivity: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.setUpLabelCell(fontSize: Int(ConstantDropDownCell.fontsizeTitle.rawValue))
        return lb
    }()
    
    override func layoutSubviews() {
        backgroundColor = .redDesign
        addLabelTitleActivity()
    }
    
    func configCell(activity: String) {
        titleActivity.text = activity
    }
    
    private func addLabelTitleActivity() {
        addSubview(titleActivity)
        
        NSLayoutConstraint.activate([
            titleActivity.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: ConstantDropDownCell.constantAnchor.rawValue),
            titleActivity.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -ConstantDropDownCell.constantAnchor.rawValue),
            titleActivity.topAnchor.constraint(equalTo: topAnchor),
            titleActivity.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
