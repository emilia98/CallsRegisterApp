import UIKit

class NumberPadView: UIControl {
    var buttons: [String: (secondaryText: String?, target: UIButton?)] = [
        "﹡": (secondaryText: nil, target: nil),
        "0": (secondaryText: "+", target: nil),
        "#": (secondaryText: nil, target: nil),
        "7": (secondaryText: "P Q R S", target: nil),
        "8": (secondaryText: "T U V", target: nil),
        "9": (secondaryText: "W X Y Z", target: nil),
        "4": (secondaryText: "G H I", target: nil),
        "5": (secondaryText: "J K L", target: nil),
        "6": (secondaryText: "M N O", target: nil),
        "1": (secondaryText: " ", target: nil),
        "2": (secondaryText: "A B C", target: nil),
        "3": (secondaryText: "D E F", target: nil)
    ]
    var lightGrey: UIColor = UIColor(hex: "#E1E1E1")!
    var lastCharacterPressed = ""
    
    private var zeroPressingTimer = Timer()
    private var isLongPressed = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    convenience init() {
        self.init(frame: .zero)
        loadView()
    }
    
    func loadView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 400).isActive = true
        loadSubviews()
    }
    
    func loadSubviews(_ size: CGFloat = 70) {
        for (title, buttonAttributes) in buttons {
            let button = UIButton()
            button.backgroundColor = lightGrey
            button.setTitleColor(UIColor.black, for: .normal)
            
            let secondaryText = buttonAttributes.secondaryText
            
            if title == "#" || title == "﹡" {
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            } else if title == "0" || title == "1" {
                button.formatAttributedNumericButton(title, secondaryText!, 12, -7)
            } else {
                button.formatAttributedNumericButton(title, secondaryText!)
            }
            
            self.addSubview(button)
            
            button.frame = CGRect(x: 0, y: 0, width: size, height: size)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: size),
                button.widthAnchor.constraint(equalToConstant: size)
            ])
            buttons[title]!.target = button
            button.setCircleButton()
        }
        addKeypadButtonsTargets()
        subviewsContrainsts()
    }
    
    // EVGENI NE HARESVA TOVA
    func subviewsContrainsts() {
        let buttonZero: UIButton! = buttons["0"]?.target
        let buttonHashtag: UIButton! = buttons["#"]?.target
        let buttonAsterisk: UIButton! = buttons["﹡"]?.target
    
        NSLayoutConstraint.activate([
            buttonZero.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonZero.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            buttonZero.leadingAnchor.constraint(equalTo: buttonAsterisk.trailingAnchor, constant: 30),
            buttonHashtag.leadingAnchor.constraint(equalTo: buttonZero.trailingAnchor, constant: 30),
            buttonHashtag.centerYAnchor.constraint(equalTo: buttonZero.centerYAnchor),
            buttonAsterisk.centerYAnchor.constraint(equalTo: buttonZero.centerYAnchor)
        ])
        
        let buttonSeven: UIButton! = buttons["7"]?.target
        let buttonEight: UIButton! = buttons["8"]?.target
        let buttonNine: UIButton! = buttons["9"]?.target
        
        NSLayoutConstraint.activate([
            buttonZero.topAnchor.constraint(equalTo: buttonEight.bottomAnchor, constant: 30),
            buttonEight.centerXAnchor.constraint(equalTo: buttonZero.centerXAnchor),
            buttonEight.leadingAnchor.constraint(equalTo: buttonSeven.trailingAnchor, constant: 30),
            buttonNine.leadingAnchor.constraint(equalTo: buttonEight.trailingAnchor, constant: 30),
            buttonSeven.centerYAnchor.constraint(equalTo: buttonEight.centerYAnchor),
            buttonNine.centerYAnchor.constraint(equalTo: buttonEight.centerYAnchor)
        ])
        
        let buttonFour: UIButton! = buttons["4"]?.target
        let buttonFive: UIButton! = buttons["5"]?.target
        let buttonSix: UIButton! = buttons["6"]?.target
        
        NSLayoutConstraint.activate([
            buttonEight.topAnchor.constraint(equalTo: buttonFive.bottomAnchor, constant: 30),
            buttonFive.centerXAnchor.constraint(equalTo: buttonEight.centerXAnchor),
            buttonFive.leadingAnchor.constraint(equalTo: buttonFour.trailingAnchor, constant: 30),
            buttonSix.leadingAnchor.constraint(equalTo: buttonFive.trailingAnchor, constant: 30),
            buttonFour.centerYAnchor.constraint(equalTo: buttonFive.centerYAnchor),
            buttonSix.centerYAnchor.constraint(equalTo: buttonFive.centerYAnchor)
        ])
        
        let buttonOne: UIButton! = buttons["1"]?.target
        let buttonTwo: UIButton! = buttons["2"]?.target
        let buttonThree: UIButton! = buttons["3"]?.target
        
        NSLayoutConstraint.activate([
            buttonFive.topAnchor.constraint(equalTo: buttonTwo.bottomAnchor, constant: 30),
            buttonTwo.centerXAnchor.constraint(equalTo: buttonFive.centerXAnchor),
            buttonTwo.leadingAnchor.constraint(equalTo: buttonOne.trailingAnchor, constant: 30),
            buttonThree.leadingAnchor.constraint(equalTo: buttonTwo.trailingAnchor, constant: 30),
            buttonOne.centerYAnchor.constraint(equalTo: buttonTwo.centerYAnchor),
            buttonThree.centerYAnchor.constraint(equalTo: buttonTwo.centerYAnchor)
        ])
    }
    
    
    func getButtons() -> [String: UIButton] {
        var result: [String: UIButton] = [:]
        for (title, button) in buttons {
            result[title] = button.target
        }
        
        return result
    }
    
    
    private func addKeypadButtonsTargets() {
        buttons.forEach { (key, buttonTarget) in
            let button = buttonTarget.target!
            button.setBackgroundColor(UIColor(hex: "#E1E1E1")!, for: .normal)
            
            if key == "0" {
                button.addTarget(self, action: #selector(zeroButtonPressed(_:)), for: .touchDown)
                button.addTarget(self, action: #selector(zeroButtonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
                return
            }
            button.addTarget(self, action: #selector(numericButtonPressed(_:)), for: .touchDown)
        }
    }
    
    @objc
    func numericButtonPressed(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        var text = buttonText?.components(separatedBy: "\n")[0]
        if text == "﹡" {
            text = "*"
        }
        
        lastCharacterPressed = text!
        sendActions(for: .valueChanged)
        /*
        numberLabel.text = "\(numberLabel.text!)\(text!)"
        
        if !numberLabel.text!.isEmpty {
            addNumberButton.isHidden = false
            clearSymbolButton.isHidden = false
        } */
        
        sender.backgroundColor = UIColor(hex: "#8A8A8A")
    }
    
    @objc
    func zeroButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "#8A8A8A")
        
        zeroPressingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
    }
    
    @objc
    func zeroButtonReleased(_ sender: UIButton) {
        zeroPressingTimer.invalidate()
        let text = isLongPressed ? "+" : "0"
        lastCharacterPressed = text
       // numberLabel.text = "\(numberLabel.text!)\(text)"
        isLongPressed = false
        sendActions(for: .valueChanged)
       // addNumberButton.isHidden = false
       // clearSymbolButton.isHidden = false
    }
    
    @objc
    func updateTimer() {
        isLongPressed = true
    }
}
