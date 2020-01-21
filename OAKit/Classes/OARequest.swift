//
//  OARequest.swift
//  OAKit
//
//  Created by 吳政賢 on 2020/1/21.
//

import Foundation
import UIKit

public enum OARequestStatus<T> {
    case success(T)
    case failure(UInt16, String)
}

public enum OARequestMethod: String {
    case GET, POST, DELETE, PUT
}

public class OASessionDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    private var progress: ((Float) -> Void)
    
    public init(progress: @escaping((Float) -> Void)) {
        self.progress = progress
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        self.progress(Float(totalBytesSent) / Float(totalBytesExpectedToSend))
    }
}

public enum OARequestData {
    case header(String, String)
    case param(String, String)
    case data(String, String)
    case file(String, Data, String, String)
    
    public var fileKeyData: (String, Data, String, String)? {
        switch self {
        case .file(let key, let data, let fileName, let mimeType): return (key, data, fileName, mimeType)
        default: return nil
        }
    }

    public var dataKeyVal: (String, String)? {
        switch self {
        case .data(let key, let val): return (key, val)
        default: return nil
        }
    }

    public var headerKeyVal: (String, String)? {
        switch self {
        case .header(let key, let val): return (key, val)
        default: return nil
        }
    }

    public var urlQueryItem: URLQueryItem? {
        switch self {
        case .param(let key, let val): return URLQueryItem(name: key, value: val)
        default: return nil
        }
    }
}

public class OARequest {
    private var datass: [OARequestData] = []
    private var progress: ((Float) -> Void)? = nil
    private var urlComponents: URLComponents?
    private var method: OARequestMethod = .GET
    private var model: Decodable.Type? = nil
    
    public init () {
        
    }
    
    public init(url: String) {
        self.url(url)
    }
    
    @discardableResult
    public func header(key: String, value: String) -> Self {
        guard !key.isEmpty else { return self }
        self.datass.append(.header(key, value))
        return self
    }
    
    public func param(key: String, value: String) -> Self {
        guard !key.isEmpty else { return self }
        self.datass.append(.param(key, value))
        return self
    }
    
    public func data(key: String, value: String) -> Self {
        guard !key.isEmpty else { return self }
        self.datass.append(.data(key, value))
        return self
    }

    public func file(key: String, data: Data, mimeType: String) -> Self {
        guard !key.isEmpty else { return self }
        self.datass.append(.file(key, data, "\(arc4random())", mimeType))
        return self
    }
    
    public func file(key: String, data: Data, fileName: String, mimeType: String) -> Self {
        guard !key.isEmpty else { return self }
        self.datass.append(.file(key, data, fileName, mimeType))
        return self
    }
    
    public func progress(_ progress: @escaping((Float) -> Void)) -> Self {
        self.progress = progress
        return self
    }
    
    public func get(closure: @escaping((OARequestStatus<Any>) -> Void)) -> Void {
        return self.method(.GET).json(closure: closure)
    }

    public func get(url: String, closure: @escaping((OARequestStatus<Any>) -> Void)) -> Void {
        return self.url(url).get(closure: closure)
    }
    
    public func get<T: Decodable>(model: T.Type, closure: @escaping((OARequestStatus<T>) -> Void)) -> Void {
        return self.method(.GET).json(model: T.self, closure: closure)
    }

    public func get<T: Decodable>(url: String, model: T.Type, closure: @escaping((OARequestStatus<T>) -> Void)) -> Void {
        return self.url(url).get(model: T.self, closure: closure)
    }
    
    public func post(closure: @escaping((OARequestStatus<Any>) -> Void)) -> Void {
        return self.method(.POST).json(closure: closure)
    }
    
    public func post(url: String, closure: @escaping((OARequestStatus<Any>) -> Void)) -> Void {
        return self.url(url).post(closure: closure)
    }
    
    public func post<T: Decodable>(model: T.Type, closure: @escaping((OARequestStatus<T>) -> Void)) -> Void {
        return self.method(.POST).json(model: T.self, closure: closure)
    }
    
    public func post<T: Decodable>(url: String, model: T.Type, closure: @escaping((OARequestStatus<T>) -> Void)) -> Void {
        return self.url(url).post(model: T.self, closure: closure)
    }
    
    public func json(closure: @escaping((OARequestStatus<Any>) -> Void)) -> Void {
        self.send(success: { data in
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return closure(.failure(0, "格式錯誤"))
            }
            return closure(.success(json))
        }, failure: { closure(.failure($0, $1)) })
    }
    
    public func json<T: Decodable>(model: T.Type, closure: @escaping((OARequestStatus<T>) -> Void)) -> Void {
        self.send(success: { data in
            guard let json = try? JSONDecoder().decode(T.self, from: data) else {
                return closure(.failure(0, "Json 格式有誤"))
            }
            return closure(.success(json))
        }, failure: { closure(.failure($0, $1)) })
    }
    
    private func method(_ method: OARequestMethod) -> Self {
        self.method = method
        return self
    }
    
    @discardableResult
    private func url(_ url: String) -> Self {
        guard let urlComponents = URLComponents(string: url) else {
            self.urlComponents = nil
            return self
        }
        self.urlComponents = urlComponents
        return self
    }
    
    private func createBoundary(count: Int = 32) -> String {
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
    
    private func genFormData() -> Data {
        let files = self.datass.compactMap { $0.fileKeyData }
        let datas = self.datass.compactMap { $0.dataKeyVal }
        
        guard !files.isEmpty else {
            return datas.isEmpty ? Data() : datas.map { $0 + "=" + $1 }.joined(separator: "&").data(using: .utf8) ?? Data()
        }

        let boundary = "--" + self.createBoundary()
        
        self.header(key: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")

        var body = Data()

        for (key, val) in datas {
            if let form = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(val)\r\n".data(using: .utf8, allowLossyConversion: true) {
                body.append(form)
            }
        }
        
        for (key, data, fileName, mimeType) in files {
            if let start = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\nContent-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true),
                let end = "\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
                body.append(start)
                body.append(data)
                body.append(end)
            }
        }

        if let end = "--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
            body.append(end)
        }

        return body
    }
    
    private func send(success: @escaping((Data) -> Void), failure: @escaping((UInt16, String) -> Void)) -> Void {
        let params: [URLQueryItem] = self.datass.compactMap { $0.urlQueryItem }

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
        
        let headers = self.datass.compactMap { $0.headerKeyVal }

        for (key, val) in headers {
            request.setValue(val, forHTTPHeaderField: key)
        }

        let session: URLSession = self.progress == nil ? URLSession.shared : URLSession(configuration: URLSessionConfiguration.default, delegate: OASessionDelegate(progress: self.progress!), delegateQueue:  OperationQueue.main)

        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return failure(0, error!.localizedDescription)
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

    public static func header(key: String, value: String) -> OARequest {
        return OARequest().header(key: key, value: value)
    }

    public static func param(key: String, value: String) -> OARequest {
        return OARequest().param(key: key, value: value)
    }

    public static func data(key: String, value: String) -> OARequest {
        return OARequest().data(key: key, value: value)
    }

    public static func file(key: String, data: Data, mimeType: String) -> OARequest {
        return OARequest().file(key: key, data: data, mimeType: mimeType)
    }

    public static func file(key: String, data: Data, fileName: String, mimeType: String) -> OARequest {
        return OARequest().file(key: key, data: data, fileName: fileName, mimeType: mimeType)
    }

    public static func progress(_ progress: @escaping((Float) -> Void)) -> OARequest {
        return OARequest().progress(progress)
    }

    public static func get(url: String, closure: @escaping((OARequestStatus<Any>) -> Void)) -> Void {
        return OARequest().get(url: url, closure: closure)
    }

    public static func get<T: Decodable>(url: String, model: T.Type, closure: @escaping((OARequestStatus<T>) -> Void)) -> Void {
        return OARequest().get(url: url, model: T.self, closure: closure)
    }

    public static func post(url: String, closure: @escaping((OARequestStatus<Any>) -> Void)) -> Void {
        return OARequest().post(url: url, closure: closure)
    }

    public static func post<T: Decodable>(url: String, model: T.Type, closure: @escaping((OARequestStatus<T>) -> Void)) -> Void {
        return OARequest().post(url: url, model: T.self, closure: closure)
    }
}

