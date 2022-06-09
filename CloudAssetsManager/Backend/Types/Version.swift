//
//  Version.swift
//  CloudAssetsManager
//
//  Created by azusa on 2022/6/8.
//

import Foundation

enum Version {
//    1000_1000_1000 <-> "1000.1000.1000"
    
    static func intToString(_ int: Int) -> String {
        guard int > 1_0000_0000 else {
            return int.description
        }
        let v1 = Int(int / 1_0000_0000)
        let v2 = Int((int - v1 * 1_0000_0000) / 1_0000)
        let v3 = int - v1 * 1_0000_0000 - v2 * 1_0000
        return "\(v1).\(v2).\(v3)"
    }
    
    static func stringToInt(_ string: String) -> Int? {
        let components = string.components(separatedBy: ".")
        guard components.count == 3 else {
            return nil
        }
        guard let v1 = Int(components[0]), let v2 = Int(components[1]), let v3 = Int(components[2]) else {
            return nil
        }
        return v1 * 1_0000_0000 + v2 * 1_0000 + v3
    }
}
