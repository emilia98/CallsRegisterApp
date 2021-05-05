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
    @IBOutlet var numberPadView: NumberPadView!
    @IBOutlet var callTypeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    var name: String!
    var source: String!
    
    var dialLabelView: UIView!
    var dialLabel: UILabel!
    var buttons: [String: UIButton] = [:]
    var zeroPressingTimer = Timer()
    private var isLongPressed = false
    
    private var callDurationTimer = Timer()
    private var callDurationSeconds = 0
    private var hasCallStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        callTypeLabel.text = "calling \(source!)..."
        
        endCall.setCircleButton()
        muteButton.setCircleButton()
        keypadButton.setCircleButton()
        speakersButton.setCircleButton()
        addCallButton.setCircleButton()
        faceTimeButton.setCircleButton()
        contactsButton.setCircleButton()
        
        numberPadView.backgroundColor = view.backgroundColor
        initDialViewLabel()
        buttons = numberPadView!.getButtons()
        addKeypadButtonsTargets()
        
        callerView.isHidden = false
        dialLabelView.isHidden = true
        hideKeypadButton.isHidden = true
        numberPadView?.isHidden = true
        
        keypadButton.addTarget(self, action: #selector(hideButtonsView(_:)), for: .touchUpInside)
        hideKeypadButton.addTarget(self, action: #selector(hideKeyboardPad(_:)), for: .touchDown)
        
        endCall.addTarget(self,
                          action: #selector(endCallButtonPressed(_:)),
                          for: .touchDown)
        
        callDurationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callDurationTimerUpdate), userInfo: nil, repeats: true)
        
        // zeroPressingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
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
    }

    @objc
    func zeroButtonPressed(_ sender: UIButton) {
        zeroPressingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
    }
    
    @objc
    func zeroButtonReleased(_ sender: UIButton) {
        zeroPressingTimer.invalidate()
        let text = isLongPressed ? "+" : "0"
        dialLabel.text = "\(dialLabel.text!)\(text)"
        isLongPressed = false
    }
    
    @objc
    func callDurationTimerUpdate() {
        if !hasCallStarted {
            if callDurationSeconds == 2 {
                callDurationTimer.invalidate()
                hasCallStarted = true
                callTypeLabel.text = "00:00"
                callDurationSeconds = 0
                callDurationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callDurationTimerUpdate), userInfo: nil, repeats: true)
            }
        } else {
            let minutes = callDurationSeconds / 60
            let seconds = callDurationSeconds % 60
            
            callTypeLabel.text = "\(padLeft(minutes)):\(padLeft(seconds))"
        }
        callDurationSeconds += 1
    }
    
    func padLeft(_ value: Int) -> String{
        return "\(value < 10 ? "0" : "")\(value)"
    }
    
    @objc
    func updateTimer() {
        isLongPressed = true
    }
    
    @objc
    func endCallButtonPressed(_ sender: UIButton) {
        callDurationTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
}
