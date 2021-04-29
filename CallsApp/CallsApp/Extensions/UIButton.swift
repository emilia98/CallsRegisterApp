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
}
