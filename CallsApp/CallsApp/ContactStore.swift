import Foundation

class Contacts: Decodable {
    var contacts: [String]
}

class ContactStore {
    /*
    private var contacts = [
        "Alex", "Alpin Expert", "Ana Maria", "Anastasija",
        "Angel Comp", "Anton Kola", "Anton",
        "Bernar", "Berta"
    ] */
    
    private(set) var contacts: [String]
    private var sections = Dictionary<Character, [String]>()
    
    init() {
        contacts = [String]()
        let jsonData = JSONReader.readLocalFile(forName: "contacts")
        
        if let data = jsonData, let result: Contacts = JSONReader.parseJSON(jsonData: data) {
            contacts = result.contacts
        }
        
        // Init of dictionary
        contacts.forEach {
            sections[$0.first!, default: [String]()].append($0)
        }
    }
    
    var sectionsCount: Int {
        return sections.keys.count
    }
    
    var sectionsNames: [Character] {
        return sections.keys.sorted()
    }
    
    func getContactsCountForSection(_ ch: Character) -> Int {
        let contactsForSection = sections[ch]!
        return contactsForSection.count
    }
    
    func getCertainContact(_ section: Character, _ row: Int) -> String {
        return sections[section]![row]
    }
}
