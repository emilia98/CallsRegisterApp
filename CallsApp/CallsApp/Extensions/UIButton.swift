import UIKit

extension UIButton {
    func setCircleButton() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    func formatAttributedNumericButton(_ mainText: String, _ secondaryText: String, _ fontSecondary: CGFloat = 10, _ spacing: CGFloat = -3) {
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let fontMain = UIFont.systemFont(ofSize: 32)
        let attributesMain = [NSMutableAttributedString.Key.font: fontMain, .paragraphStyle: paragraph]
        let attributedTextMain = NSMutableAttributedString(string: "\(mainText)\n" , attributes: attributesMain)
        
        paragraph.paragraphSpacingBefore = spacing
        let fontSecondary = UIFont.systemFont(ofSize: fontSecondary, weight: .bold)
        let attributesSecondary = [NSMutableAttributedString.Key.font: fontSecondary, .paragraphStyle: paragraph]
        let attributedTextSecondary = NSMutableAttributedString(string: secondaryText, attributes: attributesSecondary)
        
        attributedTextMain.append(attributedTextSecondary)
        self.setAttributedTitle(attributedTextMain, for: [])
    }
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ bgColor: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: bgColor), for: state)
    }
}
