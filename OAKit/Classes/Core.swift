//
//  Core.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit

public struct OA {}

public extension OA {
    static func randomString(count: Int = 32) -> String {
        let allowed  = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let maxCount = allowed.count
        var output   = ""

        for _ in 0 ..< count {
            let r = Int(arc4random_uniform(UInt32(maxCount)))
            let randomIndex = allowed.index(allowed.startIndex, offsetBy: r)

            output += String(allowed[randomIndex])
        }

        return output
    }

    static func timeago(unixtime: UInt) -> String {
        let diff = UInt(NSDate().timeIntervalSince1970) - unixtime

        let contitions: [[String: Any]] = [
            ["base": 10, "format": "現在"],
            ["base": 6, "format": "不到 1 分鐘"],
            ["base": 60, "format": "%d 分鐘前"],
            ["base": 24, "format": "%d 小時前"],
            ["base": 30, "format": "%d 天前"],
            ["base": 12, "format": "%d 個月前"]
        ]
        
        var unit: UInt = 1
        
        for contition in contitions {
            if let base = contition["base"] as? Int, let format = contition["format"] as? String {
                let tmp = UInt(base) * unit
                
                if diff < tmp {
                    return String(format: format, diff / unit)
                }
                
                unit = tmp
            }
        }
        return String(format: "%d 年前", diff / unit)
    }
    
    static func arr22D(arr: [Any]!, unit: Int) -> [[Any]]! {
        guard let arri = arr, arri.count % unit == 0 else { return nil; }
        
        var anys:[[Any]]! = [];
        
        for (i, el) in arri.enumerated() {
            if !anys.indices.contains(i / unit) {
                anys.append([el])
            } else {
                anys[i / unit].append(el)
            }
        }
        return anys;
    }

    class Request {
        public static let allowedCharacterSet: CharacterSet = {
            var sets = CharacterSet.urlQueryAllowed
            sets.remove(charactersIn: ";/?:@&=+$, ")
            return sets
        }()

        public class Delegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
            private var progress: (Float) -> ()
            public init(progress: @escaping((Float) -> ())) { self.progress = progress }
            public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) { self.progress(Float(totalBytesSent) / Float(totalBytesExpectedToSend)) }
        }

        public enum Method: String {
            case GET, POST, PUT, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE, LOCK, UNLOCK, PROPFIND, VIEW
        }

        public enum Param {
            case query(String, String?), header(String, String?), form(String, String?), file(String, String, Data?, String?), rawText(String), rawJson(String), rawJsons(String)

            public var file: (key: String, mime: String, data: Data, name: String)? {
                guard case .file(let key, let mime, let data？, let name) = self, let data = data？ else { return nil }
                return (key: key, mime: mime, data: data, name: name ?? "\(OA.randomString(count: 10))")
            }

            public var form: (key: String, val: String)? {
                guard case .form(let key, let val？) = self, let val = val？ else { return nil }
                return (key: key, val: val)
            }

            public var header: (key: String, val: String)? {
                guard case .header(let key, let val？) = self, let val = val？ else { return nil }
                return (key: key, val: val)
            }

            public var query: (key: String, val: String)? {
                guard case .query(let key, let val？) = self, let val = val？ else { return nil }
                return (key: key, val: val)
            }

            public var raw: (header: (key: String, val: String), text: String)? {
                if case .rawText(let text) = self { return (header: (key: "Content-Type", val: "text/plain"), text: text) }
                if case .rawJson(let text) = self { return (header: (key: "Content-Type", val: "application/json"), text: text) }
                if case .rawJsons(let text) = self { return (header: (key: "Content-Type", val: "application/json"), text: text) }
                return nil
            }
        }

        private var method: Method = .GET
        private var url: URL? = nil
        private var params: [Param] = []
        private var isJson: Bool = true
        private var isCache: Bool = false
        private var fail: ((UInt16, String, String?) -> ())? = nil
        private var progress: ((Float) -> ())? = nil

        public init() {}

        public init(url: URL? = nil) { self.set(url: url) }
        
        public init(url: String) { self.set(url: url) }

        @discardableResult public func set(isJson: Bool) -> Self {
            self.isJson = isJson
            return self
        }

        @discardableResult public func set(isCache: Bool) -> Self {
            self.isCache = isCache
            return self
        }
        
        @discardableResult public func set(url: URL?) -> Self {
            self.url = url
            return self
        }

        @discardableResult public func set(method: Method) -> Self {
            self.method = method
            return self
        }

        @discardableResult public func set(params:[Param]) -> Self {
            self.params = params
            return self
        }

        @discardableResult public func set(fail: @escaping (UInt16, String, String?) -> ()) -> Self {
            self.fail = fail
            return self
        }

        @discardableResult public func set(progress: @escaping (Float) -> ()) -> Self {
            self.progress = progress
            return self
        }

        @discardableResult public func append(param: Param) -> Self {
            self.params.append(param)
            return self
        }

        @discardableResult public func isJson(_ isJson: Bool) -> Self { self.set(isJson: isJson) }
        @discardableResult public func isCache(_ isCache: Bool) -> Self { self.set(isCache: isCache) }

        @discardableResult public func url(_ url: URL?) -> Self { self.set(url: url) }
        @discardableResult public func set(url: String) -> Self { self.set(url: URL(string: url)) }
        @discardableResult public func url(_ url: String) -> Self { self.set(url: url) }
        
        @discardableResult public func method(_ method: Method) -> Self { self.set(method: method) }
        @discardableResult public func params(_ params: [Param]) -> Self { self.set(params: params) }
        @discardableResult public func header(key: String, val: String?) -> Self { self.append(param: .header(key, val)) }
        @discardableResult public func query(key: String, val: String?) -> Self { self.append(param: .query(key, val)) }
        @discardableResult public func form(key: String, val: String?) -> Self { self.append(param: .form(key, val)) }
        @discardableResult public func file(key: String, mime: String, data: Data?, name: String) -> Self { self.append(param: .file(key, mime, data, name)) }
        @discardableResult public func raw(text: String) -> Self { self.append(param: .rawText(text)) }
        @discardableResult public func raw<T: Encodable>(object: T) -> Self { self.append(param: .rawJsons("\([object].compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ""))")) }
        @discardableResult public func raw<T: Encodable>(objects: [T]) -> Self { self.append(param: .rawJsons("[\(objects.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ","))]")) }
        @discardableResult public func fail(fail: @escaping (UInt16, String, String?) -> ()) -> Self { self.set(fail: fail) }
        @discardableResult public func progress(progress: @escaping (Float) -> ()) -> Self { self.set(progress: progress) }
        
        private static func decodable<T: Decodable>(request: OA.Request, data: Any, callback: @escaping (T) -> ()) {
            do {
                return callback(try JSONDecoder().decode(T.self, from: try JSONSerialization.data(withJSONObject: data)))
            } catch DecodingError.keyNotFound(let key, let context) {
                return request.fail?(200, "無法找到 \(key) 這個 Key 的值，錯誤原因：\(context.debugDescription)", "\(data)") ?? ()
            } catch DecodingError.valueNotFound(let type, let context) {
                return request.fail?(200, "無法找到 \(type) 這個 Type，錯誤原因：\(context.debugDescription)", "\(data)") ?? ()
            } catch DecodingError.typeMismatch(let type, let context) {
                return request.fail?(200, "無法比對 \(type) 這個 Type，錯誤原因：\(context.debugDescription)", "\(data)") ?? ()
            } catch DecodingError.dataCorrupted(let context) {
                return request.fail?(200, "資料格式有誤，錯誤原因：\(context.debugDescription)", "\(data)") ?? ()
            } catch {
                return request.fail?(200, "執行 Decodable 發生錯誤，錯誤原因：\(error.localizedDescription)", "\(data)") ?? ()
            }
        }
        
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
                return raw.text.data(using: .utf8) ?? body
            }

            let boundary = "--" + OA.randomString()

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
        
        @discardableResult
        private func send(method: Method, isJson: Bool = true, callback: @escaping (Any, UInt16) -> ()) -> Self {
            guard let url？ = self.self.method(method).isJson(isJson).url, var urlComponents = URLComponents(url: url？, resolvingAgainstBaseURL: true) else {
                self.fail?(0, "無效的 URL，其不可為 nil(1)", nil) ?? ()
                return self
            }
            
            let query: [URLQueryItem] = self.params.compactMap({ param in
                guard let data = param.query, let val = data.val.addingPercentEncoding(withAllowedCharacters: Self.allowedCharacterSet) else { return nil }
                return URLQueryItem(name: data.key, value: val)
            })

            if !query.isEmpty {
                urlComponents.queryItems = query
            }
            
            guard let url = urlComponents.url else {
                self.fail?(0, "無效的 URL，其不可為 nil(2)", nil) ?? ()
                return self
            }

            var request: URLRequest = .init(url: url)
            request.httpMethod = self.method.rawValue
            request.httpBody = self.httpBody()
            
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

            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    return self.fail?(0, "發生錯誤，錯誤原因：\(error.localizedDescription)", nil) ?? ()
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    return self.fail?(0, "回應格式錯誤", nil) ?? ()
                }

                let code = UInt16(truncatingIfNeeded: httpResponse.statusCode)

                guard let data = data else {
                    return self.fail?(code, "資料錯誤", nil) ?? ()
                }

                let text = String(decoding: data, as: UTF8.self)

                guard code >= 200 && code < 300 else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let jsonData = json as? [String: [String]] else {
                            return self.fail?(code, "狀態碼錯誤(2)", text) ?? ()
                        }
                        guard let messages = jsonData["messages"] else {
                            return self.fail?(code, "狀態碼錯誤(3)", jsonData.description) ?? ()
                        }
                        return self.fail?(code, "狀態碼錯誤(4)，錯誤原因：\(messages.joined(separator: ", "))", jsonData.description) ?? ()
                    } catch {
                        return self.fail?(code, "狀態碼錯誤(1)，錯誤原因：\(error.localizedDescription)", text) ?? ()
                    }
                }

                guard self.isJson else {
                    return callback(data, code)
                }

                guard let mime = response?.mimeType, mime == "application/json" else {
                    return self.fail?(code, "格式不是 Json(1)", text) ?? ()
                }

                do {
                    return callback(try JSONSerialization.jsonObject(with: data, options: []), code)
                } catch {
                    return self.fail?(code, "格式不是 Json(2)，錯誤原因：\(error.localizedDescription)", text) ?? ()
                }
            }.resume()
            return self
        }
        
        @discardableResult public func get(callback: @escaping (Any, UInt16) -> ()) -> Self { return self.send(method: .GET, callback: callback) }
        @discardableResult public func post(callback: @escaping (Any, UInt16) -> ()) -> Self { return self.send(method: .POST, callback: callback) }
        @discardableResult public func put(callback: @escaping (Any, UInt16) -> ()) -> Self { return self.send(method: .PUT, callback: callback) }
        @discardableResult public func delete(callback: @escaping (Any, UInt16) -> ()) -> Self { return self.send(method: .DELETE, callback: callback) }
        
        @discardableResult public func get<T: Decodable>(callback: @escaping (T, UInt16) -> ()) -> Self { self.send(method: .GET, isJson: true) { data, code in Self.decodable(request: self, data: data) { callback($0, code) } } }
        @discardableResult public func post<T: Decodable>(callback: @escaping (T, UInt16) -> ()) -> Self { self.send(method: .POST, isJson: true) { data, code in Self.decodable(request: self, data: data) { callback($0, code) } } }
        @discardableResult public func put<T: Decodable>(callback: @escaping (T, UInt16) -> ()) -> Self { self.send(method: .PUT, isJson: true) { data, code in Self.decodable(request: self, data: data) { callback($0, code) } } }
        @discardableResult public func delete<T: Decodable>(callback: @escaping (T, UInt16) -> ()) -> Self { self.send(method: .DELETE, isJson: true) { data, code in Self.decodable(request: self, data: data) { callback($0, code) } } }
        
        @discardableResult public func get(callback: @escaping (Any) -> ()) -> Self { return self.send(method: .GET) { data, _ in callback(data) } }
        @discardableResult public func post(callback: @escaping (Any) -> ()) -> Self { return self.send(method: .POST) { data, _ in callback(data) } }
        @discardableResult public func put(callback: @escaping (Any) -> ()) -> Self { return self.send(method: .PUT) { data, _ in callback(data) } }
        @discardableResult public func delete(callback: @escaping (Any) -> ()) -> Self { return self.send(method: .DELETE) { data, _ in callback(data) } }
        
        @discardableResult public func get<T: Decodable>(callback: @escaping (T) -> ()) -> Self { self.send(method: .GET, isJson: true) { data, _ in Self.decodable(request: self, data: data, callback: callback) } }
        @discardableResult public func post<T: Decodable>(callback: @escaping (T) -> ()) -> Self { self.send(method: .POST, isJson: true) { data, _ in Self.decodable(request: self, data: data, callback: callback) } }
        @discardableResult public func put<T: Decodable>(callback: @escaping (T) -> ()) -> Self { self.send(method: .PUT, isJson: true) { data, _ in Self.decodable(request: self, data: data, callback: callback) } }
        @discardableResult public func delete<T: Decodable>(callback: @escaping (T) -> ()) -> Self { self.send(method: .DELETE, isJson: true) { data, _ in Self.decodable(request: self, data: data, callback: callback) } }
        
        @discardableResult
        private static func send(method: Method, isJson: Bool = true, url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any, Request, UInt16) -> ()) -> Request {
            let request = Request(url: url).params(params)
            if let fail = fail { request.fail(fail: fail) }
            return request.send(method: method, isJson: isJson) { done($0, request, $1) }
        }

        @discardableResult public static func get(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any, UInt16) -> ()) -> Request { Self.send(method: .GET, url: url, params: params, fail: fail) { data, _, code in done(data, code) } }
        @discardableResult public static func post(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any, UInt16) -> ()) -> Request { Self.send(method: .POST, url: url, params: params, fail: fail) { data, _, code in done(data, code) } }
        @discardableResult public static func put(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any, UInt16) -> ()) -> Request { Self.send(method: .PUT, url: url, params: params, fail: fail) { data, _, code in done(data, code) } }
        @discardableResult public static func delete(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any, UInt16) -> ()) -> Request { Self.send(method: .DELETE, url: url, params: params, fail: fail) { data, _, code in done(data, code) } }
        
        @discardableResult public static func get<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T, UInt16) -> ()) -> Request { Self.send(method: .GET, isJson: true, url: url, params: params, fail: fail) { data, requset, code in Self.decodable(request: requset, data: data) { done($0, code) } } }
        @discardableResult public static func post<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T, UInt16) -> ()) -> Request { Self.send(method: .POST, isJson: true, url: url, params: params, fail: fail) { data, requset, code in Self.decodable(request: requset, data: data) { done($0, code) } } }
        @discardableResult public static func put<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T, UInt16) -> ()) -> Request { Self.send(method: .PUT, isJson: true, url: url, params: params, fail: fail) { data, requset, code in Self.decodable(request: requset, data: data) { done($0, code) } } }
        @discardableResult public static func delete<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T, UInt16) -> ()) -> Request { Self.send(method: .DELETE, isJson: true, url: url, params: params, fail: fail) { data, requset, code in Self.decodable(request: requset, data: data) { done($0, code) } } }
        
        @discardableResult public static func get(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any) -> ()) -> Request { Self.send(method: .GET, url: url, params: params, fail: fail) { data, _, _ in done(data) } }
        @discardableResult public static func post(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any) -> ()) -> Request { Self.send(method: .POST, url: url, params: params, fail: fail) { data, _, _ in done(data) } }
        @discardableResult public static func put(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any) -> ()) -> Request { Self.send(method: .PUT, url: url, params: params, fail: fail) { data, _, _ in done(data) } }
        @discardableResult public static func delete(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (Any) -> ()) -> Request { Self.send(method: .DELETE, url: url, params: params, fail: fail) { data, _, _ in done(data) } }
        
        @discardableResult public static func get<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T) -> ()) -> Request { Self.send(method: .GET, isJson: true, url: url, params: params, fail: fail) { data, requset, _ in Self.decodable(request: requset, data: data) { done($0) } } }
        @discardableResult public static func post<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T) -> ()) -> Request { Self.send(method: .POST, isJson: true, url: url, params: params, fail: fail) { data, requset, _ in Self.decodable(request: requset, data: data) { done($0) } } }
        @discardableResult public static func put<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T) -> ()) -> Request { Self.send(method: .PUT, isJson: true, url: url, params: params, fail: fail) { data, requset, _ in Self.decodable(request: requset, data: data) { done($0) } } }
        @discardableResult public static func delete<T: Decodable>(url: URL?, params: [Param] = [], fail: ((UInt16, String, String?) -> ())? = nil, done: @escaping (T) -> ()) -> Request { Self.send(method: .DELETE, isJson: true, url: url, params: params, fail: fail) { data, requset, _ in Self.decodable(request: requset, data: data) { done($0) } } }
    }

    class Layout {
        private let parent: UIView
        private let child: UIView
        private let view: UIView
        private var goal: Any? = nil
        
        private var multiplier: CGFloat = 1
        private var constant: CGFloat = 0
        
        private var childAttr: NSLayoutConstraint.Attribute? = nil
        private var goalAttr: NSLayoutConstraint.Attribute = .notAnAttribute
        private var relation: NSLayoutConstraint.Relation = .equal
        
        public init(parent: UIView, child: UIView, for view: UIView? = nil) {
            self.parent = parent
            self.child = child
            self.goal = parent
            self.view = view ?? parent
        }
        
        public func multiplier(_ multiplier: CGFloat = 1) -> Self {
            self.multiplier = multiplier
            return self
        }

        public func constant(_ constant: CGFloat) -> Self {
            self.constant = constant
            return self
        }

        @discardableResult
        private func join() -> Self {
            guard !self.parent.subviews.contains(self.child) else { return self }
            self.child.translatesAutoresizingMaskIntoConstraints = false
            self.parent.addSubview(self.child)
            return self
        }

        private func create(isActive: Bool) -> NSLayoutConstraint? {
            guard let childAttr = self.childAttr else { return nil }
            self.join()
            let constraint = NSLayoutConstraint(item: self.child, attribute: childAttr, relatedBy: self.relation, toItem: self.goal, attribute: self.goalAttr, multiplier: self.multiplier, constant: self.constant)

            self.view.addConstraint(constraint)
            
            constraint.isActive = isActive
            return constraint
        }

        private func tmlrxy(_ attr: NSLayoutConstraint.Attribute, constant: CGFloat? = nil) -> Self {
            if let constant = constant {
                _ = self.constant(constant)
            }
            if self.childAttr == nil {
                self.childAttr = attr
            }
            self.goalAttr = attr

            return self
        }

        private func wh(_ attr: NSLayoutConstraint.Attribute, constant: CGFloat? = nil) -> Self {
            if let constant = constant {
                _ = self.constant(constant)
            }

            if self.childAttr == nil {
                self.childAttr = attr
                self.goal = nil
                self.goalAttr = .notAnAttribute
            } else {
                self.goalAttr = attr
                if self.goal == nil {
                    self.goal = self.parent
                }
            }
            return self
        }
        
        private func relation(_ relation: NSLayoutConstraint.Relation, goal: Any? = nil) -> Self {
            self.relation = relation
            guard let goal = goal else { return self }
            self.goal = goal
            return self
        }

        public func top(_ constant: CGFloat? = nil) -> Self { self.tmlrxy(.top, constant: constant) }
        public func left(_ constant: CGFloat? = nil) -> Self { self.tmlrxy(.left, constant: constant) }
        public func right(_ constant: CGFloat? = nil) -> Self { self.tmlrxy(.right, constant: constant) }
        public func bottom(_ constant: CGFloat? = nil) -> Self { self.tmlrxy(.bottom, constant: constant) }
        public func centerX(_ constant: CGFloat? = nil) -> Self { self.tmlrxy(.centerX, constant: constant) }
        public func centerY(_ constant: CGFloat? = nil) -> Self { self.tmlrxy(.centerY, constant: constant) }
        
        public func width(_ constant: CGFloat? = nil) -> Self { self.wh(.width, constant: constant) }
        public func height(_ constant: CGFloat? = nil) -> Self { self.wh(.height, constant: constant) }
        
        public func equal(_ goal: Any? = nil) -> Self { self.relation(.equal, goal: goal) }
        public func greaterThanOrEqual(_ goal: Any? = nil) -> Self { self.relation(.greaterThanOrEqual, goal: goal) }
        public func lessThanOrEqual(_ goal: Any? = nil) -> Self { self.relation(.lessThanOrEqual, goal: goal) }
        
        @discardableResult public func enable() -> NSLayoutConstraint? { self.create(isActive: true) }
        @discardableResult public func disable() -> NSLayoutConstraint? { self.create(isActive: false) }
        @discardableResult public func enable(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
            constraint = self.enable()
            return constraint
        }
        @discardableResult public func disable(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
            constraint = self.disable()
            return constraint
        }

        public func t(_ constant: CGFloat? = nil) -> Self { self.top(constant) }
        public func l(_ constant: CGFloat? = nil) -> Self { self.left(constant) }
        public func r(_ constant: CGFloat? = nil) -> Self { self.right(constant) }
        public func b(_ constant: CGFloat? = nil) -> Self { self.bottom(constant) }
        public func x(_ constant: CGFloat? = nil) -> Self { self.centerX(constant) }
        public func y(_ constant: CGFloat? = nil) -> Self { self.centerY(constant) }
        
        public func w(_ constant: CGFloat? = nil) -> Self { self.width(constant) }
        public func h(_ constant: CGFloat? = nil) -> Self { self.height(constant) }
        
        public func q(_ goal: Any? = nil) -> Self { self.equal(goal) }
        public func qG(_ goal: Any? = nil) -> Self { self.greaterThanOrEqual(goal) }
        public func qL(_ goal: Any? = nil) -> Self { self.lessThanOrEqual(goal) }
        
        @discardableResult public func e() -> NSLayoutConstraint? { self.enable() }
        @discardableResult public func d() -> NSLayoutConstraint? { self.disable() }
        @discardableResult public func e(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? { self.enable(constraint: &constraint) }
        @discardableResult public func d(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? { self.disable(constraint: &constraint) }
    }

    class Storage {
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

    class Timer {
        private static var all: [String: Foundation.Timer] = [:]

        @discardableResult public static func has(key: String) -> Bool { self.all[key] != nil }

        @discardableResult public static func clean(key: String) -> Bool {
            if let tmp = self.all[key] { tmp.invalidate() }
            self.all.removeValue(forKey: key)
            return self.all[key] == nil
        }

        @discardableResult public static func cleanAll() -> Bool {
            self.all.forEach { key, _ in self.clean(key: key) }
            return true
        }

        public static func delay(key: String, second: TimeInterval, replace: Bool = true, repeats: Bool = false, block: @escaping () -> ()) {
            if let timer = Self.all[key] {
                guard replace else { return }
                timer.invalidate()
                guard Self.clean(key: key) else { return }
            }

            Self.all[key] = Foundation.Timer.scheduledTimer(withTimeInterval: second, repeats: repeats) { _ in
                if !repeats { Self.clean(key: key) }
                block()
            }
        }

        public static func loop(key: String, second: TimeInterval, replace: Bool = true, block: @escaping () -> ()) {
            if let timer = Self.all[key] {
                guard replace else { return }
                timer.invalidate()
                guard Self.clean(key: key) else { return }
            }

            block()
            Self.all[key] = Foundation.Timer.scheduledTimer(withTimeInterval: second, repeats: true) { _ in block() }
        }
    }
}
