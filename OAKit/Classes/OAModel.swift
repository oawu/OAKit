//
//  OAOneModel.swift
//  OAKit
//
//  Created by 吳政賢 on 2019/9/11.
//

import Foundation

public protocol OAModel: class {
    static var key: String? { get }
}

public extension OAModel {
    static func get<T>(default: T) -> T {
        guard let key = self.key, let val？ = UserDefaults.standard.object(forKey: key), let val = val？ as? T else { return `default` }
        return val
    }

    static func get<T>(type: T.Type) -> T? {
        guard let key = self.key, let val？ = UserDefaults.standard.object(forKey: key), let val = val？ as? T else { return nil }
        return val
    }

    @discardableResult
    static func set<T: Any>(_ val: T) -> Bool {
        guard let key = self.key else { return false }
        UserDefaults.standard.set(val, forKey: key)
        return true
    }
}

public extension OAModel {
    @discardableResult
    static func create<T: Any>(_ val: T) -> Bool {
        var vals: [T] = self.get(default: [])
        vals.append(val)
        return self.set(vals)
    }

    @discardableResult
    static func deleteAll() -> Bool {
        return self.set([])
    }
    
    static func all<T>(type: T.Type) -> [T] {
        return self.get(default: [T]())
    }

    static func pops<T>(type: T.Type, limit limit？: Int? = nil) -> [T] {
        var vars = self.get(default: [T]())
    
        guard let limit = limit？, vars.count >= limit else {
            self.set([])
            return vars
        }
    
        self.set(Array(vars[limit..<vars.count]))
        return Array(vars[0..<limit])
    }
}
