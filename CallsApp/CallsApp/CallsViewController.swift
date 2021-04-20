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

class CallsViewController : UITableViewController {
    var callStore: CallStore!
    @IBOutlet var headerView: UIView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    private var callType = CallType.all
    
    let segmentItems: [(name: String, callType: CallType)] = [
        ("All", .all),
        ("Missed", .missed)
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        callStore = CallStore()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.topItem?.title = "Recents"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        for (seg, item) in segmentItems.enumerated() {
            segmentedControl.setTitle(item.name, forSegmentAt: seg)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(callTypeChanged(_:)),
                                   for: .valueChanged)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callType == CallType.all ?  callStore.callsCount : callStore.missedCallsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        var call: Call
        
        if callType == .all {
            call = callStore.getCall(indexPath.row)
        } else {
            call = callStore.getMissedCall(indexPath.row)
        }
        
        if !call.isOutcome {
            cell.outcomeImage.isHidden = true
        }
        
        cell.dateLabel.text = call.date.capitalized
        cell.nameLabel.text = call.name
        cell.sourceLabel.text = call.source
        cell.nameLabel.textColor = call.isMissed ? UIColor.red : UIColor.black
        
        if call.count > 1 {
            cell.nameLabel.text! += " (\(call.count))"
        }
        
        return cell
    }
    
    @objc
    func callTypeChanged(_ segControl: UISegmentedControl) {
        if segmentItems.indices ~= segControl.selectedSegmentIndex {
            callType = callType == .all ? .missed : .all
            tableView.reloadData()
        }
    }
}
