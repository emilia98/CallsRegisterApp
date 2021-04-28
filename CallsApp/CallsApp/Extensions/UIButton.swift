import UIKit

extension UIButton {
    func setCircleButton() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
}
