import UIKit

class ConstactsViewController : UITableViewController {
    @IBOutlet var profileButton: UIButton!
    var contactStore = ContactStore()
    var sections = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sections = contactStore.sectionsNames
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        navigationController?.navigationBar.topItem?.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidLayoutSubviews() {
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width
    } 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let charSection = sections[sectionIndex]
        return contactStore.getContactsCountForSection(charSection)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sections[section])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactStore.sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let section = sections[indexPath.section]
        cell.textLabel?.text = contactStore.getCertainContact(section, indexPath.row)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return cell
    }
}
