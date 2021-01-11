import UIKit
extension UITextField {
    func paddingLeftTextField() {
        let paddingView = UIView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: 10,
                          height: frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func customPlaceHoder(text: String, color: UIColor = .white) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
