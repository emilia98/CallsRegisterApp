//
//  CallsViewController.swift
//  CallsApp
//
//  Created by Emilia Nedyalkova on 16.04.21.
//

import UIKit

enum CallType {
    case all, missed
}

/*
let segmentedControl = UISegmentedControl(items: segmentItems.map { $0.name })
        
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self,
                                   action: #selector(mapTypeChanged(_:)),
                                   for: .valueChanged)
        view.addSubview(segmentedControl)
*/
class CallsViewController : UITableViewController {
    var callStore: CallStore!
    @IBOutlet var headerView: UIView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    let segmentItems: [(name: String, callType: CallType)] = [
        ("All", .all),
        ("Missed", .missed)
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        callStore = CallStore()
    }
    
    /*
    override func loadView() {
        
         // headerView = UIView()
         // tableView.addSubview(headerView)
        // print(segmentedControl)
        segmentedControl = UISegmentedControl(items: segmentItems.map { $0.name })
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(callTypeChanged(_:)),
                                   for: .valueChanged)
         headerView.addSubview(segmentedControl)
        
    } */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callStore.callsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        let call = callStore.getCall(indexPath.row)
        
        cell.dateLabel.text = call.date.capitalized
       // cell.dateLabel.text = call.date
        cell.nameLabel.text = call.name
        cell.sourceLabel.text = call.source
        
        if call.isMissed {
            cell.nameLabel.textColor = UIColor.red
        }
        
        if call.count > 1 {
            cell.nameLabel.text! += " (\(call.count))"
        }
        
        return cell
    }
    
    @objc
    func callTypeChanged(_ segControl: UISegmentedControl) {
        if segmentItems.indices ~= segControl.selectedSegmentIndex {
            // some code here
            // mapView.mapType = segmentItems[segControl.selectedSegmentIndex].mapType
        }
    }
}

