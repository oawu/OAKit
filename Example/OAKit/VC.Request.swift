//
//  VC.Request.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import OAKit

extension VC {
    class Request: UITableViewController {
        struct Model: Decodable {
            let ip: String
        }

        struct Raw: Encodable {
            public let title: String
        }
        
        class Cell: UITableViewCell, OA.TableCell {
            static let id: String = "Request.Cell"
            
            @discardableResult
            public func fetchUI(str: String) -> Self {
                self.textLabel?.text = str
                self.accessoryType = .disclosureIndicator
                return self
            }
        }
        
        private let url = ""
        private let groups: [(header: String, items: [String])] = [
            (header: "Request", items: [
                "get - query + form",
                "post - query + form",
                "put - query + form",
                "delete - query + form",
                
                "get - fail",
                "post - fail",
                "put - fail",
                "delete - fail",
                
                "get - done",
                "post - done",
                "put - done",
                "delete - done",
                
                "get - query + row[text]",
                "post - query + row[text]",
                "put - query + row[text]",
                "delete - query + row[text]",
                
                "get - query + row[model]",
                "post - query + row[model]",
                "put - query + row[model]",
                "delete - query + row[model]",
                
                "get - query + row[models]",
                "post - query + row[models]",
                "put - query + row[models]",
                "delete - query + row[models]",
                
                "get - query + file",
                "post - query + file",
                "put - query + file",
                "delete - query + file",
                
                "get - query + delay(2s)",
                "post - query + delay(2s)",
                "put - query + delay(2s)",
                "delete - query + delay(2s)",
                
                "get - query + empty1",
                "post - query + empty1",
                "put - query + empty1",
                "delete - query + empty1",
                
                "get - query + empty2",
                "post - query + empty2",
                "put - query + empty2",
                "delete - query + empty2",
                
                "get - query + form + before + after",
                "post - query + form + before + after",
                "put - query + form + before + after",
                "delete - query + form + before + after",
            ]),
            
            (header: "API", items: [
                "get - query + form",
                "post - query + form",
                "put - query + form",
                "delete - query + form",
                
                "get - fail",
                "post - fail",
                "put - fail",
                "delete - fail",
                
                "get - done",
                "post - done",
                "put - done",
                "delete - done",
                
                "get - query + row[text]",
                "post - query + row[text]",
                "put - query + row[text]",
                "delete - query + row[text]",
                
                "get - query + row[model]",
                "post - query + row[model]",
                "put - query + row[model]",
                "delete - query + row[model]",
                
                "get - query + row[models]",
                "post - query + row[models]",
                "put - query + row[models]",
                "delete - query + row[models]",
                
                "get - query + file",
                "post - query + file",
                "put - query + file",
                "delete - query + file",
                
                "get - query + delay(2s)",
                "post - query + delay(2s)",
                "put - query + delay(2s)",
                "delete - query + delay(2s)",
                
                "get - query + form + before + after",
                "post - query + form + before + after",
                "put - query + form + before + after",
                "delete - query + form + before + after",
            ]),
        ]
        private let data: Data = UIImage(named: "demo")!.jpegData(compressionQuality: 1)!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.reg(cell: Cell.self)
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int { self.groups.count }
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { self.groups[section].header }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.groups[section].items.count }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { tableView.gen(cell: Cell.self, indexPath: indexPath).fetchUI(str: self.groups[indexPath.section].items[indexPath.row]) }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)

            switch indexPath {
            case [0, 0]: return self.getSample_0_0()
            case [0, 1]: return self.getSample_0_1()
            case [0, 2]: return self.getSample_0_2()
            case [0, 3]: return self.getSample_0_3()
                
            case [0, 4]: return self.getSample_0_4()
            case [0, 5]: return self.getSample_0_5()
            case [0, 6]: return self.getSample_0_6()
            case [0, 7]: return self.getSample_0_7()
                
            case [0, 8]: return self.getSample_0_8()
            case [0, 9]: return self.getSample_0_9()
            case [0, 10]: return self.getSample_0_10()
            case [0, 11]: return self.getSample_0_11()
                
            case [0, 12]: return self.getSample_0_12()
            case [0, 13]: return self.getSample_0_13()
            case [0, 14]: return self.getSample_0_14()
            case [0, 15]: return self.getSample_0_15()
                
            case [0, 16]: return self.getSample_0_16()
            case [0, 17]: return self.getSample_0_17()
            case [0, 18]: return self.getSample_0_18()
            case [0, 19]: return self.getSample_0_19()
                
            case [0, 20]: return self.getSample_0_20()
            case [0, 21]: return self.getSample_0_21()
            case [0, 22]: return self.getSample_0_22()
            case [0, 23]: return self.getSample_0_23()
                
            case [0, 24]: return self.getSample_0_24()
            case [0, 25]: return self.getSample_0_25()
            case [0, 26]: return self.getSample_0_26()
            case [0, 27]: return self.getSample_0_27()
                
            case [0, 28]: return self.getSample_0_28()
            case [0, 29]: return self.getSample_0_29()
            case [0, 30]: return self.getSample_0_30()
            case [0, 31]: return self.getSample_0_31()
                
            case [0, 32]: return self.getSample_0_32()
            case [0, 33]: return self.getSample_0_33()
            case [0, 34]: return self.getSample_0_34()
            case [0, 35]: return self.getSample_0_35()
                
            case [0, 36]: return self.getSample_0_36()
            case [0, 37]: return self.getSample_0_37()
            case [0, 38]: return self.getSample_0_38()
            case [0, 39]: return self.getSample_0_39()
                
            case [0, 40]: return self.getSample_0_40()
            case [0, 41]: return self.getSample_0_41()
            case [0, 42]: return self.getSample_0_42()
            case [0, 43]: return self.getSample_0_43()

            case [1, 0]: return self.getSample_1_0()
            case [1, 1]: return self.getSample_1_1()
            case [1, 2]: return self.getSample_1_2()
            case [1, 3]: return self.getSample_1_3()
                
            case [1, 4]: return self.getSample_1_4()
            case [1, 5]: return self.getSample_1_5()
            case [1, 6]: return self.getSample_1_6()
            case [1, 7]: return self.getSample_1_7()
                
            case [1, 8]: return self.getSample_1_8()
            case [1, 9]: return self.getSample_1_9()
            case [1, 10]: return self.getSample_1_10()
            case [1, 11]: return self.getSample_1_11()
                
            case [1, 12]: return self.getSample_1_12()
            case [1, 13]: return self.getSample_1_13()
            case [1, 14]: return self.getSample_1_14()
            case [1, 15]: return self.getSample_1_15()
                
            case [1, 16]: return self.getSample_1_16()
            case [1, 17]: return self.getSample_1_17()
            case [1, 18]: return self.getSample_1_18()
            case [1, 19]: return self.getSample_1_19()
                
            case [1, 20]: return self.getSample_1_20()
            case [1, 21]: return self.getSample_1_21()
            case [1, 22]: return self.getSample_1_22()
            case [1, 23]: return self.getSample_1_23()
                
            case [1, 24]: return self.getSample_1_24()
            case [1, 25]: return self.getSample_1_25()
            case [1, 26]: return self.getSample_1_26()
            case [1, 27]: return self.getSample_1_27()
            
            case [1, 28]: return self.getSample_1_28()
            case [1, 29]: return self.getSample_1_29()
            case [1, 30]: return self.getSample_1_30()
            case [1, 31]: return self.getSample_1_31()
                
            case [1, 32]: return self.getSample_1_32()
            case [1, 33]: return self.getSample_1_33()
            case [1, 34]: return self.getSample_1_34()
            case [1, 35]: return self.getSample_1_35()

            default: break
            }
        }
        
        private func getSample_0_0() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").get { print($0) } }
        private func getSample_0_1() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").post { print($0) } }
        private func getSample_0_2() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").put { print($0) } }
        private func getSample_0_3() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").delete { print($0) } }
        
        private func getSample_0_4() { OA.Request(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.get { print($0) } }
        private func getSample_0_5() { OA.Request(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.post { print($0) } }
        private func getSample_0_6() { OA.Request(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.put { print($0) } }
        private func getSample_0_7() { OA.Request(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.delete { print($0) } }
        
        private func getSample_0_8() { OA.Request(url: self.url, method: .get).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { print(1) }.done { print(2) }.send() }
        private func getSample_0_9() { OA.Request(url: self.url, method: .post).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { print(1) }.done { print(2) }.send() }
        private func getSample_0_10() { OA.Request(url: self.url, method: .put).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { print(1) }.done { print(2) }.send() }
        private func getSample_0_11() { OA.Request(url: self.url, method: .delete).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { print(1) }.done { print(2) }.send() }
        
        private func getSample_0_12() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").get { print($0) } }
        private func getSample_0_13() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").post { print($0) } }
        private func getSample_0_14() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").put { print($0) } }
        private func getSample_0_15() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").delete { print($0) } }
        
        private func getSample_0_16() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).get { print($0) } }
        private func getSample_0_17() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).post { print($0) } }
        private func getSample_0_18() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).put { print($0) } }
        private func getSample_0_19() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).delete { print($0) } }

        private func getSample_0_20() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).get { print($0) } }
        private func getSample_0_21() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).post { print($0) } }
        private func getSample_0_22() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).put { print($0) } }
        private func getSample_0_23() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).delete { print($0) } }

        private func getSample_0_24() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).get { print($0) } }
        private func getSample_0_25() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).post { print($0) } }
        private func getSample_0_26() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).put { print($0) } }
        private func getSample_0_27() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).delete { print($0) } }
        
        private func getSample_0_28() { OA.Request(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").get { print($0) } }
        private func getSample_0_29() { OA.Request(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").post { print($0) } }
        private func getSample_0_30() { OA.Request(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").put { print($0) } }
        private func getSample_0_31() { OA.Request(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").delete { print($0) } }
        
        private func getSample_0_32() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").get {} }
        private func getSample_0_33() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").post {} }
        private func getSample_0_34() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").put {} }
        private func getSample_0_35() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").delete {} }
        
        private func getSample_0_36() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").get() }
        private func getSample_0_37() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").post() }
        private func getSample_0_38() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").put() }
        private func getSample_0_39() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").delete() }
        
        private func getSample_0_40() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.get() }
        private func getSample_0_41() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.post() }
        private func getSample_0_42() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.put() }
        private func getSample_0_43() { OA.Request(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.delete() }
        
        private func getSample_1_0() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").get { (model: Model) in print(model) } }
        private func getSample_1_1() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").post { (model: Model) in print(model) } }
        private func getSample_1_2() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").put { (model: Model) in print(model) } }
        private func getSample_1_3() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").delete { (model: Model) in print(model) } }
        
        private func getSample_1_4() { OA.API(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.get { (model: Model) in print(model) } }
        private func getSample_1_5() { OA.API(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.post { (model: Model) in print(model) } }
        private func getSample_1_6() { OA.API(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.put { (model: Model) in print(model) } }
        private func getSample_1_7() { OA.API(url: self.url + "a").progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").fail { print($0.code) }.delete { (model: Model) in print(model) } }
        
        private func getSample_1_8() { OA.API(url: self.url, method: .get).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { (model: Model) in print(1) }.done { (model: Model) in print(2) }.send() }
        private func getSample_1_9() { OA.API(url: self.url, method: .post).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { (model: Model) in print(1) }.done { (model: Model) in print(2) }.send() }
        private func getSample_1_10() { OA.API(url: self.url, method: .put).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { (model: Model) in print(1) }.done { (model: Model) in print(2) }.send() }
        private func getSample_1_11() { OA.API(url: self.url, method: .delete).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").done { (model: Model) in print(1) }.done { (model: Model) in print(2) }.send() }
        
        private func getSample_1_12() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").get { (model: Model) in print(model) } }
        private func getSample_1_13() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").post { (model: Model) in print(model) } }
        private func getSample_1_14() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").put { (model: Model) in print(model) } }
        private func getSample_1_15() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(text: "aaaaaa").delete { (model: Model) in print(model) } }
        
        private func getSample_1_16() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).get { (model: Model) in print(model) } }
        private func getSample_1_17() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).post { (model: Model) in print(model) } }
        private func getSample_1_18() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).put { (model: Model) in print(model) } }
        private func getSample_1_19() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(model: Raw(title: "OA")).delete { (model: Model) in print(model) } }

        private func getSample_1_20() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).get { (model: Model) in print(model) } }
        private func getSample_1_21() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).post { (model: Model) in print(model) } }
        private func getSample_1_22() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).put { (model: Model) in print(model) } }
        private func getSample_1_23() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").raw(models: [Raw(title: "OA"), Raw(title: "OB")]).delete { (model: Model) in print(model) } }

        private func getSample_1_24() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).get { (model: Model) in print(model) } }
        private func getSample_1_25() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).post { (model: Model) in print(model) } }
        private func getSample_1_26() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).put { (model: Model) in print(model) } }
        private func getSample_1_27() { OA.API(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").file(key: "pic", mime: "image/jpg", data: self.data).delete { (model: Model) in print(model) } }
        
        private func getSample_1_28() { OA.API(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").get { (model: Model) in print(model) } }
        private func getSample_1_29() { OA.API(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").post { (model: Model) in print(model) } }
        private func getSample_1_30() { OA.API(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").put { (model: Model) in print(model) } }
        private func getSample_1_31() { OA.API(url: self.url).delay(second: 2).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").delete { (model: Model) in print(model) } }
        
        private func getSample_1_32() { OA.API<Model>(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.get() }
        private func getSample_1_33() { OA.API<Model>(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.post() }
        private func getSample_1_34() { OA.API<Model>(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.put() }
        private func getSample_1_35() { OA.API<Model>(url: self.url).progress { print($0) }.header(key: "h", val: "aa").query(key: "a", val: "1").query(key: "b", val: "?1@2 3+%").form(key: "c", val: "2").form(key: "d", val: "?1@2 3+%").before { print(1) }.before { print(2) }.after { print(3) }.after { print(4) }.delete() }
        
    }
}
