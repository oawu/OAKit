//
//  URLViewController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import OAKit

class RequestViewController: UITableViewController {
    struct Model: Decodable {
        public let title: String
    }

    struct Raw: Encodable {
        public let title: String
    }
    
    struct Request {
        public let title: String
    }
    
    class Cell: UITableViewCell {
        @discardableResult
        public func fetchUI(data: Request) -> Self {
            self.textLabel?.text = data.title
            self.accessoryType = .disclosureIndicator
            return self
        }
    }
    
    private let url = ""
    private let samples: [[Request]] = [[
        Request(title: "Get"),
        Request(title: "Fail"),
        Request(title: "Response Decodable"),
        Request(title: "Post file、header、query、form、progress"),
        
        Request(title: "Put raw text"),
        Request(title: "Put raw Encodable Object"),
        Request(title: "Put raw Encodable Objects"),
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(Cell.self, forCellReuseIdentifier: "Request.Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { self.samples.count }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.samples[section].count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { ((tableView.dequeueReusableCell(withIdentifier: "Request.Cell") as? Cell) ?? Cell(style: .default, reuseIdentifier: "RequestCell")).fetchUI(data: self.samples[indexPath.section][indexPath.row]) }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { section == 1 ? "Sample" : "Other Sample" }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0, 0]: return self.getSample_00()
        case [0, 1]: return self.getSample_01()
        case [0, 2]: return self.getSample_02()
        case [0, 3]: return self.getSample_03()
        case [0, 4]: return self.getSample_04()
        case [0, 5]: return self.getSample_05()
        case [0, 6]: return self.getSample_06()
        default: break
        }
    }
    
    private func getSample_00() {
        OA.Request(url: self.url).get { data in
            print(data)
        }
    }
    private func getSample_01() {
        OA.Request(url: self.url).fail { code, message, response in
            print(code, message, response ?? "")
        }.get { result in
            print(result)
        }
    }
    private func getSample_02() {
        OA.Request(url: self.url).get { (model: Model) in
            print(model)
        }
    }
    private func getSample_03() {
        guard let image = UIImage(named: "image name"), let imageData = image.jpegData(compressionQuality: 1) else { return }

        OA.Request(url: self.url)
            .header(key: "UserAgent", val: "La La La")
            .query(key: "a", val: "+-*/")
            .form(key: "a", val: "+-*/")
            .file(key: "pic", mime: "image/jpg", data: imageData, name: "filename")
            .progress { percent in
                print(percent)
            }
            .post { data in
                print(data)
            }
    }
    private func getSample_04() {
        OA.Request(url: self.url)
            .raw(text: "test")
            .put { data in
                print(data)
            }
    }
    private func getSample_05() {
        OA.Request(url: self.url)
            .raw(object: Raw(title: "test"))
            .put { data in
                print(data)
            }
    }
    private func getSample_06() {
        OA.Request(url: self.url)
            .raw(objects: [Raw(title: "test1"), Raw(title: "test2")])
            .put { data in
                print(data)
            }
    }
}
