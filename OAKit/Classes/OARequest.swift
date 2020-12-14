//
//  OARequest.swift
//  OAKit
//
//  Created by 吳政賢 on 2020/1/21.
//

import Foundation

public class OARequest {

    public class Delegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
        private var progress: ((Float) -> Void)

        public init(progress: @escaping((Float) -> Void)) {
            self.progress = progress
        }

        public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            self.progress(Float(totalBytesSent) / Float(totalBytesExpectedToSend))
        }
    }
    
    public enum Status<T> {
        case success(T)
        case failure(UInt16, String)
    }

    public enum Method: String {
        case GET, POST, DELETE, PUT
    }

    public enum DataType {
        case header(String, String)
        case query(String, String)
        case form(String, String)
        case file(String, Data, String, String)
        case raw(String, Bool)

        public var fileData: (key: String, data: Data, filename: String, mime: String)? {
            switch self {
            case .file(let key, let data, let filename, let mime): return (key: key, data: data, filename: filename, mime: mime)
            default: return nil
            }
        }

        public var formData: (key: String, val: String)? {
            switch self {
            case .form(let key, let val): return (key: key, val: val)
            default: return nil
            }
        }

        public var headerData: (key: String, val: String)? {
            switch self {
            case .header(let key, let val): return (key: key, val: val)
            default: return nil
            }
        }

        public var queryData: (key: String, val: String)? {
            switch self {
            case .query(let key, let val): return (key: key, val: val)
            default: return nil
            }
        }

        public var rawData: (val: String, isJson: Bool)? {
            switch self {
            case .raw(let val, let isJson): return (val: val, isJson: isJson)
            default: return nil
            }
        }
    }

    private var datass: [DataType] = []
    private var progress: ((Float) -> Void)? = nil
    private var urlComponents: URLComponents?
    private var method: Method = .GET
    private var model: Decodable.Type? = nil
    private var cache: Bool = false

    public init() {}

    public init(url: String) {
        self.url(url)
    }

    public init(url: URL) {
        self.url(url)
    }

    public init(cache: Bool) {
        self.cache(cache)
    }

    public init(url: String, cache: Bool) {
        self.url(url).cache(cache)
    }

    public init(url: URL, cache: Bool) {
        self.url(url).cache(cache)
    }

    @discardableResult
    public func header(key: String, value: String?) -> Self {
        guard !key.isEmpty else { return self }
        guard let value = value else { return self }
        self.datass.append(.header(key, value))
        return self
    }

    @discardableResult
    public func cache(_ cache: Bool) -> Self {
        self.cache = cache
        return self
    }

    @discardableResult
    public func query(key: String, value: String?) -> Self {
        guard !key.isEmpty else { return self }
        guard let value = value else { return self }
        self.datass.append(.query(key, value))
        return self
    }

    @discardableResult
    public func form(key: String, value: String?) -> Self {
        guard !key.isEmpty else { return self }
        guard let value = value else { return self }
        self.datass.append(.form(key, value))
        return self
    }
    
    @discardableResult
    public func raw(text: String) -> Self {
        self.datass.append(.raw(text, false))
        return self
    }

    @discardableResult
    public func raw<T: Codable>(object: T) -> Self {
        guard let json = try? JSONEncoder().encode(object), let jsonStr = String(data: json, encoding: .utf8) else {
            return self
        }
        self.datass.append(.raw(jsonStr, true))
        return self
    }
    
    @discardableResult
    public func raw<T: Codable>(objects: [T]) -> Self {
        let strs = objects.compactMap { try? JSONEncoder().encode($0) }.compactMap { String(data: $0, encoding: .utf8) }.joined(separator: ",")
        self.datass.append(.raw("[\(strs)]", true))
        return self
    }
    
    @discardableResult
    public func form(text: String) -> Self {
        return self.raw(text: text)
    }
    
    @discardableResult
    public func form<T: Codable>(object: T) -> Self {
        return self.raw(object: object)
    }
    
    @discardableResult
    public func form<T: Codable>(objects: [T]) -> Self {
        return self.raw(objects: objects)
    }

    @discardableResult
    public func file(key: String, data: Data?, mimeType: String) -> Self {
        guard !key.isEmpty else { return self }
        guard let data = data else { return self }
        self.datass.append(.file(key, data, "\(randomString(count: 10))", mimeType))
        return self
    }

    @discardableResult
    public func file(key: String, data: Data?, fileName: String, mimeType: String) -> Self {
        guard !key.isEmpty else { return self }
        guard let data = data else { return self }
        self.datass.append(.file(key, data, fileName, mimeType))
        return self
    }

    @discardableResult
    public func progress(_ progress: @escaping((Float) -> Void)) -> Self {
        self.progress = progress
        return self
    }

    public func get(closure: @escaping((Status<Any>) -> Void)) -> Void {
        return self.method(.GET).json(closure: closure)
    }

    public func get(url: String, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return self.url(url).get(closure: closure)
    }

    public func get(url: URL, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return self.url(url).get(closure: closure)
    }

    public func get<T: Decodable>(model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return self.method(.GET).json(model: T.self, closure: closure)
    }

    public func get<T: Decodable>(url: String, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return self.url(url).get(model: T.self, closure: closure)
    }

    public func get<T: Decodable>(url: URL, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return self.url(url).get(model: T.self, closure: closure)
    }

    public func post(closure: @escaping((Status<Any>) -> Void)) -> Void {
        return self.method(.POST).json(closure: closure)
    }

    public func post(url: String, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return self.url(url).post(closure: closure)
    }

    public func post(url: URL, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return self.url(url).post(closure: closure)
    }

    public func post<T: Decodable>(model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return self.method(.POST).json(model: T.self, closure: closure)
    }

    public func post<T: Decodable>(url: String, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return self.url(url).post(model: T.self, closure: closure)
    }

    public func post<T: Decodable>(url: URL, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return self.url(url).post(model: T.self, closure: closure)
    }

    public func json(closure: @escaping((Status<Any>) -> Void)) -> Void {
        self.send(success: { data in
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return closure(.failure(0, "格式錯誤"))
            }
            return closure(.success(json))
        }, failure: { closure(.failure($0, $1)) })
    }

    public func json<T: Decodable>(model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        self.send(success: { data in
            guard let json = try? JSONDecoder().decode(T.self, from: data) else {
                return closure(.failure(0, "Json 格式有誤"))
            }
            return closure(.success(json))
        }, failure: { closure(.failure($0, $1)) })
    }

    private func method(_ method: Method) -> Self {
        self.method = method
        return self
    }

    @discardableResult
    private func url(_ url: String) -> Self {
        if let url = URL(string: url) {
            return self.url(url)
        } else {
            return self
        }
    }

    @discardableResult
    private func url(_ url: URL) -> Self {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            self.urlComponents = nil
            return self
        }
        self.urlComponents = urlComponents
        return self
    }

    private func genFormData() -> Data {
        let files = self.datass.compactMap { $0.fileData }
        let datas = self.datass.compactMap { $0.formData }

        if files.isEmpty {
            if datas.isEmpty {
                if let raw = self.datass.compactMap({ $0.rawData }).last {
                    self.header(key: "Content-Type", value: raw.isJson ? "application/json" : "text/plain")
                    return raw.val.data(using: .utf8) ?? Data()
                }
                self.header(key: "Content-Type", value: "application/x-www-form-urlencoded")
                return Data()
            }

            self.header(key: "Content-Type", value: "application/x-www-form-urlencoded")
            return datas.map { $0.key + "=" + $0.val }.joined(separator: "&").data(using: .utf8) ?? Data()
        }

        let boundary = "--" + randomString()

        self.header(key: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")

        var body = Data()

        for data in datas {
            if let form = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(data.key)\"\r\n\r\n\(data.val)\r\n".data(using: .utf8, allowLossyConversion: true) {
                body.append(form)
            }
        }

        for file in files {
            if let start = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.filename)\"\r\nContent-Type: \(file.mime)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true),
                let end = "\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
                body.append(start)
                body.append(file.data)
                body.append(end)
            }
        }

        if let end = "--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
            body.append(end)
        }

        return body
    }

    private func send(success: @escaping((Data) -> Void), failure: @escaping((UInt16, String) -> Void)) -> Void {
        let params = self.datass.compactMap { $0.queryData }.map { URLQueryItem(name: $0.key, value: $0.val) }

        if !params.isEmpty {
            self.urlComponents?.queryItems = params
        }

        guard let url = self.urlComponents?.url else {
            return failure(0, "網址錯誤")
        }

        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        if self.method == .POST {
            request.httpBody = self.genFormData()
        }

        for header in self.datass.compactMap({ $0.headerData }) {
            request.setValue(header.val, forHTTPHeaderField: header.key)
        }

        let config = URLSessionConfiguration.default

        if !self.cache {
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.urlCache = nil
        }

        var session: URLSession = URLSession(configuration: config)
        if let progress = self.progress {
            session = URLSession(configuration: config, delegate: Delegate(progress: progress), delegateQueue:  OperationQueue.main)
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                return error.localizedDescription == "The Internet connection appears to be offline."
                    ? failure(0, "網路連線失敗")
                    : failure(0, error.localizedDescription)
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return failure(0, "回應錯誤")
            }

            let code = UInt16(truncatingIfNeeded: httpResponse.statusCode)

            guard httpResponse.statusCode == 200 else {

                guard let data = data else {
                    return failure(code, "狀態碼錯誤")
                }

                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    return failure(code, "狀態碼錯誤，訊息：" + String(decoding: data, as: UTF8.self))
                }

                guard let jsonData = json as? [String: [String]], let messages = jsonData["messages"] else {
                    return failure(code, "狀態碼錯誤，訊息：" + String(decoding: data, as: UTF8.self))
                }

                return failure(code, "狀態碼錯誤，訊息：" + messages.joined(separator: ""))
            }

            guard let mime = response?.mimeType, mime == "application/json" else {
                return failure(code, "格式不是 Json")
            }

            guard let data = data else {
                return failure(code, "資料錯誤")
            }

            return success(data)
        }.resume()
    }

    public static func header(key: String, value: String?) -> OARequest {
        return OARequest().header(key: key, value: value)
    }

    public static func query(key: String, value: String?) -> OARequest {
        return OARequest().query(key: key, value: value)
    }

    public static func form(key: String, value: String?) -> OARequest {
        return OARequest().form(key: key, value: value)
    }
    
    public static func raw(text: String) -> OARequest {
        return OARequest().raw(text: text)
    }

    public static func raw<T: Codable>(object: T) -> OARequest {
        return OARequest().raw(object: object)
    }
    
    public static func raw<T: Codable>(objects: [T]) -> OARequest {
        return OARequest().raw(objects: objects)
    }
    
    public static func form(text: String) -> OARequest {
        return Self.raw(text: text)
    }
    
    public static func form<T: Codable>(object: T) -> OARequest {
        return Self.raw(object: object)
    }
    
    public static func form<T: Codable>(objects: [T]) -> OARequest {
        return Self.raw(objects: objects)
    }

    public static func file(key: String, data: Data?, mimeType: String) -> OARequest {
        return OARequest().file(key: key, data: data, mimeType: mimeType)
    }

    public static func file(key: String, data: Data?, fileName: String, mimeType: String) -> OARequest {
        return OARequest().file(key: key, data: data, fileName: fileName, mimeType: mimeType)
    }

    public static func progress(_ progress: @escaping((Float) -> Void)) -> OARequest {
        return OARequest().progress(progress)
    }

    public static func get(url: String, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return OARequest().get(url: url, closure: closure)
    }

    public static func get(url: URL, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return OARequest().get(url: url, closure: closure)
    }

    public static func get<T: Decodable>(url: String, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return OARequest().get(url: url, model: T.self, closure: closure)
    }

    public static func get<T: Decodable>(url: URL, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return OARequest().get(url: url, model: T.self, closure: closure)
    }

    public static func post(url: String, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return OARequest().post(url: url, closure: closure)
    }

    public static func post(url: URL, closure: @escaping((Status<Any>) -> Void)) -> Void {
        return OARequest().post(url: url, closure: closure)
    }

    public static func post<T: Decodable>(url: String, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return OARequest().post(url: url, model: T.self, closure: closure)
    }

    public static func post<T: Decodable>(url: URL, model: T.Type, closure: @escaping((Status<T>) -> Void)) -> Void {
        return OARequest().post(url: url, model: T.self, closure: closure)
    }
}
