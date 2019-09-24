//
//  Timer.swift
//  baishatun-2019-ios
//
//  Created by 吳政賢 on 2019/3/19.
//  Copyright © 2019 ioa.tw. All rights reserved.
//

import Foundation
import UIKit

public class OATimerOnly {
    @discardableResult
    public func `repeat`(key: String, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer? {
        guard let _ = OATimer.all[key] as? Timer else {
            OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: true, block: block)
            return OATimer.all[key] as? Timer
        }
        return nil
    }
    
    @discardableResult
    public func `repeat`(key: String, timer: TimeInterval, block: @escaping () -> Void) -> Timer? {
        return self.repeat(key: key, timer: timer) { _ in block() }
    }
    
    @discardableResult
    public func delay(key: String, timer: TimeInterval, autoCleanKey: Bool, block: @escaping (Timer) -> Void) -> Timer? {
        guard let _ = OATimer.all[key] as? Timer else {
            OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: false) { timer in
                block(timer)
                if autoCleanKey {
                    OATimer.clean(key: key)
                }
            }
            return OATimer.all[key] as? Timer
        }
        return nil
    }
    
    @discardableResult
    public func delay(key: String, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer? {
        return self.delay(key: key, timer: timer, autoCleanKey: true) { block($0) }
    }
    
    @discardableResult
    public func delay(key: String, timer: TimeInterval, block: @escaping () -> Void) -> Timer? {
        return self.delay(key: key, timer: timer, autoCleanKey: true) { _ in block() }
    }
    
    @discardableResult
    public func `continue`(key: String, timer: TimeInterval, autoCleanKey: Bool) -> OATimerContinue? {
        guard let _ = OATimer.all[key] as? OATimerContinue else {
            OATimer.all[key] = OATimerContinue(key: autoCleanKey ? key : nil, timer: timer)
            return OATimer.all[key] as? OATimerContinue
        }
        return nil
    }
    
    @discardableResult
    public func `continue`(key: String, timer: TimeInterval) -> OATimerContinue? {
        return self.continue(key: key, timer: timer, autoCleanKey: true)
    }
    
    @discardableResult
    public func `continue`(key: String) -> OATimerContinue? {
        return self.continue(key: key, timer: 0, autoCleanKey: true)
    }
}

public class OATimerReplace {
    
    @discardableResult
    public func `repeat`(key: String, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer? {
        guard OATimer.clean(key: key) else { return nil }
        OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: true, block: block)
        return OATimer.all[key] as? Timer
    }
    
    @discardableResult
    public func `repeat`(key: String, timer: TimeInterval, block: @escaping () -> Void) -> Timer? {
        return self.repeat(key: key, timer: timer) { _ in block() }
    }
    
    @discardableResult
    public func delay(key: String, timer: TimeInterval, autoCleanKey: Bool, block: @escaping (Timer) -> Void) -> Timer? {
        guard OATimer.clean(key: key) else { return nil }
        OATimer.all[key] = Timer.scheduledTimer(withTimeInterval: timer, repeats: false) { timer in
            block(timer)
            if autoCleanKey {
                OATimer.clean(key: key)
            }
        }
        return OATimer.all[key] as? Timer
    }
    
    @discardableResult
    public func delay(key: String, timer: TimeInterval, block: @escaping (Timer) -> Void) -> Timer? {
        return self.delay(key: key, timer: timer, autoCleanKey: true) { block($0) }
    }
    
    @discardableResult
    public func delay(key: String, timer: TimeInterval, block: @escaping () -> Void) -> Timer? {
        return self.delay(key: key, timer: timer, autoCleanKey: true) { _ in block() }
    }
    
    @discardableResult
    public func `continue`(key: String, timer: TimeInterval, autoCleanKey: Bool) -> OATimerContinue? {
        guard OATimer.clean(key: key) else { return nil }
        OATimer.all[key] = OATimerContinue(key: autoCleanKey ? key : nil, timer: timer)
        return OATimer.all[key] as? OATimerContinue
    }
    
    @discardableResult
    public func `continue`(key: String, timer: TimeInterval) -> OATimerContinue? {
        return self.continue(key: key, timer: 0, autoCleanKey: true)
    }
    
    @discardableResult
    public func `continue`(key: String) -> OATimerContinue? {
        return self.continue(key: key, timer: 0, autoCleanKey: true)
    }
}

public class OATimerContinueBlock {
    private var _timer: TimeInterval! = nil
    private var _block: (() -> Void)! = nil
    
    init(timer: TimeInterval, block: @escaping () -> Void) {
        self._timer = timer
        self._block = block
    }
    
    public func timer() -> TimeInterval {
        return self._timer
    }
    
    public func block() -> () -> Void {
        return self._block
    }
}

public class OATimerContinue {
    private var defaultTimer: TimeInterval = 0
    private var blocks: [OATimerContinueBlock] = []
    private var isClose: Bool = false
    private var timer: Timer? = nil
    private var key: String? = nil
    
    init(key: String?, timer: TimeInterval) {
        self.key = key
        self.defaultTimer = timer
    }
    
    public func push(block: @escaping () -> Void) -> Self {
        self.blocks.append(OATimerContinueBlock(timer: self.defaultTimer, block: block))
        return self
    }
    
    public func push(timer: TimeInterval, block: @escaping () -> Void) -> Self {
        self.blocks.append(OATimerContinueBlock(timer: timer, block: block))
        return self
    }
    
    @discardableResult
    public func run() -> Self {
        guard self.blocks.count > 0 else {
            return self.finish()
        }
        guard !self.isClose else {
            return self.close()
        }
        
        let block = self.blocks.removeFirst()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: block.timer(), repeats: false) { timer in
            guard !self.isClose else { return }
            
            block.block()()
            self.run()
            timer.invalidate()
        }
        return self
    }
    
    @discardableResult
    public func close() -> Self {
        self.timer?.invalidate()
        self.isClose = true
        self.timer = nil
        
        return self
    }
    
    @discardableResult
    public func finish() -> Self {
        if let key = self.key {
            OATimer.clean(key: key)
        }
        return self.close()
    }
}

public class OATimer {
    public static var all:        [String: Any] = [:]
    public static let only:       OATimerOnly          = OATimerOnly()
    public static let replace:    OATimerReplace       = OATimerReplace()
    
    @discardableResult
    public static func has(key: String) -> Bool {
        if let _ = self.all[key] {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    public static func clean(key: String) -> Bool {
        if let tmp？ = OATimer.all[key], let tmp = tmp？ as? OATimerContinue {
            tmp.close()
        }
        
        if let tmp？ = OATimer.all[key], let tmp = tmp？ as? Timer {
            tmp.invalidate()
        }
        
        OATimer.all.removeValue(forKey: key)
        
        if let _ = OATimer.all[key] {
            return false
        } else {
            return true
        }
    }
    
    @discardableResult
    public static func cleanAll() -> Bool {
        self.all.forEach { key, _ in
            self.clean(key: key)
        }
        return true
    }
}
