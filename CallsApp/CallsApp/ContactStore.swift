import Foundation

class Contacts: Decodable {
    var contacts: [String]
}

class ContactStore {
    private(set) var contacts: [String]
    private var sections = Dictionary<Character, [String]>()
    /*
    let contactArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        print(documentDirectory)
        return documentDirectory.appendingPathComponent("calls.json")
    }()
 */
    
    init() {
        contacts = [String]()
        /*
        do {
            let data = try Data(contentsOf: contactArchiveURL)
            let decoder = JSONDecoder()
        } catch {
            
        } */
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
