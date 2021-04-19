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
}

class Calls: Decodable {
    var calls: [Call]
}

class CallStore {
    private(set) var calls: [Call]
    
    init() {
        calls = [Call]()
        let jsonData = readLocalFile(forName: "calls")
        
        if let data = jsonData {
            calls = parseJSON(jsonData: data)
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
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json") {
                if let jsonData = try String(contentsOfFile:
                                                bundlePath).data(using: .utf8) {
                    return jsonData
                }
            }
        } catch {
            print("Error occurred while reading file \(name).json")
        }
        return nil
    }
    
    private func parseJSON(jsonData: Data) -> [Call] {
        do {
            let decodedData = try JSONDecoder().decode(Calls.self, from: jsonData)
            return decodedData.calls
        } catch {
            print("Error occurred while decoding data: \(error)")
            return [Call]()
        }
    }
}
