import Foundation
import UIKit

extension UILabel {
    func setUpLabelCell(fontSize : Int) {
        font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
}
