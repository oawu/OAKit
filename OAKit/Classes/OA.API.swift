//
//  OA.API.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

import UIKit

public extension OA {
    
    class API<E: Decodable>: Request {
        private lazy var dones: [(E, UInt16, Any) -> ()] = []

        @discardableResult private func fail(code: UInt16, messages: [String]) -> Self {
            self.fails.forEach { $0(.init(code: code, messages: messages)) }
            return self
        }

        @discardableResult public func done(closure: @escaping (E, UInt16, Any) -> ()) -> Self {
            self.dones.append(closure)
            return self
        }
        @discardableResult public func done(closure: @escaping (E, Any, UInt16) -> ()) -> Self {
            self.dones.append { e, c, a in closure(e, a, c) }
            return self
        }
        @discardableResult public func done(closure: @escaping (UInt16, E, Any) -> ()) -> Self {
            self.dones.append { e, c, a in closure(c, e, a) }
            return self
        }
        @discardableResult public func done(closure: @escaping (UInt16, Any, E) -> ()) -> Self {
            self.dones.append { e, c, a in closure(c, a, e) }
            return self
        }
        @discardableResult public func done(closure: @escaping (Any, E, UInt16) -> ()) -> Self {
            self.dones.append { e, c, a in closure(a, e, c) }
            return self
        }
        @discardableResult public func done(closure: @escaping (Any, UInt16, E) -> ()) -> Self {
            self.dones.append { e, c, a in closure(a, c, e) }
            return self
        }
        @discardableResult public func done(closure: @escaping (E, Any) -> ()) -> Self {
            self.dones.append { e, _, a in closure(e, a) }
            return self
        }
        @discardableResult public func done(closure: @escaping (E, UInt16) -> ()) -> Self {
            self.dones.append { e, c, _ in closure(e, c) }
            return self
        }
        @discardableResult public func done(closure: @escaping (UInt16, E) -> ()) -> Self {
            self.dones.append { e, c, _ in closure(c, e) }
            return self
        }
        @discardableResult public func done(closure: @escaping (Any, E) -> ()) -> Self {
            self.dones.append { e, _, a in closure(a, e) }
            return self
        }
        @discardableResult public func done(closure: @escaping (E) -> ()) -> Self {
            self.dones.append { e, _, _ in closure(e) }
            return self
        }
        @discardableResult public func get(done: @escaping (E, UInt16, Any) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (E, Any, UInt16) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (UInt16, E, Any) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (UInt16, Any, E) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (Any, E, UInt16) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (Any, UInt16, E) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (E, Any) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (E, UInt16) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (UInt16, E) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (Any, E) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (E) -> ()) -> Self { self.method(.GET).done(closure: done).send() }

        @discardableResult public func post(done: @escaping (E, UInt16, Any) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (E, Any, UInt16) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (UInt16, E, Any) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (UInt16, Any, E) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (Any, E, UInt16) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (Any, UInt16, E) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (E, Any) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (E, UInt16) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (UInt16, E) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (Any, E) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (E) -> ()) -> Self { self.method(.POST).done(closure: done).send() }

        @discardableResult public func put(done: @escaping (E, UInt16, Any) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (E, Any, UInt16) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (UInt16, E, Any) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (UInt16, Any, E) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (Any, E, UInt16) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (Any, UInt16, E) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (E, Any) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (E, UInt16) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (UInt16, E) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (Any, E) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (E) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }

        @discardableResult public func delete(done: @escaping (E, UInt16, Any) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (E, Any, UInt16) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (UInt16, E, Any) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (UInt16, Any, E) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (Any, E, UInt16) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (Any, UInt16, E) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (E, Any) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (E, UInt16) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (UInt16, E) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (Any, E) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (E) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }

        @discardableResult public override func send() -> Self {
            self.isAPI(true).done { (code: UInt16, data: Any) in
                let model: E?
                let messages: [String]
                do {
                    model = try JSONDecoder().decode(E.self, from: try JSONSerialization.data(withJSONObject: data))
                    messages = []
                } catch DecodingError.keyNotFound(let key, let context) {
                    model = nil
                    messages = ["無法找到 \(key) 這個 Key 的值", "\(context.debugDescription)", "\(data)"]
                } catch DecodingError.valueNotFound(let type, let context) {
                    model = nil
                    messages = ["無法找到 \(type) 這個 Type", "\(context.debugDescription)", "\(data)"]
                } catch DecodingError.typeMismatch(let type, let context) {
                    model = nil
                    messages = ["無法比對 \(type) 這個 Type", "\(context.debugDescription)", "\(data)"]
                } catch DecodingError.dataCorrupted(let context) {
                    model = nil
                    messages = ["資料格式有誤", "\(context.debugDescription)", "\(data)"]
                } catch {
                    model = nil
                    messages = ["執行 Decodable 發生錯誤", "\(error.localizedDescription)", "\(data)"]
                }
                
                guard let model = model else { return self.fail(code: code, messages: messages).after() }
                
                self.dones.forEach { $0(model, code, data) }
                self.after()
            }
            return super.send()
        }
    }
}
