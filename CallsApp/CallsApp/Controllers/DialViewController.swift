import UIKit



class DialViewController: UIViewController {
    @IBOutlet var endCall: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var keypadButton: UIButton!
    @IBOutlet var speakersButton: UIButton!
    @IBOutlet var addCallButton: UIButton!
    @IBOutlet var faceTimeButton: UIButton!
    @IBOutlet var contactsButton: UIButton!
    @IBOutlet var buttonsView: UIView!
    
    var buttons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        buttons = [
            endCall, muteButton, keypadButton, speakersButton, addCallButton
        ] */
        
        
        endCall.setCircleButton()
        muteButton.setCircleButton()
        keypadButton.setCircleButton()
        speakersButton.setCircleButton()
        addCallButton.setCircleButton()
        faceTimeButton.setCircleButton()
        contactsButton.setCircleButton()
        
        keypadButton.addTarget(self, action: #selector(hideButtonsView(_:)), for: .touchUpInside)
    }
    
    @objc
    func hideButtonsView(_ sender: UIButton) {
        buttonsView.isHidden = true
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
