//
//  OA.API.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

public extension OA {
    class API<E: Decodable>: NSObject, URLSessionDelegate, URLSessionDataDelegate, OA_Http_Delegate {
        private lazy var _session: URLSession? = nil

        private lazy var _url: URL? = nil
        private lazy var _method: OA.Http.Method? = nil
        private lazy var _queue: DispatchQueue? = .main
        private lazy var _cache: Bool = false
        private lazy var _params: [OA.Http.Param] = []

        private lazy var _befores: [() -> ()] = []
        private lazy var _progresses: [(Float) -> ()] = []
        private lazy var _afters: [() -> ()] = []
        private lazy var _dones: [(Done<E>) -> ()] = []
        private lazy var _fails: [(OA.Http.Fail) -> ()] = []
        
        internal var params: [OA.Http.Param] { self._params }
        
        public init(url: URL? = nil, method: OA.Http.Method? = nil, queue: DispatchQueue? = nil, cache: Bool? = nil) {
            super.init()
            self.url(url)
                .method(method)
                .queue(queue)
                .cache(cache)
        }
        public init(url: String? = nil, method: OA.Http.Method? = nil, queue: DispatchQueue? = nil, cache: Bool? = nil) {
            super.init()
            self.url(url)
                .method(method)
                .queue(queue)
                .cache(cache)
        }
        
        // 設定
        @discardableResult public func url(_ url: URL?) -> Self {
            if let url = url {
                self._url = url
            }
            return self
        }
        @discardableResult public func url(_ str: String?) -> Self {
            if let str = str, let url = URL(string: str) {
                self._url = url
            }
            return self
        }
        @discardableResult public func method(_ method: OA.Http.Method?) -> Self {
            if let method = method {
                self._method = method
            }
            return self
        }
        @discardableResult public func queue(_ queue: DispatchQueue?) -> Self {
            if let queue = queue {
                self._queue = queue
            }
            return self
        }
        @discardableResult public func cache(_ cache: Bool?) -> Self {
            if let cache = cache {
                self._cache = cache
            }
            return self
        }
        
        // 參數
        @discardableResult public func header(key: String, val: String?) -> Self {
            guard let val = val, !key.isEmpty else {
                return self
            }
            self._params.append(
                .header(.init(
                    key: key,
                    val: val)))
            return self
        }
        @discardableResult public func query(key: String, val: String?) -> Self {
            guard let val = val, !key.isEmpty else {
                return self
            }
            self._params.append(
                .query(.init(
                    key: key,
                    val: val)))
            return self
        }
        @discardableResult public func form(key: String, val: String?) -> Self {
            guard let val = val, !key.isEmpty else {
                return self
            }
            self._params.append(
                .form(.init(
                    key: key,
                    val: val)))
            return self
        }
        @discardableResult public func file(key: String, mime: String, data: Data?, name: String? = nil) -> Self {
            guard let data = data, !data.isEmpty && !key.isEmpty && !mime.isEmpty else {
                return self
            }
            self._params.append(
                .file(.init(
                    key: key,
                    mime: mime,
                    data: data,
                    name: name ?? OA.Func.randomString(count: 10))))
            return self
        }
        @discardableResult public func raw(_ text: String?) -> Self {
            guard let text = text else {
                return self
            }
            self._params.append(
                .rawText(.init(
                    header: .init(
                        key: "Content-Type",
                        val: "text/plain"),
                    content: text)))
            return self
        }
        @discardableResult public func raw<T: Encodable>(_ model: T?) -> Self {
            guard let model = model, let model = try? JSONEncoder().encode(model), let content = String(data: model, encoding: .utf8) else {
                return self
            }
            self._params.append(
                .rawJson(.init(
                    header: .init(
                        key: "Content-Type",
                        val: "application/json"),
                    content: content)))
            return self
        }
        @discardableResult public func raw<T: Encodable>(_ models: [T]?) -> Self {
            guard let models = models else {
                return self
            }
            self._params.append(
                .rawJson(.init(
                    header: .init(
                        key: "Content-Type",
                        val: "application/json"),
                    content: "[\(models.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ","))]")))
            return self
        }
        
        // func
        @discardableResult public func progress(_ progress: ((Float) -> ())?) -> Self {
            if let progress = progress {
                self._progresses.append(progress)
            }
            return self
        }
        @discardableResult public func before(before: (() -> ())?) -> Self {
            if let before = before {
                self._befores.append(before)
            }
            return self
        }
        @discardableResult public func after(after: (() -> ())?) -> Self {
            if let after = after {
                self._afters.append(after)
            }
            return self
        }
        @discardableResult public func fail(fail: ((OA.Http.Fail) -> ())?) -> Self {
            if let fail = fail {
                self._fails.append(fail)
            }
            return self
        }
        @discardableResult public func fail(fail: (() -> ())?) -> Self {
            if let fail = fail {
                self.fail { _ in
                    fail()
                }
            }
            return self
        }
        @discardableResult public func done(done: ((Done<E>) -> ())?) -> Self {
            if let done = done {
                self._dones.append(done)
            }
            return self
        }
        @discardableResult public func done(done: ((E) -> ())?) -> Self {
            if let done = done {
                self.done { (_done: Done<E>) in
                    done(_done.decode)
                }
            }
            return self
        }
        @discardableResult public func done(done: (() -> ())?) -> Self {
            if let done = done {
                self.done { (_done: Done<E>) in
                    done()
                }
            }
            return self
        }
        
        // call func
        @discardableResult private func _before() -> Self {
            if self._befores.isEmpty { return self }
            
            if let queue = self._queue {
                for before in self._befores {
                    queue.async(execute: before)
                }
            } else {
                for before in self._befores {
                    before()
                }
            }
            return self
        }
        @discardableResult private func _progress(val: Float) -> Self {
            if self._progresses.isEmpty { return self }

            if let queue = self._queue {
                for progress in self._progresses {
                    queue.async { progress(val) }
                }
            } else {
                for progress in self._progresses {
                    progress(val)
                }
            }
            return self
        }
        @discardableResult private func _after() -> Self {
            self._session?.finishTasksAndInvalidate()
            self._session?.invalidateAndCancel()

            if self._afters.isEmpty { return self }
            
            if let queue = self._queue {
                for after in self._afters {
                    queue.async(execute: after)
                }
            } else {
                for after in self._afters {
                    after()
                }
            }
            return self
        }
        @discardableResult private func _fail(_ _fail: OA.Http.Fail) -> Self {
            if self._fails.isEmpty { return self }

            if let queue = self._queue {
                for fail in self._fails {
                    queue.async { fail(_fail) }
                }
            } else {
                for fail in self._fails {
                    fail(_fail)
                }
            }
            return self
        }
        @discardableResult private func _done(code: UInt16, decode: E, text: String) -> Self {
            if self._dones.isEmpty { return self }

            let _done: Done<E> = .init(code: code, decode: decode, text: text)

            if let queue = self._queue {
                for done in self._dones {
                    queue.async { done(_done) }
                }
            } else {
                for done in self._dones {
                    done(_done)
                }
            }
            return self
        }
        
        
        // exec
        @discardableResult public func send() -> Self {
            self._before()

            guard let url = self._url else {
                return self._fail(.init(code: 0, messages: ["沒有給予網址"]))._after()
            }
            guard let method = self._method else {
                return self._fail(.init(code: 0, messages: ["沒有給予方法"]))._after()
            }
            guard var urlComponents: URLComponents = .init(url: url, resolvingAgainstBaseURL: true) else {
                return self._fail(.init(code: 0, messages: ["拆分網址組件失敗(1)", "網址：\(url)"]))._after()
            }

            let queries: [URLQueryItem] = self._params.compactMap {
                guard let data = $0.query, let val = data.val.addingPercentEncoding(withAllowedCharacters: OA.Http._allowedCharacterSet) else { return nil }
                return .init(name: data.key, value: val)
            }

            if !queries.isEmpty {
                urlComponents.queryItems = queries
            }

            guard let url = urlComponents.url else {
                return self._fail(.init(code: 0, messages: ["拆分網址組件失敗(2)", "網址：\(url)"]))._after()
            }

            var request: URLRequest = .init(url: url)
            request.httpMethod = method.rawValue
            if method != .get {
                request.httpBody = OA.Http.httpBody(delegate: self)
            }

            for header in self._params.compactMap({ $0.header }) {
                request.setValue(header.val, forHTTPHeaderField: header.key)
            }

            let config = URLSessionConfiguration.default

            if !self._cache {
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                config.urlCache = nil
            }

            self._session = self._progresses.isEmpty
                ? .init(configuration: config)
                : .init(configuration: config, delegate: self, delegateQueue: .main)
            
            self._session?.dataTask(with: request) { data, response, error in
                if let error = error {
                    return _ = self._fail(.init(code: 0, messages: ["執行失敗", error.localizedDescription]))._after()
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    return _ = self._fail(.init(code: 0, messages: ["回應格式錯誤"]))._after()
                }
                
                let code: UInt16 = .init(truncatingIfNeeded: httpResponse.statusCode)

                guard let data = data else {
                    return _ = self._fail(.init(code: code, messages: ["資料錯誤"]))._after()
                }
                guard code >= 200 && code < 300 else {
                    return _ = self._fail(OA.Http.not200(code: code, data: data))._after()
                }

                let json: Any?
                let messages: [String]

                do {
                    json = try JSONSerialization.jsonObject(with: data, options: [])
                    messages = [.init(decoding: data, as: UTF8.self), "不明原因錯誤"]
                } catch {
                    json = nil
                    messages = [.init(decoding: data, as: UTF8.self), "轉換 Json 失敗", error.localizedDescription]
                }

                if let json = json {
                    self._decode(code: code, data: data, json: json)
                } else {
                    self._fail(.init(code: code, messages: messages))._after()
                }
            }.resume()
            
            return self
        }

        private func _decode(code: UInt16, data: Data, json: Any) {
            let text: String = .init(decoding: data, as: UTF8.self)
            let model: E?
            let messages: [String]

            do {
                model = try JSONDecoder().decode(E.self, from: try JSONSerialization.data(withJSONObject: json))
                messages = []
            } catch DecodingError.keyNotFound(let key, let context) {
                model = nil
                messages = [text, "無法找到 \(key) 這個 Key 的值", "\(context.debugDescription)", "\(data)"]
            } catch DecodingError.valueNotFound(let type, let context) {
                model = nil
                messages = [text, "無法找到 \(type) 這個 Type", "\(context.debugDescription)", "\(data)"]
            } catch DecodingError.typeMismatch(let type, let context) {
                model = nil
                messages = [text, "無法比對 \(type) 這個 Type", "\(context.debugDescription)", "\(data)"]
            } catch DecodingError.dataCorrupted(let context) {
                model = nil
                messages = [text, "資料格式有誤", "\(context.debugDescription)", "\(data)"]
            } catch {
                model = nil
                messages = [text, "執行 Decodable 發生錯誤", "\(error.localizedDescription)", "\(data)"]
            }

            if let model = model {
                self._done(code: code, decode: model, text: text)._after()
            } else {
                self._fail(.init(code: code, messages: messages))._after()
            }
        }
        
        // delegate
        public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            self._progress(val: Float(totalBytesSent) / Float(totalBytesExpectedToSend))
        }
        
        // method
        @discardableResult public func get(done: ((Done<E>) -> ())? = nil) -> Self {
            self.method(.get)
                .done(done: done)
                .send()
        }
        @discardableResult public func get(done: ((E) -> ())?) -> Self {
            self.method(.get)
                .done(done: done)
                .send()
        }
        @discardableResult public func get(done: (() -> ())?) -> Self {
            self.method(.get)
                .done(done: done)
                .send()
        }
        
        @discardableResult public func post(done: ((Done<E>) -> ())? = nil) -> Self {
            self.method(.post)
                .done(done: done)
                .send()
        }
        @discardableResult public func post(done: ((E) -> ())?) -> Self {
            self.method(.post)
                .done(done: done)
                .send()
        }
        @discardableResult public func post(done: (() -> ())?) -> Self {
            self.method(.post)
                .done(done: done)
                .send()
        }
        
        @discardableResult public func put(done: ((Done<E>) -> ())? = nil) -> Self {
            self.method(.put)
                .done(done: done)
                .send()
        }
        @discardableResult public func put(done: ((E) -> ())?) -> Self {
            self.method(.put)
                .done(done: done)
                .send()
        }
        @discardableResult public func put(done: (() -> ())?) -> Self {
            self.method(.put)
                .done(done: done)
                .send()
        }
        
        @discardableResult public func delete(done: ((Done<E>) -> ())? = nil) -> Self {
            self.method(.delete)
                .done(done: done)
                .send()
        }
        @discardableResult public func delete(done: ((E) -> ())?) -> Self {
            self.method(.delete)
                .done(done: done)
                .send()
        }
        @discardableResult public func delete(done: (() -> ())?) -> Self {
            self.method(.delete)
                .done(done: done)
                .send()
        }
    }
}

public extension OA.API {
    struct Done<E: Decodable> {
        public let code: UInt16
        public let decode: E
        public let text: String
    }
}
