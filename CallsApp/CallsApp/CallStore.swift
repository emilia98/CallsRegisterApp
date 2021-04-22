//
//  CallStore.swift
//  CallsApp
//
//  Created by Emilia Nedyalkova on 16.04.21.
//

import Foundation

class Call: Codable, Equatable {
    var name: String
    var source: String
    var date: String
    var count: Int
    var isMissed: Bool
    var isOutcome: Bool
    
    static func ==(lhs: Call, rhs: Call) -> Bool {
        return lhs.name == rhs.name && lhs.source == rhs.source
            && lhs.date == rhs.date && lhs.count == rhs.count
            && lhs.isMissed == rhs.isMissed && lhs.isOutcome == rhs.isOutcome
    }
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
    
    func clearAllCalls() {
        calls = [Call]()
    }
    
    func clearMissedCalls() {
        calls.removeAll { $0.isMissed }
    }
    
    func removeCall(_ call: Call) {
        if let index = calls.firstIndex(of: call) {
            calls.remove(at: index)
        }
    }
}
