import Foundation
import UIKit
extension UIImageView {
    func getImageFromURL(imgURL:String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: imgURL),
               let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

