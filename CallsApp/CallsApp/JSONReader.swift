//
//  JSONReader.swift
//  CallsApp
//
//  Created by Emilia Nedyalkova on 20.04.21.
//

import Foundation

class JSONReader {
    static func readLocalFile(forName name: String) -> Data? {
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
    
    static func parseJSON<T: Decodable>(jsonData: Data) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            print("Error ocurred while decoding data: \(error)")
            return nil
        }
    }
}
