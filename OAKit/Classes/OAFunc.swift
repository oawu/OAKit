//
//  OAFunc.swift
//
//  Created by 吳政賢 on 2019/3/19.
//  Copyright © 2019 ioa.tw. All rights reserved.
//

import Foundation
import UIKit

public func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a));
}

public func timeago(time: UInt) -> String {
    let diff = UInt(NSDate().timeIntervalSince1970) - time
    
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

public func arr22D(arr: [Any]!, unit: Int) -> [[Any]]! {
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
