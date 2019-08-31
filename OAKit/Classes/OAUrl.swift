//
//  OAUrl.swift
//  OAKit
//
//  Created by 吳政賢 on 2019/8/30.
//

import Foundation

public enum UrlStatus {
    case success(Any)
    case failure(UInt16, String)
}

public class UrlGet {
    public func json(url urlString: String, closure: @escaping((UrlStatus) -> Void)) {
        guard let url = URL(string: urlString) else { return closure(.failure(0, "網址轉換錯誤")) }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return closure(.failure(0, error!.localizedDescription)) }
            guard let httpResponse = response as? HTTPURLResponse else { return closure(.failure(0, "回應錯誤！")) }
            guard httpResponse.statusCode == 200 else {
                guard let data！ = data else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！")) }
                guard let json = try? JSONSerialization.jsonObject(with: data！, options: []) else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！訊息：" + String(decoding: data！, as: UTF8.self))) }
                guard let jsonData = json as? [String: [String]], let messages = jsonData["messages"] else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！訊息：" + String(decoding: data！, as: UTF8.self))) }
                return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！訊息：" + messages.joined(separator: "")))
            }
            guard let mime = response?.mimeType, mime == "application/json" else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "格式不是 Json！")) }
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "格式錯誤！")) }
            return closure(.success(json))
            }.resume()
    }
}

public class UrlPost {
    public func json(url urlString: String, data: String?, closure: @escaping((UrlStatus) -> Void)) {
        guard let url = URL(string: urlString) else { return closure(.failure(0, "網址轉換錯誤")) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let httpBody = data {
            request.httpBody = httpBody.data(using: .utf8)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return closure(.failure(0, error!.localizedDescription)) }
            guard let httpResponse = response as? HTTPURLResponse else { return closure(.failure(0, "回應錯誤！")) }
            guard httpResponse.statusCode == 200 else {
                guard let data！ = data else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！")) }
                guard let json = try? JSONSerialization.jsonObject(with: data！, options: []) else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！訊息：" + String(decoding: data！, as: UTF8.self))) }
                guard let jsonData = json as? [String: [String]], let messages = jsonData["messages"] else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！訊息：" + String(decoding: data！, as: UTF8.self))) }
                return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "狀態碼錯誤！訊息：" + messages.joined(separator: "")))
            }
            guard let mime = response?.mimeType, mime == "application/json" else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "格式不是 Json！")) }
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) else { return closure(.failure(UInt16(truncatingIfNeeded: httpResponse.statusCode), "格式錯誤！")) }
            return closure(.success(json))
            }.resume()
    }
}

public class Url {
    public static let get: UrlGet = UrlGet()
    
    public static func post(url urlString: String, with data: String?, closure: @escaping((UrlStatus) -> Void)) {
        return UrlPost().json(url: urlString, data: data, closure: closure)
    }
}
