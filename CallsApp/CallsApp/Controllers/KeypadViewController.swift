//
//  KeypadViewController.swift
//  CallsApp
//
//  Created by Emilia Nedyalkova on 28.04.21.
//

import UIKit

class KeypadViewController: UIViewController {

    @IBOutlet var hashtagButton: UIButton!
    @IBOutlet var keypadView: NumberPadView!
    var buttons: [String: UIButton] = [:]
    var zeroPressingTimer = Timer()
    var seconds = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print("here", keypadView.backgroundColor?.accessibilityName)
        keypadView.loadView()
        buttons = keypadView.getButtons()
        
        buttons.forEach { (key, button) in
            if key == "0" {
                //print("0")
                button.addTarget(self, action: #selector(zeroButtonPressed(_:)), for: .touchDown)
                button.addTarget(self, action: #selector(zeroButtonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
                return
            }
            
           // print("Key", key)
            button.addTarget(self, action: #selector(numericButtonPressed(_:)), for: .touchDown)
        }
        
        
        /*
        print(keypadView.backgroundColor?.accessibilityName)
        print(keypadView.bounds.height, keypadView.bounds.width)
        keypadView.backgroundColor = UIColor.red
        keypadView.removeFromSuperview()
        view.insertSubview(keypadView, aboveSubview: view)
        //keypad
        //view.addSubview(keypadView)
        keypadView.translatesAutoresizingMaskIntoConstraints = false
        keypadView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true
        view.backgroundColor = UIColor.green
        keypadView.alpha = 0.4 */
    }
    
    @objc
    func numericButtonPressed(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        var text: String! = buttonText?.components(separatedBy: "\n")[0]
        print(text!)
        /*
        if text == "﹡" {
            text = "*"
        }
        numberLabel.text = "\(numberLabel.text!)\(text!)"
        
        if !numberLabel.text!.isEmpty {
            addNumberButton.isHidden = false
            clearSymbolButton.isHidden = false
        }
        
        sender.backgroundColor = UIColor(hex: "#8A8A8A")
 */
    }

    @objc
    func zeroButtonPressed(_ sender: UIButton) {
        zeroPressingTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    func zeroButtonReleased(_ sender: UIButton) {
        zeroPressingTimer.invalidate()
        print(seconds)
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
