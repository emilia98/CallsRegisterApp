import UIKit

class ViewController: UIViewController {
    @IBOutlet var callButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var addNumberButton: UIButton!
    @IBOutlet var clearSymbolButton: UIButton!
    var numberPadView: NumberPadView? = nil
    var buttons: [String: UIButton] = [:]
    var zeroPressingTimer = Timer()
    var seconds = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callButton.imageView?.contentMode = .scaleAspectFit
        callButton.setCircleButton()
        
        numberPadView = NumberPadView.init()
        numberPadView?.loadView()
        view.addSubview(numberPadView!)
        
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
        
        zeroPressingTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    func zeroButtonReleased(_ sender: UIButton) {
        zeroPressingTimer.invalidate()
        let text = seconds >= 1 ? "+" : "0"
        numberLabel.text = "\(numberLabel.text!)\(text)"
        seconds = 0
    }
    
    @objc
    func updateTimer() {
        seconds = seconds + 0.01
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
}
