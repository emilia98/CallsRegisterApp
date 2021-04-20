//
//  CallStore.swift
//  CallsApp
//
//  Created by Emilia Nedyalkova on 16.04.21.
//

import Foundation

class Call: Codable {
    var name: String
    var source: String
    var date: String
    var count: Int
    var isMissed: Bool
    var isOutcome: Bool
}

class Calls: Decodable {
    var calls: [Call]
}

class CallStore {
    private(set) var calls: [Call]
    
    init() {
        calls = [Call]()
        let jsonData = JSONReader.readLocalFile(forName: "calls")
        
        if let data = jsonData, let result: Calls = JSONReader.parseJSON(jsonData: data) {
            calls = result.calls
        }
    }
    
    var callsCount: Int {
        return calls.count
    }
    
    var missedCallsCount: Int {
        return calls.filter { $0.isMissed }.count
    }
    
    func getCall(_ row: Int) -> Call {
        return calls[row]
    }
    
    func getMissedCall(_ row: Int) -> Call {
        return calls.filter { $0.isMissed }[row]
    }
}
