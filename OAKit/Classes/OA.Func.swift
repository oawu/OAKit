//
//  OA.Func.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

import UIKit

public extension OA {
    enum Func {
        static func timeago(unixtime: UInt) -> String {
            let diff = UInt(NSDate().timeIntervalSince1970) - unixtime

            let contitions: [[String: Any]] = [
                ["base": 10, "format": "現在"],
                ["base": 6, "format": "不到 1 分鐘"],
                ["base": 60, "format": "%d 分鐘前"],
                ["base": 24, "format": "%d 小時前"],
                ["base": 30, "format": "%d 天前"],
                ["base": 12, "format": "%d 個月前"]
            ]
            
            var unit: UInt = 1
            
            for contition in contitions {
                if let base = contition["base"] as? Int, let format = contition["format"] as? String {
                    let tmp = UInt(base) * unit
                    
                    if diff < tmp {
                        return String(format: format, diff / unit)
                    }
                    
                    unit = tmp
                }
            }
            return String(format: "%d 年前", diff / unit)
        }
        
        static func randomString(count: Int = 32, allowed: String = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") -> String {
            let maxCount = allowed.count
            var output   = ""

            for _ in 0 ..< count {
                let r = Int(arc4random_uniform(UInt32(maxCount)))
                let randomIndex = allowed.index(allowed.startIndex, offsetBy: r)

                output += String(allowed[randomIndex])
            }

            return output
        }

        static func arrTo2D(arr: [Any]!, unit: Int) -> [[Any]]! {
            guard let arri = arr, arri.count % unit == 0 else { return nil; }
            
            var anys:[[Any]]! = [];
            
            for (i, el) in arri.enumerated() {
                if !anys.indices.contains(i / unit) {
                    anys.append([el])
                } else {
                    anys[i / unit].append(el)
                }
            }
            return anys;
        }
    }
}
