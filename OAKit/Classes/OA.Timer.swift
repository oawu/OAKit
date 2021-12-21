//
//  OA.Timer.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

import UIKit

public extension OA {
    enum Timer {
        private static var all: [String: Foundation.Timer] = [:]

        @discardableResult public static func has(key: String) -> Bool { self.all[key] != nil }

        @discardableResult public static func clean(key: String) -> Bool {
            if let tmp = self.all[key] { tmp.invalidate() }
            self.all.removeValue(forKey: key)
            return self.all[key] == nil
        }

        @discardableResult public static func cleanAll() -> Bool {
            self.all.forEach { key, _ in self.clean(key: key) }
            return true
        }

        @discardableResult public static func delay(key: String, second: TimeInterval, replace: Bool = true, repeats: Bool = false, block: @escaping () -> ()) -> Foundation.Timer {
            if let timer = Self.all[key] {
                guard replace else { return timer }
                timer.invalidate()
                guard Self.clean(key: key) else { return timer }
            }

            let timer: Foundation.Timer = Foundation.Timer.scheduledTimer(withTimeInterval: second, repeats: repeats) { _ in
                if !repeats { Self.clean(key: key) }
                block()
            }
            Self.all[key] = timer
            return timer
        }

        @discardableResult public static func loop(key: String, second: TimeInterval, replace: Bool = true, block: @escaping () -> ()) -> Foundation.Timer {
            if let timer = Self.all[key] {
                guard replace else { return timer }
                timer.invalidate()
                guard Self.clean(key: key) else { return timer }
            }

            block()
            let timer: Foundation.Timer = Foundation.Timer.scheduledTimer(withTimeInterval: second, repeats: true) { _ in block() }
            Self.all[key] = timer
            return timer
        }
    }
}
