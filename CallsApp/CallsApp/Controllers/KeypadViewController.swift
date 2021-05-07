import UIKit

class KeypadViewController: UIViewController {
    @IBOutlet var callButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var addNumberButton: UIButton!
    @IBOutlet var clearSymbolButton: UIButton!
    @IBOutlet var numberPadView: NumberPadView!
    
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
    
    @IBAction private func numberPadButtonPressed(_ sender: NumberPadView) {
        let text = sender.lastCharacterPressed
        numberLabel.text = "\(numberLabel.text!)\(text)"
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
