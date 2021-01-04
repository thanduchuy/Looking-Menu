import Foundation
import UIKit
extension UIColor {
    func getColorDesignByName(nameColor: String) -> UIColor {
        guard let color = UIColor(named: nameColor)
        else { return UIColor() }
        return color
    }
}
