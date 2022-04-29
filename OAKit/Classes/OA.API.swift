//
//  OA.API.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

extension OA {
    public class API<E: Decodable> {
        private lazy var _url: URL? = nil
        private lazy var _cache: Bool = false
        private lazy var _method: Method? = nil
        private lazy var _queue: DispatchQueue? = .main

        private lazy var _params: [Param] = []
        private lazy var _dones: [(Done<E>) -> ()] = []
        private lazy var _fails: [(Fail) -> ()] = []

        private lazy var _befores: [() -> ()] = []
        private lazy var _afters: [() -> ()] = []
        
        private lazy var _progresses: [(Float) -> ()] = []
        private lazy var _delay: TimeInterval? = nil

        public init(url: URL? = nil, method: Method? = nil, delay: TimeInterval? = nil, queue: DispatchQueue? = nil, cache: Bool? = nil) { self.url(url).method(method).delay(second: delay).queue(queue).cache(cache) }
        public init(url: String? = nil, method: Method? = nil, delay: TimeInterval? = nil, queue: DispatchQueue? = nil, cache: Bool? = nil) { self.url(url).method(method).delay(second: delay).queue(queue).cache(cache) }
        
        @discardableResult public func url(_ url: URL?) -> Self {
            if let url = url { self._url = url }
            return self
        }
        @discardableResult public func url(_ str: String?) -> Self {
            if let str = str, let url = URL(string: str) { self._url = url }
            return self
        }
        @discardableResult public func cache(_ cache: Bool?) -> Self {
            if let cache = cache { self._cache = cache }
            return self
        }
        @discardableResult public func method(_ method: Method?) -> Self {
            if let method = method { self._method = method }
            return self
        }
        @discardableResult public func delay(second delay: TimeInterval?) -> Self {
            if let delay = delay { self._delay = delay }
            return self
        }
        @discardableResult public func queue(_ queue: DispatchQueue?) -> Self {
            if let queue = queue { self._queue = queue }
            return self
        }

        @discardableResult public func header(key: String, val: String?) -> Self {
            if key.isEmpty { return self }
            guard let val = val else { return self }
            self._params.append(.header(.init(key: key, val: val)))
            return self
        }
        @discardableResult public func query(key: String, val: String?) -> Self {
            if key.isEmpty { return self }
            guard let val = val else { return self }
            self._params.append(.query(.init(key: key, val: val)))
            return self
        }
        @discardableResult public func form(key: String, val: String?) -> Self {
            if key.isEmpty { return self }
            guard let val = val else { return self }
            self._params.append(.form(.init(key: key, val: val)))
            return self
        }
        @discardableResult public func file(key: String, mime: String, data: Data?, name: String? = nil) -> Self {
            if key.isEmpty { return self }
            if mime.isEmpty { return self }
            guard let data = data, !data.isEmpty else { return self }
            self._params.append(.file(.init(key: key, mime: mime, data: data, name: name ?? OA.Func.randomString(count: 10))))
            return self
        }
        @discardableResult public func raw(text: String?) -> Self {
            if let text = text { self._params.append(.rawText(.init(header: .init(key: "Content-Type", val: "text/plain"), content: text))) }
            return self
        }
        @discardableResult public func raw<T: Encodable>(model: T?) -> Self {
            if let model = model, let model = try? JSONEncoder().encode(model), let content = String(data: model, encoding: .utf8) { self._params.append(.rawJson(.init(header: .init(key: "Content-Type", val: "application/json"), content: content))) }
            return self
        }
        @discardableResult public func raw<T: Encodable>(models: [T]?) -> Self {
            if let models = models { self._params.append(.rawJson(.init(header: .init(key: "Content-Type", val: "application/json"), content: "[\(models.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ","))]"))) }
            return self
        }

        @discardableResult public func progress(_ progress: ((Float) -> ())?) -> Self {
            if let progress = progress { self._progresses.append(progress) }
            return self
        }
        @discardableResult public func before(before: (() -> ())?) -> Self {
            if let before = before { self._befores.append(before) }
            return self
        }
        @discardableResult public func after(after: (() -> ())?) -> Self {
            if let after = after { self._afters.append(after) }
            return self
        }
        @discardableResult public func fail(fail: ((Fail) -> ())?) -> Self {
            if let fail = fail { self._fails.append(fail) }
            return self
        }
        @discardableResult public func done(done: ((Done<E>) -> ())?) -> Self {
            if let done = done { self._dones.append(done) }
            return self
        }

        @discardableResult public func fail(fail: (() -> ())?) -> Self {
            if let fail = fail { self.fail { _ in fail() } }
            return self
        }
        @discardableResult public func done(done: (() -> ())?) -> Self {
            if let done = done { self.done { (_: Done<E>) in done() } }
            return self
        }
        @discardableResult public func done(done: ((E) -> ())?) -> Self {
            if let done = done { self.done { (_done: Done<E>) in done(_done.decode) } }
            return self
        }
        @discardableResult public func send() -> Self {
            if let delay = self._delay {
                OA.Timer.delay(key: "OA.API.\(String(UInt(bitPattern: ObjectIdentifier(self))))", second: delay) { self._send() }
            } else {
                self._send()
            }

            return self
        }

        @discardableResult public func get(done: ((Done<E>) -> ())? = nil) -> Self { self.method(.get).done(done: done).send() }
        @discardableResult public func post(done: ((Done<E>) -> ())? = nil) -> Self { self.method(.post).done(done: done).send() }
        @discardableResult public func put(done: ((Done<E>) -> ())? = nil) -> Self { self.method(.put).done(done: done).send() }
        @discardableResult public func delete(done: ((Done<E>) -> ())? = nil) -> Self { self.method(.delete).done(done: done).send() }
        
        @discardableResult public func get(done: (() -> ())?) -> Self { self.method(.get).done(done: done).send() }
        @discardableResult public func post(done: (() -> ())?) -> Self { self.method(.post).done(done: done).send() }
        @discardableResult public func put(done: (() -> ())?) -> Self { self.method(.put).done(done: done).send() }
        @discardableResult public func delete(done: (() -> ())?) -> Self { self.method(.delete).done(done: done).send() }
        
        @discardableResult public func get(done: ((E) -> ())?) -> Self { self.method(.get).done(done: done).send() }
        @discardableResult public func post(done: ((E) -> ())?) -> Self { self.method(.post).done(done: done).send() }
        @discardableResult public func put(done: ((E) -> ())?) -> Self { self.method(.put).done(done: done).send() }
        @discardableResult public func delete(done: ((E) -> ())?) -> Self { self.method(.delete).done(done: done).send() }

        private func _httpBody() -> Data {
            let files = self._params.compactMap { $0.file }
            let datas = self._params.compactMap { $0.form }

            var body: Data = .init()

            if files.isEmpty {
                guard datas.isEmpty else {
                    self.header(key: "Content-Type", val: "application/x-www-form-urlencoded")

                    return datas.compactMap({ data in
                        guard let val = data.val.addingPercentEncoding(withAllowedCharacters: Request.allowedCharacterSet) else { return nil }
                        return "\(data.key)=\(val)"
                    }).joined(separator: "&").data(using: .utf8) ?? body
                }

                guard let raw = self._params.compactMap({ $0.raw }).last else { return body }

                self.header(key: raw.header.key, val: raw.header.val)
                return raw.content.data(using: .utf8) ?? body
            }

            let boundary = "--\(OA.Func.randomString())"

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
        private func _send() {
            self._before()

            guard let url = self._url else { return _ = self._fail(code: 0, message: "沒有給予網址")._after() }
            guard let method = self._method else { return _ = self._fail(code: 0, message: "沒有給予方法")._after() }

            guard var urlComponents: URLComponents = .init(url: url, resolvingAgainstBaseURL: true) else {
                return _ = self._fail(code: 0, messages: ["拆分網址組件失敗(1)", "網址：\(url)"])._after()
            }

            let queries: [URLQueryItem] = self._params.compactMap {
                guard let data = $0.query, let val = data.val.addingPercentEncoding(withAllowedCharacters: Request.allowedCharacterSet) else { return nil }
                return .init(name: data.key, value: val)
            }

            if !queries.isEmpty {
                urlComponents.queryItems = queries
            }

            guard let url = urlComponents.url else {
                return _ = self._fail(code: 0, messages: ["拆分網址組件失敗(2)", "網址：\(url)"])._after()
            }

            var request: URLRequest = .init(url: url)
            request.httpMethod = method.rawValue
            if method != .get {
                request.httpBody = self._httpBody()
            }

            for header in self._params.compactMap({ $0.header }) {
                request.setValue(header.val, forHTTPHeaderField: header.key)
            }

            let config = URLSessionConfiguration.default

            if !self._cache {
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                config.urlCache = nil
            }

            let session: URLSession
            if self._progresses.isEmpty {
                session = .init(configuration: config)
            } else {
                session = .init(configuration: config, delegate: Delegate { self._progress(val: $0) }, delegateQueue: .main)
            }

            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    return _ = self._fail(code: 0, messages: ["執行失敗", error.localizedDescription])._after()
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    return _ = self._fail(code: 0, message: "回應格式錯誤")._after()
                }
                
                let code: UInt16 = .init(truncatingIfNeeded: httpResponse.statusCode)
                
                guard let data = data else {
                    return _ = self._fail(code: code, message: "資料錯誤")._after()
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
                    return _ = self._fail(code: code, messages: messages)._after()
                }

                let json: Any?
                let messages1: [String]

                do {
                    json = try JSONSerialization.jsonObject(with: data, options: [])
                    messages1 = ["不明原因錯誤", text]
                } catch {
                    json = nil
                    messages1 = ["轉換 Json 失敗", error.localizedDescription, text]
                }

                guard let json = json else {
                    return _ = self._fail(code: code, messages: messages1)._after()
                }

                let model: E?
                let messages2: [String]
                do {
                    model = try JSONDecoder().decode(E.self, from: try JSONSerialization.data(withJSONObject: json))
                    messages2 = ["\(json)"]
                } catch DecodingError.keyNotFound(let key, let context) {
                    model = nil
                    messages2 = ["無法找到 \(key) 這個 Key 的值", "\(context.debugDescription)", "\(data)"]
                } catch DecodingError.valueNotFound(let type, let context) {
                    model = nil
                    messages2 = ["無法找到 \(type) 這個 Type", "\(context.debugDescription)", "\(data)"]
                } catch DecodingError.typeMismatch(let type, let context) {
                    model = nil
                    messages2 = ["無法比對 \(type) 這個 Type", "\(context.debugDescription)", "\(data)"]
                } catch DecodingError.dataCorrupted(let context) {
                    model = nil
                    messages2 = ["資料格式有誤", "\(context.debugDescription)", "\(data)"]
                } catch {
                    model = nil
                    messages2 = ["執行 Decodable 發生錯誤", "\(error.localizedDescription)", "\(data)"]
                }

                guard let model = model else {
                    return _ = self._fail(code: code, messages: messages2)._after()
                }
                
                self._done(code: code, decode: model)._after()
            }.resume()
        }
        
        @discardableResult private func _fail(code: UInt16, messages: [String]) -> Self {
            if self._fails.isEmpty { return self }
            let fail: Fail = .init(code: code, messages: messages)

            if let queue = self._queue {
                self._fails.forEach { _fail in queue.async { _fail(fail) } }
            } else {
                self._fails.forEach { _fail in _fail(fail) }
            }
            return self
        }
        @discardableResult private func _fail(code: UInt16, message: String) -> Self { self._fail(code: code, messages: [message]) }
        @discardableResult private func _progress(val: Float) -> Self {
            if self._progresses.isEmpty { return self }

            if let queue = self._queue {
                self._progresses.forEach { progress in queue.async { progress(val) } }
            } else {
                self._progresses.forEach { progress in progress(val) }
            }
            return self
        }
        
        @discardableResult private func _before() -> Self {
            if self._befores.isEmpty { return self }
            
            if let queue = self._queue {
                self._befores.forEach { before in queue.async { before() } }
            } else {
                self._befores.forEach { before in before() }
            }
            return self
        }
        @discardableResult private func _after() -> Self {
            if self._afters.isEmpty { return self }
            
            if let queue = self._queue {
                self._afters.forEach { after in queue.async { after() } }
            } else {
                self._afters.forEach { after in after() }
            }
            return self
        }
        
        @discardableResult private func _done(code: UInt16, decode: E) -> Self {
            if self._dones.isEmpty { return self }
            let done: Done<E> = .init(code: code, decode: decode)

            if let queue = self._queue {
                self._dones.forEach { _done in queue.async { _done(done) } }
            } else {
                self._dones.forEach { _done in _done(done) }
            }
            return self
        }
    }
}
extension OA.API {
    public enum Method: String {
        case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
    }
    public struct Fail {
        public let code: UInt16
        public let messages: [String]
    }
    public struct Done<E: Decodable> {
        public let code: UInt16
        public let decode: E
    }

    fileprivate enum Param {

        case query(KeyVal), header(KeyVal), form(KeyVal), file(File), rawText(Raw), rawJson(Raw), rawJsons(Raw)

        public var header: KeyVal? {
            if case .header(let kv) = self { return kv }
            else { return nil }
        }

        public var query: KeyVal? {
            if case .query(let kv) = self { return kv }
            else { return nil }
        }

        public var form: KeyVal? {
            if case .form(let kv) = self { return kv }
            else { return nil }
        }

        public var file: File? {
            if case .file(let file) = self { return file }
            else { return nil }
        }

        public var raw: Raw? {
            if case .rawText(let raw) = self { return raw }
            if case .rawJson(let raw) = self { return raw }
            if case .rawJsons(let raw) = self { return raw }
            return nil
        }
    }

    fileprivate class Delegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
        private let _progress: ((Float) -> ())?
        
        public init(progress: ((Float) -> ())? = nil) {
            self._progress = progress
        }
        public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            guard let progress = self._progress else { return }
            let val: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            progress(val)
        }
    }
}

extension OA.API.Param {
    fileprivate struct KeyVal {
        public let key: String
        public let val: String
    }
    fileprivate struct File {
        public let key: String
        public let mime: String
        public let data: Data
        public let name: String
    }
    fileprivate struct Raw {
        public let header: KeyVal
        public let content: String
    }
}
