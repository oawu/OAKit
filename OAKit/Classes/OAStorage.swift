//
//  OAOneModel.swift
//  OAKit
//
//  Created by 吳政賢 on 2019/9/11.
//

import Foundation

public protocol OAStorable: Codable {
}

public class OAStorage {
    @discardableResult
    public static func set<T: OAStorable>(models: [T]) -> Bool {
        let strs = models.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ",")
        UserDefaults.standard.set("[\(strs)]", forKey: String(describing: T.self))
        return true
    }

    @discardableResult
    public static func get<T: OAStorable>(model: T.Type) -> [T] {
        guard let str = UserDefaults.standard.string(forKey: String(describing: T.self)), let data = str.data(using: .utf8), let objs = try? JSONDecoder().decode([T].self, from:data) else {
            return []
        }
        
        return objs
    }
    
    @discardableResult
    public static func create<T: OAStorable>(model: T) -> Bool {
        var models = self.all(model: T.self)
        
        if models.isEmpty {
            return self.set(models: [model])
        }
        models.append(model)
        return self.set(models: models)
    }
    
    @discardableResult
    public static func truncate<T: OAStorable>(model: T.Type) -> Bool {
        let empty: [T] = []
        return self.set(models: empty)
    }

    @discardableResult
    public static func all<T: OAStorable>(model: T.Type) -> [T] {
        return self.get(model: model)
    }
    
    @discardableResult
    public static func count<T: OAStorable>(model: T.Type) -> Int {
        return self.get(model: model).count
    }
    
    @discardableResult
    public static func one<T: OAStorable>(model: T.Type) -> T? {
        return self.first(model: model)
    }
    
    @discardableResult
    public static func first<T: OAStorable>(model: T.Type) -> T? {
        return self.all(model: model).first
    }
    
    @discardableResult
    public static func last<T: OAStorable>(model: T.Type) -> T? {
        return self.all(model: model).last
    }
    
    @discardableResult
    public static func pop<T: OAStorable>(model: T.Type) -> T? {
        var models = self.all(model: model)
        let model = models.popLast()
        guard self.set(models: models) else { return nil }
        return model
    }
}
