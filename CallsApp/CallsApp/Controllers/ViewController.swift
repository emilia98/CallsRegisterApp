//
//  ViewController.swift
//  CallApp
//
//  Created by Emilia Nedyalkova on 23.04.21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var callButton: UIButton!
    @IBOutlet var buttonZero: UIButton!
    @IBOutlet var hashtagButton: UIButton!
    @IBOutlet var asteriskButton: UIButton!
    @IBOutlet var buttonNine: UIButton!
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    @IBOutlet var buttonFour: UIButton!
    @IBOutlet var buttonFive: UIButton!
    @IBOutlet var buttonSix: UIButton!
    @IBOutlet var buttonSeven: UIButton!
    @IBOutlet var buttonEight: UIButton!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var addNumberButton: UIButton!
    @IBOutlet var clearSymbolButton: UIButton!
    
    private var buttons: [ String: (attributed: Bool, mainText: String?, secondaryText: String?, target: UIButton)] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.buttons = [
            "call": (attributed: false, mainText: nil, secondaryText: nil, target: callButton),
            "0": (attributed: true, mainText: "0", secondaryText: "+", target: buttonZero),
            "#": (attributed: false, mainText: nil, secondaryText: nil, target: hashtagButton),
            "*": (attributed: false, mainText: nil, secondaryText: nil, target: asteriskButton),
            "1": (attributed: true, mainText: "1", secondaryText: " ", target: buttonOne),
            "2": (attributed: true, mainText: "2", secondaryText: "A B C", target: buttonTwo),
            "3": (attributed: true, mainText: "3", secondaryText: "D E F", target: buttonThree),
            "4": (attributed: true, mainText: "4", secondaryText: "G H I", target: buttonFour),
            "5": (attributed: true, mainText: "5", secondaryText: "J K L", target: buttonFive),
            "6": (attributed: true, mainText: "6", secondaryText: "M N O", target: buttonSix),
            "7": (attributed: true, mainText: "7", secondaryText: "P Q R S", target: buttonSeven),
            "8": (attributed: true, mainText: "8", secondaryText: "T U V", target: buttonEight),
            "9": (attributed: true, mainText: "9", secondaryText: "W X Y Z", target: buttonNine)
        ]
        
        callButton.imageView?.contentMode = .scaleAspectFit
        
        for key in buttons.keys {
            let button = buttons[key]!.target
            shapeButton(button)
            
            if key == "0" || key == "1" {
                formatAttributedString(key, 12, -7)
            } else {
                formatAttributedString(key)
            }
            
            if key != "call" {
                button.addTarget(self, action: #selector(numericButtonPressed(_:)), for: .touchDown)
            }
        }
        
        numberLabel.text = ""
        addNumberButton.isHidden = true
        clearSymbolButton.isHidden = true
        clearSymbolButton.addTarget(self, action: #selector(clearSymbolButtonPressed(_:)), for: .touchDown)
        styleClearButton()
    }
    
    @objc
    func numericButtonPressed(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        var text = buttonText?.components(separatedBy: "\n")[0]
        if text == "﹡" {
            text = "*"
        }
        numberLabel.text = "\(numberLabel.text!)\(text!)"
        
        if !numberLabel.text!.isEmpty {
            addNumberButton.isHidden = false
            clearSymbolButton.isHidden = false
        }
    }
    
    @objc
    func clearSymbolButtonPressed(_ sender: UIButton) {
        numberLabel.text?.removeLast()
        
        if numberLabel.text!.isEmpty {
            addNumberButton.isHidden = true
            clearSymbolButton.isHidden = true
        }
    }
    
    private func shapeButton(_ button: UIButton) {
        button.clipsToBounds = true
        button.layer.cornerRadius = callButton.bounds.size.width * 0.5
    }
    
    private func formatAttributedString(_ key: String, _ fontSecondary: CGFloat = 10, _ spacing: CGFloat = -3) {
        if !buttons[key]!.attributed {
            return
        }
        
        let buttonSettings = buttons[key]!
        let button = buttonSettings.target
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let fontMain = UIFont.systemFont(ofSize: 32)
        let attributesMain = [NSMutableAttributedString.Key.font: fontMain, .paragraphStyle: paragraph]
        let attributedTextMain = NSMutableAttributedString(string: "\(buttonSettings.mainText!)\n" , attributes: attributesMain)
        
        paragraph.paragraphSpacingBefore = spacing
        let fontSecondary = UIFont.systemFont(ofSize: fontSecondary, weight: .bold)
        let attributesSecondary = [NSMutableAttributedString.Key.font: fontSecondary, .paragraphStyle: paragraph]
        let attributedTextSecondary = NSMutableAttributedString(string: buttonSettings.secondaryText!, attributes: attributesSecondary)
        
        attributedTextMain.append(attributedTextSecondary)
        button.setAttributedTitle(attributedTextMain, for: [])
    }
    
    private func styleClearButton() {
        let image = UIImage(systemName: "delete.left.fill")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center

        imageView.preferredSymbolConfiguration = .init(pointSize: 25)
        imageView.tintColor = UIColor(hex: "#E1E1E1")
        
        let buttonImage = UIImage(systemName: "delete.left")
        clearSymbolButton.setImage(buttonImage, for: .normal)
        clearSymbolButton.tintColor = .black
        
        clearSymbolButton.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: clearSymbolButton.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: clearSymbolButton.heightAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: clearSymbolButton.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: clearSymbolButton.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: clearSymbolButton.topAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: clearSymbolButton.centerYAnchor).isActive = true
    }
}
