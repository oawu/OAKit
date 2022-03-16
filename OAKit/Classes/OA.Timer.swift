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
        private static var _all: [String: Foundation.Timer] = [:]

        @discardableResult public static func has(key: String) -> Bool { self._all[key] != nil }

        @discardableResult public static func clean(key: String) -> Bool {
            if let tmp = self._all[key] { tmp.invalidate() }
            self._all.removeValue(forKey: key)
            return self._all[key] == nil
        }

        @discardableResult public static func cleanAll() -> Bool {
            self._all.forEach { key, _ in self.clean(key: key) }
            return true
        }

        @discardableResult public static func delay(key: String, second: TimeInterval, replace: Bool = true, repeats: Bool = false, block: @escaping () -> ()) -> Foundation.Timer {
            if let timer = Self._all[key], replace {
                timer.invalidate()
                guard Self.clean(key: key) else { return timer }
            }

            let timer: Foundation.Timer = Foundation.Timer.scheduledTimer(withTimeInterval: second, repeats: repeats) { _ in
                if !repeats { Self.clean(key: key) }
                block()
            }
            Self._all[key] = timer
            return timer
        }

        @discardableResult public static func loop(key: String, second: TimeInterval, replace: Bool = true, delay: Bool = false, block: @escaping () -> ()) -> Foundation.Timer {
            if let timer = Self._all[key], replace {
                timer.invalidate()
                guard Self.clean(key: key) else { return timer }
            }
            
            delay ? () : block()
            
            let timer: Foundation.Timer = Foundation.Timer.scheduledTimer(withTimeInterval: second, repeats: true) { _ in block() }
            Self._all[key] = timer
            return timer
        }
    }
}
