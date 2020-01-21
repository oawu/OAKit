//
//  URLViewController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

struct Model: Decodable {
    public let title: String
}

struct Request {
    public let title: String
}

class RequestCell: UITableViewCell {
    @discardableResult
    public func fetchUI(data: Request) -> Self {
        self.textLabel?.text = data.title
        self.accessoryType = .disclosureIndicator
        return self
    }
}

class RequestViewController: UITableViewController {
    private let url = ""
    
    private func getSample_00() {
        OARequest(url: self.url).get { result in
            switch result {
            case .success(let json):
                print(json)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_01() {
        OARequest.get(url: self.url) { result in
            switch result {
            case .success(let json):
                print(json)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_02() {
        OARequest(url: self.url).get(model: Model.self) { result in
            switch result {
            case .success(let model):
                print(model.title)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_03() {
        OARequest.get(url: self.url, model: Model.self) { result in
            switch result {
            case .success(let model):
                print(model.title)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_04() {
        OARequest(url: self.url).header(key: "Hello", value: "123").get { print($0) }
    }
    private func getSample_05() {
        OARequest(url: self.url).param(key: "Hello", value: "123").get { print($0) }
    }
    private func getSample_06() {
        OARequest(url: self.url).progress{ print($0) }.post { print($0) }
    }
    private func getSample_10() {
        OARequest(url: self.url).post { result in
            switch result {
            case .success(let json):
                print(json)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_11() {
        OARequest.post(url: self.url) { result in
            switch result {
            case .success(let json):
                print(json)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_12() {
        OARequest(url: self.url).post(model: Model.self) { result in
            switch result {
            case .success(let model):
                print(model.title)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_13() {
        OARequest.post(url: self.url, model: Model.self) { result in
            switch result {
            case .success(let model):
                print(model.title)
                break
            case .failure(let code, let msg):
                print(code, msg)
                break
            }
        }
    }
    private func getSample_14() {
        OARequest(url: self.url).header(key: "Hello", value: "123").post { print($0) }
    }
    private func getSample_15() {
        OARequest(url: self.url).param(key: "Hello", value: "123").post { print($0) }
    }
    private func getSample_16() {
        OARequest(url: self.url).data(key: "Hello", value: "123").post { print($0) }
    }
    private func getSample_17() {
        guard let image = UIImage(named: "image name"), let imageData = UIImageJPEGRepresentation(image, 1) else {
            return
        }

        OARequest(url: self.url).file(key: "pic", data: imageData, mimeType: "image/jpg").post { print($0) }
    }
    private func getSample_18() {
        guard let image = UIImage(named: "image name"), let imageData = UIImageJPEGRepresentation(image, 1) else {
            return
        }

        OARequest(url: self.url).file(key: "pic", data: imageData, fileName: "pic", mimeType: "image/jpg").post { print($0) }
    }
    private func getSample_19() {
        guard let image = UIImage(named: "image name"), let imageData = UIImageJPEGRepresentation(image, 1) else {
            return
        }

        OARequest(url: self.url).file(key: "pic", data: imageData, mimeType: "image/jpg").progress{ print($0) }.post { print($0) }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]: return self.getSample_00()
        case [0, 1]: return self.getSample_01()
        case [0, 2]: return self.getSample_02()
        case [0, 3]: return self.getSample_03()
        case [0, 4]: return self.getSample_04()
        case [0, 5]: return self.getSample_05()
            
        case [1, 0]: return self.getSample_10()
        case [1, 1]: return self.getSample_11()
        case [1, 2]: return self.getSample_12()
        case [1, 3]: return self.getSample_13()
            
        case [1, 4]: return self.getSample_14()
        case [1, 5]: return self.getSample_15()
        case [1, 6]: return self.getSample_16()
            
        case [1, 7]: return self.getSample_17()
        case [1, 8]: return self.getSample_18()
        case [1, 9]: return self.getSample_19()

        default: break
        }
    }
    
    private let samples: [[Request]] = [
        [
            Request(title: "return json sample 1"),
            Request(title: "return json sample 2"),
            Request(title: "return model sample 1"),
            Request(title: "return model sample 2"),
            
            Request(title: "with header"),
            Request(title: "with param"),
        ],

        [
            Request(title: "return json sample 1"),
            Request(title: "return json sample 2"),
            Request(title: "return model sample 1"),
            Request(title: "return model sample 2"),
            
            Request(title: "with header"),
            Request(title: "with param"),
            Request(title: "with data"),
            
            Request(title: "with file sample 1"),
            Request(title: "with file sample 2"),

            Request(title: "with progress"),
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(RequestCell.self, forCellReuseIdentifier: "RequestCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.samples.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.samples[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as? RequestCell else {
            return RequestCell(style: .default, reuseIdentifier: "RequestCell").fetchUI(data: self.samples[indexPath.section][indexPath.row])
        }
        return cell.fetchUI(data: self.samples[indexPath.section][indexPath.row])
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "GET Sample"
        default:
            return "POST Sample"
        }
    }
}
