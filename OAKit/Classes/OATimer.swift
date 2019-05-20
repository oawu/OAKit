//
//  Timer.swift
//  baishatun-2019-ios
//
//  Created by 吳政賢 on 2019/3/19.
//  Copyright © 2019 ioa.tw. All rights reserved.
//

import Foundation
import UIKit

enum OATimerKey {
    case test
}

class OATimerOnly {
    
    @discardableResult
    public func repeats(key: OATimerKey, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer! {
        if let t = OATimer.all[key], let _ = t { return nil }
        OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: true, block: block)
        return OATimer.all[key]!
    }
    
    @discardableResult
    public func repeats(key: OATimerKey, timer: TimeInterval, block: @escaping () -> Void) -> Timer! {
        return self.repeats(key: key, timer: timer) { _ in block() }
    }
    
    @discardableResult
    public func delay(key: OATimerKey, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer! {
        if let t = OATimer.all[key], let _ = t { return nil }
        OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: false, block: block)
        return OATimer.all[key]!
    }
    
    @discardableResult
    public func delay(key: OATimerKey, timer: TimeInterval, block: @escaping () -> Void) -> Timer! {
        return self.delay(key: key, timer: timer) { _ in block() }
    }
}

class OATimerReplace {
    
    @discardableResult
    public func repeats(key: OATimerKey, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer! {
        OATimer.clean(key: key)
        OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: true, block: block)
        return OATimer.all[key]!
    }
    
    @discardableResult
    public func repeats(key: OATimerKey, timer: TimeInterval, block: @escaping () -> Void) -> Timer! {
        return self.repeats(key: key, timer: timer) { _ in block() }
    }
    
    @discardableResult
    public func delay(key: OATimerKey, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer! {
        OATimer.clean(key: key)
        OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: false, block: block)
        return OATimer.all[key]!
    }
    
    @discardableResult
    public func delay(key: OATimerKey, timer: TimeInterval, block: @escaping () -> Void) -> Timer! {
        return self.delay(key: key, timer: timer) { _ in block() }
    }
}

class OATimer {
    
    public static var all:     [OATimerKey: Timer?] = [:]
    public static let only:    OATimerOnly          = OATimerOnly()
    public static let replace: OATimerReplace       = OATimerReplace()
    
    public static func has(key: OATimerKey) -> Bool {
        if let tmp = self.all[key], let _ = tmp {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    public static func clean(key: OATimerKey) -> Bool {
        
        if let tmp = self.all[key] {
            if let timer = tmp {
                timer.invalidate()
            }
            self.all[key] = nil
        }
        
        return true
    }
    
    @discardableResult
    public static func cleanAll() -> Bool {
        for (k, t) in self.all {
            if let timer = t {
                timer.invalidate()
            }
            self.all[k] = nil
        }
        return true
    }
}

