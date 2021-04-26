//
//  CallStore.swift
//  CallsApp
//
//  Created by Emilia Nedyalkova on 16.04.21.
//

import Foundation

/*
 private enum CodingKeys: String, CodingKey {
       case title
       case country
       case updated
       case podcasts = "results"
     }
 */
class Call: Codable, Equatable {
    var name: String
    var source: String
    var date: Date
    var count: Int
    var isMissed: Bool
    var isOutcome: Bool
    
    static func ==(lhs: Call, rhs: Call) -> Bool {
        return lhs.name == rhs.name && lhs.source == rhs.source
            && lhs.date == rhs.date && lhs.count == rhs.count
            && lhs.isMissed == rhs.isMissed && lhs.isOutcome == rhs.isOutcome
    }
}

class Calls: Codable {
    var calls: [Call]
}

class CallStore {
    private(set) var calls: [Call]
    let callArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("calls.json")
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter
    }()
    
    init() {
        calls = [Call]()
        
        do {
            let data = try Data(contentsOf: callArchiveURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let result: Calls = try decoder.decode(Calls.self, from: data)
            calls = result.calls
        } catch {
            print("Error decoding calls: \(error)")
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
