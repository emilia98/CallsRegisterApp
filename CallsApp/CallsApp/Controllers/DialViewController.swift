import UIKit



class DialViewController: UIViewController {
    @IBOutlet var endCall: UIButton!
    @IBOutlet var callerView: UIView!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var keypadButton: UIButton!
    @IBOutlet var speakersButton: UIButton!
    @IBOutlet var addCallButton: UIButton!
    @IBOutlet var faceTimeButton: UIButton!
    @IBOutlet var contactsButton: UIButton!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var hideKeypadButton: UIButton!
    var numberPadView: NumberPadView? = nil
    var dialLabelView: UIView!
    var dialLabel: UILabel!
    var buttons: [String: UIButton] = [:]
    var zeroPressingTimer = Timer()
    var seconds = 0.0
    
   // var buttons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endCall.setCircleButton()
        muteButton.setCircleButton()
        keypadButton.setCircleButton()
        speakersButton.setCircleButton()
        addCallButton.setCircleButton()
        faceTimeButton.setCircleButton()
        contactsButton.setCircleButton()
        
        initDialViewLabel()
        
        numberPadView = NumberPadView.init()
        numberPadView?.loadView()
        view.addSubview(numberPadView!)
        buttons = numberPadView!.getButtons()
        addKeypadButtonsTargets()
        
        callerView.isHidden = false
        dialLabelView.isHidden = true
        hideKeypadButton.isHidden = true
        numberPadView?.isHidden = true
        
        keypadButton.addTarget(self, action: #selector(hideButtonsView(_:)), for: .touchUpInside)
        hideKeypadButton.addTarget(self, action: #selector(hideKeyboardPad(_:)), for: .touchDown)
    }
    
    @objc
    func hideButtonsView(_ sender: UIButton) {
        buttonsView.isHidden = true
        hideKeypadButton.isHidden = false
        numberPadView?.isHidden = false
        
        NSLayoutConstraint.activate([
            endCall.topAnchor.constraint(equalTo: numberPadView!.bottomAnchor, constant: 50),
            numberPadView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            numberPadView!.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    func hideKeyboardPad(_ sender: UIButton) {
        buttonsView.isHidden = false
        hideKeypadButton.isHidden = true
        callerView.isHidden = false
        dialLabelView.isHidden = true
        
        dialLabel.text = ""
        
        if let numberPad = numberPadView {
            numberPad.isHidden = true
        }
    }
    
    private func addKeypadButtonsTargets() {
        buttons.forEach { (key, button) in
            if key == "0" {
                button.addTarget(self, action: #selector(zeroButtonPressed(_:)), for: .touchDown)
                button.addTarget(self, action: #selector(zeroButtonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
                return
            }
            button.addTarget(self, action: #selector(numericButtonPressed(_:)), for: .touchDown)
        }
    }
    
    private func initDialViewLabel() {
        dialLabelView = UIView()
        dialLabelView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(dialLabelView, aboveSubview: callerView)
        
        NSLayoutConstraint.activate([
            dialLabelView.heightAnchor.constraint(equalTo: callerView.heightAnchor, constant: -20),
            dialLabelView.widthAnchor.constraint(equalTo: callerView.widthAnchor),
            dialLabelView.centerXAnchor.constraint(equalTo: callerView.centerXAnchor),
            dialLabelView.centerYAnchor.constraint(equalTo: callerView.centerYAnchor)
        ])
        
        initDialLabel()
    }
    
    private func initDialLabel() {
        dialLabel = UILabel()
        dialLabel.translatesAutoresizingMaskIntoConstraints = false
        dialLabel.text = ""
        dialLabel.font = UIFont.systemFont(ofSize: 38)
        dialLabel.textColor = UIColor.white
        dialLabelView.addSubview(dialLabel)
        NSLayoutConstraint.activate([
            dialLabel.centerYAnchor.constraint(equalTo: dialLabelView.centerYAnchor),
            dialLabel.centerXAnchor.constraint(equalTo: dialLabelView.centerXAnchor)
        ])
    }
    
    @objc
    func numericButtonPressed(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        var text: String! = buttonText?.components(separatedBy: "\n")[0]
        
        if text == "﹡" {
            text = "*"
        }
        dialLabel.text = "\(dialLabel.text!)\(text!)"
        
        if !dialLabel.text!.isEmpty {
            dialLabelView.isHidden = false
            callerView.isHidden = true
        }
        
        // sender.backgroundColor = UIColor(hex: "#8A8A8A")
 
    }

    @objc
    func zeroButtonPressed(_ sender: UIButton) {
        zeroPressingTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    func zeroButtonReleased(_ sender: UIButton) {
        zeroPressingTimer.invalidate()
        let text = seconds >= 1 ? "+" : "0"
        dialLabel.text = "\(dialLabel.text!)\(text)"
        seconds = 0
    }
    
    @objc
    func updateTimer() {
        seconds = seconds + 0.01
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
