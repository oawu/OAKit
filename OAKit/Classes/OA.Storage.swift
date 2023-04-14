//
//  OA.Storage.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

public extension OA.Storage {

    @discardableResult static func set<T: Codable>(models: [T]) -> Bool {
        UserDefaults.standard.set("[\(models.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ","))]", forKey: String(describing: T.self))
        return true
    }

    @discardableResult static func get<T: Codable>(model: T.Type) -> [T] {
        guard let str = UserDefaults.standard.string(forKey: String(describing: T.self)), let data = str.data(using: .utf8), let objs = try? JSONDecoder().decode([T].self, from:data) else { return [] }
        return objs
    }

    @discardableResult static func truncate<T: Codable>(model: T.Type) -> Bool {
        let models: [T] = []
        return self.set(models: models)
    }

    static func all<T: Codable>(model: T.Type) -> [T] { self.get(model: model) }

    static func count<T: Codable>(model: T.Type) -> Int { self.get(model: model).count }

    static func first<T: Codable>(model: T.Type) -> T? { self.all(model: model).first }

    static func last<T: Codable>(model: T.Type) -> T? { self.all(model: model).last }

    static func one<T: Codable>(model: T.Type) -> T? { self.first(model: model) }

    @discardableResult static func push<T: Codable>(model: T) -> Bool {
        var models = self.all(model: T.self)
        models.append(model)
        return self.set(models: models)
    }
    @discardableResult static func unshift<T: Codable>(model: T) -> Bool {
        var models = self.all(model: T.self)
        models.insert(model, at: 0)
        return self.set(models: models)
    }

    @discardableResult static func pop<T: Codable>(model: T.Type) -> T? {
        var models = self.all(model: model)
        let model = models.popLast()
        self.set(models: models)
        return model
    }
    @discardableResult static func shift<T: Codable>(model: T.Type) -> T? {
        var models = self.all(model: model)
        let model = models.first
        models.remove(at: 0)
        self.set(models: models)
        return model
    }

    @discardableResult static func append<T: Codable>(model: T) -> Bool { self.push(model: model) }
    @discardableResult static func create<T: Codable>(model: T) -> Bool { self.push(model: model) }
}
