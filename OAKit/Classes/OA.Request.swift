//
//  OA.Request.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

import UIKit

public extension OA {
    
    class Request {
        public static let allowedCharacterSet: CharacterSet = {
            var tmp: CharacterSet = .urlQueryAllowed
            tmp.remove(charactersIn: ";/?:@&=+$, ")
            return tmp
        }()
        
        public class Delegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
            private let progress: (Float) -> ()

            public init(progress: @escaping((Float) -> ())) {
                self.progress = progress
                super.init()
            }
            public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
                self.progress(Float(totalBytesSent) / Float(totalBytesExpectedToSend))
            }
        }

        public enum Method: String {
            case GET, POST, PUT, DELETE
        }
        public enum Param {
            public struct KeyVal {
                let key: String
                let val: String
            }
            public struct File {
                let key: String
                let mime: String
                let data: Data
                let name: String
            }

            public struct Raw {
                let header: KeyVal
                let content: String
            }

            case query(KeyVal),
                header(KeyVal),
                form(KeyVal),
                file(File),
                rawText(Raw),
                rawJson(Raw),
                rawJsons(Raw)

            public var header: KeyVal? {
                guard case .header(let kv) = self else { return nil }
                return kv
            }

            public var query: KeyVal? {
                guard case .query(let kv) = self else { return nil }
                return kv
            }

            public var form: KeyVal? {
                guard case .form(let kv) = self else { return nil }
                return kv
            }

            public var file: File? {
                guard case .file(let file) = self else { return nil }
                return file
            }

            public var raw: Raw? {
                if case .rawText(let raw) = self { return raw }
                if case .rawJson(let raw) = self { return raw }
                if case .rawJsons(let raw) = self { return raw }
                return nil
            }
        }
        public struct Error {
            public let code: UInt16
            public let messages: [String]
        }

        private let url: URL
        private lazy var method: Method = .GET
        private lazy var params: [Param] = []
        private lazy var dones: [(UInt16, Any) -> ()] = []
        internal lazy var fails: [(Error) -> ()] = []

        private lazy var befores: [() -> ()] = []
        private lazy var afters: [() -> ()] = []
        private lazy var isCache: Bool = false
        private lazy var isAPI: Bool = false
        private lazy var queue: DispatchQueue? = .main

        private lazy var progress: ((Float) -> ())? = nil
        private lazy var delay: TimeInterval? = nil

        public init(url: URL, delay: TimeInterval? = nil) {
            self.url = url
            self.delay = delay
        }
        public convenience init?(url: URL?, delay: TimeInterval? = nil) {
            guard let url = url else { return nil }
            self.init(url: url, delay: delay)
        }
        public convenience init?(url: String, delay: TimeInterval? = nil) { self.init(url: URL(string: url), delay: delay) }
        
        @discardableResult public func method(_ method: Method) -> Self {
            self.method = method
            return self
        }
        @discardableResult public func queue(_ queue: DispatchQueue) -> Self {
            self.queue = queue
            return self
        }
        @discardableResult public func isCache(_ isCache: Bool) -> Self {
            self.isCache = isCache
            return self
        }
        @discardableResult internal func isAPI(_ isAPI: Bool) -> Self {
            self.isAPI = isAPI
            return self
        }
        @discardableResult public func header(key: String, val: String?) -> Self {
            if let val = val { self.params.append(.header(.init(key: key, val: val))) }
            return self
        }
        @discardableResult public func progress(_ progress: @escaping (Float) -> ()) -> Self {
            self.progress = progress
            return self
        }

        @discardableResult public func query(key: String, val: String?) -> Self {
            if let val = val { self.params.append(.query(.init(key: key, val: val))) }
            return self
        }
        @discardableResult public func form(key: String, val: String?) -> Self {
            if let val = val { self.params.append(.form(.init(key: key, val: val))) }
            return self
        }
        @discardableResult public func file(key: String, mime: String, data: Data?, name: String? = nil) -> Self {
            if let data = data { self.params.append(.file(.init(key: key, mime: mime, data: data, name: name ?? "\(OA.Func.randomString(count: 10))"))) }
            return self
        }
        @discardableResult public func raw(text: String?) -> Self {
            if let text = text { self.params.append(.rawText(.init(header: .init(key: "Content-Type", val: "text/plain"), content: text))) }
            return self
        }
        @discardableResult public func raw<T: Encodable>(model: T?) -> Self {
            if let model = model, let model = try? JSONEncoder().encode(model), let content = String(data: model, encoding: .utf8) {
                self.params.append(.rawJson(.init(header: .init(key: "Content-Type", val: "application/json"), content: content)))
            }
            return self
        }
        @discardableResult public func raw<T: Encodable>(models: [T]?) -> Self {
            if let models = models {
                self.params.append(.rawJson(.init(header: .init(key: "Content-Type", val: "application/json"), content: "[\(models.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ","))]")))
            }
            return self
        }
        
        @discardableResult public func auth(bearer: String) -> Self { self.header(key: "Authorization", val: "Bearer \(bearer)") }
        @discardableResult public func userAgent(val: String) -> Self { self.header(key: "User-Agent", val: val) }

        @discardableResult public func before(before: @escaping () -> ()) -> Self {
            self.befores.append(before)
            return self
        }
        @discardableResult public func after(after: @escaping () -> ()) -> Self {
            self.afters.append(after)
            return self
        }

        @discardableResult public func fail(closure: @escaping (Error) -> ()) -> Self {
            self.fails.append(closure)
            return self
        }
        @discardableResult public func fail(closure: @escaping (UInt16) -> ()) -> Self {
            self.fails.append { closure($0.code) }
            return self
        }
        @discardableResult public func fail(closure: @escaping (UInt16, [String]) -> ()) -> Self {
            self.fails.append { closure($0.code, $0.messages) }
            return self
        }
        @discardableResult public func fail(closure: @escaping ([String]) -> ()) -> Self {
            self.fails.append { closure($0.messages) }
            return self
        }
        @discardableResult public func fail(closure: @escaping ([String], UInt16) -> ()) -> Self {
            self.fails.append { closure($0.messages, $0.code) }
            return self
        }
        @discardableResult public func fail(closure: @escaping () -> ()) -> Self {
            self.fails.append { _ in closure() }
            return self
        }
        @discardableResult public func done(closure: @escaping (UInt16, Any) -> ()) -> Self {
            self.dones.append(closure)
            return self
        }
        @discardableResult public func done(closure: @escaping (UInt16) -> ()) -> Self {
            self.dones.append { c, _ in closure(c) }
            return self
        }
        @discardableResult public func done(closure: @escaping (Any, UInt16) -> ()) -> Self {
            self.dones.append { c, a in closure(a, c) }
            return self
        }
        @discardableResult public func done(closure: @escaping (Any) -> ()) -> Self {
            self.dones.append { _, a in closure(a) }
            return self
        }
        @discardableResult public func done(closure: @escaping () -> ()) -> Self {
            self.dones.append { _, _ in closure() }
            return self
        }

        @discardableResult public func get(done: @escaping (UInt16, Any) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (Any, UInt16) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (UInt16) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping (Any) -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func get(done: @escaping () -> ()) -> Self { self.method(.GET).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (UInt16, Any) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (Any, UInt16) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (UInt16) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping (Any) -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func post(done: @escaping () -> ()) -> Self { self.method(.POST).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (UInt16, Any) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (Any, UInt16) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (UInt16) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping (Any) -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func put(done: @escaping () -> ()) -> Self { self.method(.PUT).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (UInt16, Any) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (Any, UInt16) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (UInt16) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping (Any) -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }
        @discardableResult public func delete(done: @escaping () -> ()) -> Self { self.method(.DELETE).done(closure: done).send() }

        private func httpBody() -> Data {
            let files = self.params.compactMap { $0.file }
            let datas = self.params.compactMap { $0.form }

            var body: Data = .init()

            if files.isEmpty {
                guard datas.isEmpty else {
                    self.header(key: "Content-Type", val: "application/x-www-form-urlencoded")

                    return datas.compactMap({ data in
                        guard let val = data.val.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacterSet) else { return nil }
                        return "\(data.key)=\(val)"
                    }).joined(separator: "&").data(using: .utf8) ?? body
                }
                guard let raw = self.params.compactMap({ $0.raw }).last else {
                    return body
                }
                self.header(key: raw.header.key, val: raw.header.val)
                return raw.content.data(using: .utf8) ?? body
            }

            let boundary = "--" + OA.Func.randomString()

            self.header(key: "Content-Type", val: "multipart/form-data; boundary=\(boundary)")

            for data in datas.compactMap({ "--\(boundary)\r\nContent-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n\($0.val)\r\n".data(using: .utf8, allowLossyConversion: true) }) {
                body.append(data)
            }

            for file in files {
                if let s = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\r\nContent-Type: \(file.mime)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true), let e = "\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
                    body.append(s)
                    body.append(file.data)
                    body.append(e)
                }
            }

            if let end = "--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
                body.append(end)
            }

            return body
        }
        
        @discardableResult private func done(code: UInt16, data: Any) -> Self {
            guard let queue = self.queue else {
                self.dones.forEach { $0(code, data) }
                return self
            }
            queue.async { self.dones.forEach { $0(code, data) } }
            return self
        }
        @discardableResult private func fail(code: UInt16, messages: [String]) -> Self {
            guard let queue = self.queue else {
                self.fails.forEach { $0(.init(code: code, messages: messages)) }
                return self
            }
            queue.async { self.fails.forEach { $0(.init(code: code, messages: messages)) } }
            return self
        }
        private func before() {
            guard let queue = self.queue else { return self.befores.forEach { $0() } }
            return queue.async { self.befores.forEach { $0() } }
        }
        private func after() {
            guard let queue = self.queue else { return self.afters.forEach { $0() } }
            return queue.async { self.afters.forEach { $0() } }
        }

        @discardableResult public func send() -> Self {
            guard let delay = self.delay else { return self._send() }
            OA.Timer.delay(key: "OA.Request.\(String(UInt(bitPattern: ObjectIdentifier(self))))", second: delay) { self._send() }
            return self
        }

        @discardableResult private func _send() -> Self {
            guard var urlComponents = URLComponents(url: self.url, resolvingAgainstBaseURL: true) else {
                return self.fail(code: 0, messages: ["拆分網址組件失敗(1)", "網址：\(self.url)"])
            }

            var allowedCharacterSet: CharacterSet = .urlQueryAllowed
            allowedCharacterSet.remove(charactersIn: ";/?:@&=+$, ")

            let queries: [URLQueryItem] = self.params.compactMap {
                guard let data = $0.query, let val = data.val.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else { return nil }
                return URLQueryItem(name: data.key, value: val)
            }

            if !queries.isEmpty {
                urlComponents.queryItems = queries
            }

            guard let url = urlComponents.url else {
                return self.fail(code: 0, messages: ["拆分網址組件失敗(2)", "網址：\(self.url)"])
            }

            var request: URLRequest = .init(url: url)
            request.httpMethod = self.method.rawValue
            if self.method != .GET {
                request.httpBody = self.httpBody()
            }

            for header in self.params.compactMap({ $0.header }) {
                request.setValue(header.val, forHTTPHeaderField: header.key)
            }

            let config = URLSessionConfiguration.default

            if !self.isCache {
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                config.urlCache = nil
            }

            var session: URLSession = URLSession(configuration: config)

            if let progress = self.progress {
                session = URLSession(configuration: config, delegate: Delegate(progress: progress), delegateQueue: .main)
            }

            let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    return self.fail(code: 0, messages: ["執行失敗", error.localizedDescription]).after()
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    return self.fail(code: 0, messages: ["回應格式錯誤"]).after()
                }

                let code = UInt16(truncatingIfNeeded: httpResponse.statusCode)

                guard let data = data else {
                    return self.fail(code: code, messages: ["資料錯誤"]).after()
                }

                let text: String = .init(decoding: data, as: UTF8.self)

                guard code >= 200 && code < 300 else {
                    let messages: [String]

                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonData = json as? [String: [String]] {
                            if let msgs = jsonData["messages"] {
                                messages = msgs
                            } else {
                                messages = ["轉換 Json 失敗，沒有 messages", text]
                            }
                        } else {
                            messages = ["轉換 Json 失敗，結構錯誤", text]
                        }
                    } catch {
                        messages = ["回應不是 Json 格式", error.localizedDescription, text]
                    }
                    return self.fail(code: code, messages: messages).after()
                }

                guard self.isAPI || ((response?.mimeType ?? "") == "application/json") else {
                    return self.done(code: code, data: data).after()
                }

                let json: Any?
                let messages: [String]
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: [])
                    messages = []
                } catch {
                    json = nil
                    messages = ["轉換 Json 失敗", error.localizedDescription, text]
                }

                guard let json = json else {
                    return self.fail(code: code, messages: messages + [text]).after()
                }
                return self.done(code: code, data: json).after()
            }

            self.before()
            task.resume()
            return self
        }
    }
}
