//
//  VC.Storage.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import OAKit

struct Book: Codable {
    var title: String
}

extension VC {
    class Storage: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            self.title = "Storage Sample"
            
            let scroll = UIScrollView()
            scroll.contentInsetAdjustmentBehavior = .always
            scroll.add(to: self.view).t().e()
            scroll.add(to: self.view).b().e()
            scroll.add(to: self.view).l().e()
            scroll.add(to: self.view).r().e()
            
            OA.Storage.truncate(model: Book.self)
            
            let texts: [Step] = [
                .init(title: "清空", text: "OA.Storage.truncate(model: Book.self)") {
                    OA.Storage.truncate(model: Book.self) ? "true" : "false"
                },
                .init(title: "原型"),
                .init(title: "寫入", text: "OA.Storage.set(models: [BookStorage(title: \"ABC\")])") {
                    OA.Storage.set(models: [Book(title: "ABC")]) ? "true" : "false"
                },
                .init(title: "讀取", text: "OA.Storage.get(models: Book.self).first?.title") {
                    "\(OA.Storage.get(model: Book.self).first?.title ?? "nil")"
                },
                .init(title: "應用"),
                .init(title: "新增", text: "OA.Storage.create(model: BookStorage(title: \"Apple\"))") {
                    OA.Storage.create(model: Book(title: "Apple")) ? "true" : "false"
                },
                .init(title: "數量", text: "OA.Storage.all(model: Book.self).count") {
                    "\(OA.Storage.all(model: Book.self).count)"
                },
                .init(title: "取出", text: "OA.Storage.all(model: Book.self).first?.title") {
                    "\(OA.Storage.all(model: Book.self).first?.title ?? "nil")"
                },
                .init(title: "單取", text: "OA.Storage.one(model: Book.self)?.title") {
                    "\(OA.Storage.one(model: Book.self)?.title ?? "nil")"
                },
                .init(title: "第一筆", text: "OA.Storage.first(model: Book.self)?.title") {
                    "\(OA.Storage.first(model: Book.self)?.title ?? "nil")"
                },
                .init(title: "最後筆", text: "OA.Storage.last(model: Book.self)?.title") {
                    "\(OA.Storage.last(model: Book.self)?.title ?? "nil")"
                },
                .init(title: "其他"),
                .init(title: "POP 第 1 次", text: "OA.Storage.pop(model: Book.self)?.title") {
                    "\(OA.Storage.pop(model: Book.self)?.title ?? "nil")"
                },
                .init(title: "POP 第 2 次", text: "OA.Storage.pop(model: Book.self)?.title") {
                    "\(OA.Storage.pop(model: Book.self)?.title ?? "nil")"
                },
                .init(title: "POP 第 3 次", text: "OA.Storage.pop(model: Book.self)?.title") {
                    "\(OA.Storage.pop(model: Book.self)?.title ?? "nil")"
                },
                .init(title: "數量", text: "OA.Storage.all(model: Book.self).count") {
                    "\(OA.Storage.all(model: Book.self).count)"
                }
            ]
            
            weak var tmp: UIView?

            for view in texts.map({ $0.view() }) {
                view.add(to: scroll).l(12).e()
                view.add(to: scroll).r(-12).qL().e()
                if let tmp = tmp {
                    view.add(to: scroll).t().q(tmp).b(12).e()
                } else {
                    view.add(to: scroll).t(20).e()
                }
                tmp = view
            }

            tmp?.add(to: scroll).b(-20).qL(scroll).e()
        }
    }

    class Step {
        private var title: String = ""
        private var text: String? = nil
        private var result: String = ""

        init(title: String, text: String?, result: () -> String) {
            self.title = title
            self.text = text
            self.result = result()
        }

        init(title: String) {
            self.title = title
        }
        
        public func view() -> UIView {
            guard let textStr = self.text else {
                let view = UIView()

                let title = UILabel()
                title.text = self.title
                title.font = .boldSystemFont(ofSize: 22)
                title.add(to: view).t(16).e()
                title.add(to: view).l().e()
                title.add(to: view).r().qL(view).r().e()
                title.add(to: view).b().e()

                return view
            }

            let view = UIView()
            let title = UILabel()
            title.text = self.title
            title.font = .boldSystemFont(ofSize: 18)
            title.add(to: view).t().e()
            title.add(to: view).l(16).e()
            title.add(to: view).r().qL(view).r().e()

            let commend = UILabel()
            commend.text = "語法："
            commend.add(to: view).t().q(title).b(4).e()
            commend.add(to: view).l(12).q(title).e()

            let text = UILabel()
            text.text = textStr
            text.add(to: view).l().q(commend).r().e()
            text.add(to: view).y().q(commend).e()
            text.add(to: view).r().qL(view).r().e()

            let `return` = UILabel()
            `return`.text = "結果："
            `return`.add(to: view).t().q(commend).b(2).e()
            `return`.add(to: view).l().q(commend).e()
            `return`.add(to: view).b().e()

            let result = UILabel()
            result.text = self.result
            result.add(to: view).l().q(`return`).r().e()
            result.add(to: view).y().q(`return`).e()
            result.add(to: view).r().qL(view).r().e()

            return view
        }
    }
}
