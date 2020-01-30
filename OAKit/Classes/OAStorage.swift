//
//  OAOneModel.swift
//  OAKit
//
//  Created by 吳政賢 on 2019/9/11.
//

import Foundation

open class OAStorage<T> {
    public class var key: String {
        return String(describing: self)
    }
    
    @discardableResult
    public class func set(_ val: T) -> Bool {
        UserDefaults.standard.set(val, forKey: self.key)
        return true
    }
    
    @discardableResult
    public class func destroy() -> Bool {
        UserDefaults.standard.removeObject(forKey: self.key)
        return true
    }
    
    public class func get() -> T? {
        guard let val？ = UserDefaults.standard.object(forKey: self.key), let val = val？ as? T else {
            return nil
        }
        return val
    }
    
    public class func get(default: T) -> T {
        guard let val？ = UserDefaults.standard.object(forKey: self.key), let val = val？ as? T else {
            return `default`
        }
        return val
    }
    
    @discardableResult
    public class func setArray(_ val: [T]) -> Bool {
        UserDefaults.standard.set(val, forKey: self.key)
        return true
    }
    
    public class func getArray(default: [T] = []) -> [T] {
        guard let val？ = UserDefaults.standard.object(forKey: self.key), let val = val？ as? [T] else {
            return `default`
        }
        return val
    }
    
    @discardableResult
    public class func deleteAll() -> Bool {
        return self.setArray([])
    }
    
    @discardableResult
    public class func push(_ val: T) -> Bool {
        var vals: [T] = self.getArray()
        vals.append(val)
        return self.setArray(vals)
    }
    
    public class func all() -> [T] {
        return self.getArray()
    }
    
    public class func pops(limit: Int = -1) -> [T] {
        let vars = self.getArray()
        
        guard limit >= 0, vars.count >= limit else {
            self.setArray([])
            return vars
        }
        
        self.setArray(Array(vars[limit ..< vars.count]))
        return Array(vars[0 ..< limit])
    }
    
    public class func pop() -> T? {
        let vars = self.pops(limit: 1)
        guard vars.count > 0 else {
            return nil
        }
        return vars.first
    }
}
