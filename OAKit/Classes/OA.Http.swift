//
//  OA.Http.swift
//  OAKit
//
//  Created by 吳政賢 on 2023/4/14.
//

import Foundation

internal protocol OA_Http_Delegate {
    @discardableResult func header(key: String, val: String?) -> Self
    var params: [OA.Http.Param] { get }
}

internal extension OA.Http {
    static let _allowedCharacterSet: CharacterSet = {
        var tmp: CharacterSet = .urlQueryAllowed
        tmp.remove(charactersIn: ";/?:@&=+$, ")
        return tmp
    }()
    
    enum Param {
        case query(KeyVal)
        case header(KeyVal)
        case form(KeyVal)
        case file(File)
        case rawText(Raw)
        case rawJson(Raw)
        case rawJsons(Raw)

        public var header: KeyVal? {
            if case .header(let kv) = self {
                return kv
            }
            return nil
        }
        public var query: KeyVal? {
            if case .query(let kv) = self {
                return kv
            }
            return nil
        }
        public var form: KeyVal? {
            if case .form(let kv) = self {
                return kv
            }
            return nil
        }
        public var file: File? {
            if case .file(let file) = self {
                return file
            }
            return nil
        }
        public var raw: Raw? {
            if case .rawText(let raw) = self {
                return raw
            }
            if case .rawJson(let raw) = self {
                return raw
            }
            if case .rawJsons(let raw) = self {
                return raw
            }
            return nil
        }
    }
    
    static func httpBody(delegate: OA_Http_Delegate) -> Data {
        let files = delegate.params.compactMap { $0.file }
        let forms = delegate.params.compactMap { $0.form }

        var body: Data = .init()

        if files.isEmpty {
            
            guard forms.isEmpty else {
                delegate.header(key: "Content-Type", val: "application/x-www-form-urlencoded")

                return forms.compactMap({ form in
                    guard let val = form.val.addingPercentEncoding(withAllowedCharacters: OA.Http._allowedCharacterSet) else { return nil }
                    return "\(form.key)=\(val)"
                }).joined(separator: "&").data(using: .utf8) ?? body
            }

            guard let raw = delegate.params.compactMap({ $0.raw }).last else {
                return body
            }

            delegate.header(key: raw.header.key, val: raw.header.val)
            return raw.content.data(using: .utf8) ?? body
        }

        let boundary = "--\(OA.Func.randomString())"

        delegate.header(key: "Content-Type", val: "multipart/form-data; boundary=\(boundary)")

        for form in forms.compactMap({ "--\(boundary)\r\nContent-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n\($0.val)\r\n".data(using: .utf8, allowLossyConversion: true) }) {
            body.append(form)
        }

        for file in files {
            if let header = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\r\nContent-Type: \(file.mime)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true), let footer = "\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
                body.append(header)
                body.append(file.data)
                body.append(footer)
            }
        }

        if let end = "--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true) {
            body.append(end)
        }

        return body
    }
    static func not200(code: UInt16, data: Data) -> Fail {
        let messages: [String]
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])

            if let jsonData = json as? [String: [String]] {
                if let msgs = jsonData["messages"] {
                    messages = msgs
                } else {
                    messages = [.init(decoding: data, as: UTF8.self), "轉換 Json 失敗，沒有 messages"]
                }
            } else if let jsonData = json as? [String: String] {
                if let msg = jsonData["message"] {
                    messages = [msg]
                } else {
                    messages = [.init(decoding: data, as: UTF8.self), "轉換 Json 失敗，沒有 message"]
                }
            } else {
                messages = [.init(decoding: data, as: UTF8.self), "轉換 Json 失敗，結構錯誤"]
            }
        } catch {
            messages = [.init(decoding: data, as: UTF8.self), "回應不是 Json 格式", error.localizedDescription]
        }
        return .init(code: code, messages: messages)
    }
}



internal extension OA.Http.Param {
    struct KeyVal {
        public let key: String
        public let val: String
    }
    struct File {
        public let key: String
        public let mime: String
        public let data: Data
        public let name: String
    }
    struct Raw {
        public let header: KeyVal
        public let content: String
    }
}

public extension OA.Http {
    enum Method: String {
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case delete = "DELETE"
    }

    struct Fail {
        public let code: UInt16
        public let messages: [String]
    }
}
