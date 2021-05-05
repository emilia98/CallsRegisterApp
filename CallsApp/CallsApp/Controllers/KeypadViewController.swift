import UIKit

class KeypadViewController: UIViewController {
    @IBOutlet var callButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var addNumberButton: UIButton!
    @IBOutlet var clearSymbolButton: UIButton!
    @IBOutlet var numberPadView: NumberPadView!
    var buttons: [String: UIButton] = [:]
    private var zeroPressingTimer = Timer()
    private var isLongPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callButton.imageView?.contentMode = .scaleAspectFit
        callButton.setCircleButton()
        
        NSLayoutConstraint.activate([
            numberPadView!.topAnchor.constraint(equalTo: addNumberButton.bottomAnchor, constant: 20),
            callButton.topAnchor.constraint(equalTo: numberPadView!.bottomAnchor, constant: 30),
            numberPadView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            numberPadView!.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        buttons = numberPadView!.getButtons()
        addKeypadButtonsTargets()
        
        numberLabel.text = ""
        addNumberButton.isHidden = true
        clearSymbolButton.isHidden = true
        clearSymbolButton.addTarget(self,
                                    action: #selector(clearSymbolButtonPressed(_:)),
                                    for: .touchDown)
        styleClearButton()
        
        callButton.addTarget(self,
                             action: #selector(callButtonPressed(_:)),
                             for: .touchDown)
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
        
        sender.backgroundColor = UIColor(hex: "#8A8A8A")
    }
    
    private func addKeypadButtonsTargets() {
        buttons.forEach { (key, button) in
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
    func zeroButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "#8A8A8A")
        
        zeroPressingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
    }
    
    @objc
    func zeroButtonReleased(_ sender: UIButton) {
        zeroPressingTimer.invalidate()
        let text = isLongPressed ? "+" : "0"
        numberLabel.text = "\(numberLabel.text!)\(text)"
        isLongPressed = false
        addNumberButton.isHidden = false
        clearSymbolButton.isHidden = false
    }
    
    @objc
    func updateTimer() {
        isLongPressed = true
    }

    @objc
    func clearSymbolButtonPressed(_ sender: UIButton) {
        numberLabel.text?.removeLast()
        
        if numberLabel.text!.isEmpty {
            addNumberButton.isHidden = true
            clearSymbolButton.isHidden = true
        }
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
    
    @objc
    func callButtonPressed(_ sender: UIButton) {
        if numberLabel!.text!.isEmpty {
            return
        }
        self.performSegue(withIdentifier: "DialViewController", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DialViewController" {
            let dialViewController = segue.destination as! DialViewController
            dialViewController.name = numberLabel.text!
            dialViewController.source = "mobile"
        } else {
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
