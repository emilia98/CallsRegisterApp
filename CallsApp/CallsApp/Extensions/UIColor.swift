import UIKit

enum ColorComponent {
    case red, green, blue, alpha
}

class HexSymbols {
    private static var allowedSymbols = Set<Character>([
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "A", "B", "C", "D", "E", "F", "a", "b", "c", "d", "e", "f"
    ])
    
    static func isAllowed(symbol: Character) -> Bool {
        return allowedSymbols.contains(symbol)
    }
}

extension UIColor {
    convenience init?(hex: String) {
        if hex.first != "#" {
            return nil
        }
        
        self.init()
        
        var components: (red: String, green: String, blue: String, alpha: String) = ("", "", "", "")
        var index = hex.index(after: hex.startIndex)
        var currentColor = ColorComponent.red
        var valuesPassed = 0
        
        while index < hex.endIndex {
            let value = hex[index]
            
            if !HexSymbols.isAllowed(symbol: value) {
                return nil
            }
            
            switch currentColor {
            case .red:
                components.red.append(value)
            case .green:
                components.green.append(value)
            case .blue:
                components.blue.append(value)
            case .alpha:
                components.alpha.append(value)
            }
            
            index = hex.index(after: index)
            valuesPassed += 1
            
            if valuesPassed == 2 {
                valuesPassed = 0
                switchColor(&currentColor)
            }
        }
        
        let redComponent = getComponentValue(component: components.red)
        let greenComponent = getComponentValue(component: components.green)
        let blueComponent = getComponentValue(component: components.blue)
        let alphaComponent = getComponentValue(component: components.alpha, defaultValue: 255)
       self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: alphaComponent)
    }
    
    /*
    convenience init(rgb: Int) {
        let col = 0xffe700
    } */
    
    private func switchColor(_ currentColor: inout ColorComponent) {
        switch currentColor {
        case .red:
        currentColor = .green
        case .green:
        currentColor = .blue
        case .blue:
        currentColor = .alpha
        default:
            break
        }
    }

    private func getComponentValue(component: String, defaultValue: Int = 0) -> CGFloat {
        return CGFloat(component.isEmpty ?
                        defaultValue : Int("\(component)", radix: 16)!) / 255
    }
}
