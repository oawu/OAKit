//
//  OA.Func.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

@discardableResult public func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor { .init(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a)) }
@discardableResult public func setTimeout(second: TimeInterval, key: String = "", block: @escaping () -> (), replace: Bool = true) -> Foundation.Timer { OA.Timer.delay(key: key, second: second, replace: replace, repeats: false, block: block) }
@discardableResult public func setTimeout(second: TimeInterval, block: @escaping () -> (), replace: Bool = true) -> Foundation.Timer { setTimeout(second: second, key: "", block: block, replace: replace) }
@discardableResult public func setInterval(second: TimeInterval, key: String = "", block: @escaping () -> (), replace: Bool = true) -> Foundation.Timer { OA.Timer.delay(key: key, second: second, replace: replace, repeats: true, block: block) }
@discardableResult public func setInterval(second: TimeInterval, block: @escaping () -> (), replace: Bool = true) -> Foundation.Timer { setTimeout(second: second, key: "", block: block, replace: replace) }

public extension OA.Func {
    static func timeago(unixtime: UInt64) -> String {
        let now = UInt64(TimeInterval.now)
        let diff = now > unixtime ? now - unixtime : 0

        let contitions: [[String: Any]] = [
            ["base": 10, "format": "現在"],
            ["base": 6, "format": "不到 1 分鐘"],
            ["base": 60, "format": "%d 分鐘前"],
            ["base": 24, "format": "%d 小時前"],
            ["base": 30, "format": "%d 天前"],
            ["base": 12, "format": "%d 個月前"]
        ]

        var unit: UInt64 = 1

        for contition in contitions {
            if let base = contition["base"] as? Int, let format = contition["format"] as? String {
                let tmp = UInt64(base) * unit

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

