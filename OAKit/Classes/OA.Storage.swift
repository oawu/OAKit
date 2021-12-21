//
//  OA.Storage.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

import UIKit

public extension OA {
    enum Storage {
        @discardableResult public static func set<T: Codable>(models: [T]) -> Bool {
            UserDefaults.standard.set("[\(models.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ","))]", forKey: String(describing: T.self))
            return true
        }

        @discardableResult public static func get<T: Codable>(model: T.Type) -> [T] {
            guard let str = UserDefaults.standard.string(forKey: String(describing: T.self)), let data = str.data(using: .utf8), let objs = try? JSONDecoder().decode([T].self, from:data) else { return [] }
            return objs
        }

        @discardableResult public static func truncate<T: Codable>(model: T.Type) -> Bool {
            let models: [T] = []
            return self.set(models: models)
        }

        public static func all<T: Codable>(model: T.Type) -> [T] { self.get(model: model) }

        public static func count<T: Codable>(model: T.Type) -> Int { self.get(model: model).count }

        public static func first<T: Codable>(model: T.Type) -> T? { self.all(model: model).first }

        public static func last<T: Codable>(model: T.Type) -> T? { self.all(model: model).last }

        public static func one<T: Codable>(model: T.Type) -> T? { self.first(model: model) }

        @discardableResult public static func push<T: Codable>(model: T) -> Bool {
            var models = self.all(model: T.self)
            models.append(model)
            return self.set(models: models)
        }
        @discardableResult public static func unshift<T: Codable>(model: T) -> Bool {
            var models = self.all(model: T.self)
            models.insert(model, at: 0)
            return self.set(models: models)
        }

        @discardableResult public static func pop<T: Codable>(model: T.Type) -> T? {
            var models = self.all(model: model)
            let model = models.popLast()
            self.set(models: models)
            return model
        }
        @discardableResult public static func shift<T: Codable>(model: T.Type) -> T? {
            var models = self.all(model: model)
            let model = models.first
            models.remove(at: 0)
            self.set(models: models)
            return model
        }

        @discardableResult public static func append<T: Codable>(model: T) -> Bool { self.push(model: model) }
        @discardableResult public static func create<T: Codable>(model: T) -> Bool { self.push(model: model) }
    }
}
