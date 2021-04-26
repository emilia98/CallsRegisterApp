import Foundation
import UIKit

class Contacts: Codable {
    var contacts: [String]
}

class ContactStore {
    private(set) var contacts: [String]
    private var sections = Dictionary<Character, [String]>()
    
    let contactArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("contacts.json")
    }()

    init() {
        contacts = [String]()
    
        do {
            let data = try Data(contentsOf: contactArchiveURL)
            let decoder = JSONDecoder()
            let result: Contacts = try decoder.decode(Contacts.self, from: data)
            contacts = result.contacts
        } catch {
            print("Error decoding contacts: \(contacts)")
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
