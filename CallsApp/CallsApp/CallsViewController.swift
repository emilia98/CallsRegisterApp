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
    }
    
    override func viewDidLoad() {
        let leftNavigationItem = UIBarButtonItem()
        leftNavigationItem.isEnabled = false
        leftNavigationItem.target = self
        leftNavigationItem.action = #selector(clearCalls(_:))
        
        navigationItem.leftBarButtonItem = leftNavigationItem
        navigationItem.rightBarButtonItem = editButtonItem
        
        navigationController?.navigationBar.topItem?.title = "Recents"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.navigationBar.layoutMargins.left = 30
        
        for (seg, item) in segmentItems.enumerated() {
            segmentedControl.setTitle(item.name, forSegmentAt: seg)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(callTypeChanged(_:)),
                                   for: .valueChanged)
        
        /*
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
 */
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (editing) {
            navigationItem.leftBarButtonItem?.title = "Clear"
            navigationItem.rightBarButtonItem?.title = "Done"
            
        } else {
            navigationItem.leftBarButtonItem?.title = ""
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
        navigationItem.leftBarButtonItem?.isEnabled = editing
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var call: Call? = nil
            switch callType {
            case .all:
                call = callStore.getCall(indexPath.row)
            case .missed:
                call = callStore.getMissedCall(indexPath.row)
            }
            
            if let _ = call {
                callStore.removeCall(call!)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var callsCount: Int
        switch callType {
        case .all:
            callsCount = callStore.callsCount
            if callsCount == 0 {
                setEmptyMessageView("No calls to show")
            }
        case .missed:
            callsCount = callStore.missedCallsCount
            if callsCount == 0 {
                setEmptyMessageView("No missed calls to show")
            }
        }
        
        if callsCount > 0 {
            restoreTableView()
        }
        
        return callsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        var call: Call
        
        if callType == .all {
            call = callStore.getCall(indexPath.row)
        } else {
            call = callStore.getMissedCall(indexPath.row)
        }
        
        cell.outcomeImage.isHidden = !call.isOutcome
        cell.dateLabel.text = CallDateFormat(call.date).formatDate()
        cell.nameLabel.text = call.name
        cell.sourceLabel.text = call.source
        cell.nameLabel.textColor = call.isMissed ? UIColor.red : UIColor.black
        
        if call.count > 1 {
            cell.nameLabel.text! += " (\(call.count))"
        }
        
        return cell
    }
    
    private func setEmptyMessageView(_ message: String) {
        let frame = CGRect(x: 0, y: 0,
                           width: tableView.bounds.size.width,
                           height: tableView.bounds.size.height)
        let messageLabel = UILabel(frame: frame)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    private func restoreTableView() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
    
    @objc
    func callTypeChanged(_ segControl: UISegmentedControl) {
        if segmentItems.indices ~= segControl.selectedSegmentIndex {
            callType = callType == .all ? .missed : .all
            tableView.reloadData()
        }
    }
    
    @objc
    func clearCalls(_ barButton: UIBarButtonItem) {
        switch callType {
        case .all:
            callStore.clearAllCalls()
        case .missed:
            callStore.clearMissedCalls()
        }
        
        tableView.reloadData()
    }
}
