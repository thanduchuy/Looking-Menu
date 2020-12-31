import Foundation
import UIKit
extension UIView {
    func cornerCircle() {
        layer.cornerRadius = frame.height/2
    }
    func addShadowView(radius: CGFloat) {
        if let black = UIColor(named: "black") {
            layer.shadowColor = black.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowOffset = .zero
            layer.shadowRadius = radius
        }
    }
}
