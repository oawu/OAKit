//
//  StorageViewController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2019/10/1.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

struct BookStorage: OAStorable {
    var title: String
}

class StorageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Storage Sample"
        
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .always
        scroll.to(self.view).top().enable()
        scroll.to(self.view).left().enable()
        scroll.to(self.view).right().enable()
        scroll.to(self.view).bottom().enable()
        
        OAStorage.truncate(model: BookStorage.self)
        
        let texts: [Step] = [
            Step(title: "清空", text: "OAStorage.truncate(model: BookStorage.self)") {
                OAStorage.truncate(model: BookStorage.self) ? "true" : "false"
            },
            Step(title: "原型"),
            Step(title: "寫入", text: "OAStorage.set(models: [BookStorage(title: \"ABC\")])") {
                OAStorage.set(models: [BookStorage(title: "ABC")]) ? "true" : "false"
            },
            Step(title: "讀取", text: "OAStorage.get(models: BookStorage.self).first?.title") {
                "\(OAStorage.get(model: BookStorage.self).first?.title ?? "nil")"
            },
            Step(title: "應用"),
            Step(title: "新增", text: "OAStorage.create(model: BookStorage(title: \"Apple\"))") {
                OAStorage.create(model: BookStorage(title: "Apple")) ? "true" : "false"
            },
            Step(title: "數量", text: "OAStorage.all(model: BookStorage.self).count") {
                "\(OAStorage.all(model: BookStorage.self).count)"
            },
            Step(title: "取出", text: "OAStorage.all(model: BookStorage.self).first?.title") {
                "\(OAStorage.all(model: BookStorage.self).first?.title ?? "nil")"
            },
            Step(title: "單取", text: "OAStorage.one(model: BookStorage.self)?.title") {
                "\(OAStorage.one(model: BookStorage.self)?.title ?? "nil")"
            },
            Step(title: "第一筆", text: "OAStorage.first(model: BookStorage.self)?.title") {
                "\(OAStorage.first(model: BookStorage.self)?.title ?? "nil")"
            },
            Step(title: "最後筆", text: "OAStorage.last(model: BookStorage.self)?.title") {
                "\(OAStorage.last(model: BookStorage.self)?.title ?? "nil")"
            },
            Step(title: "其他"),
            Step(title: "POP 第 1 次", text: "OAStorage.pop(model: BookStorage.self)?.title") {
                "\(OAStorage.pop(model: BookStorage.self)?.title ?? "nil")"
            },
            Step(title: "POP 第 2 次", text: "OAStorage.pop(model: BookStorage.self)?.title") {
                "\(OAStorage.pop(model: BookStorage.self)?.title ?? "nil")"
            },
            Step(title: "POP 第 3 次", text: "OAStorage.pop(model: BookStorage.self)?.title") {
                "\(OAStorage.pop(model: BookStorage.self)?.title ?? "nil")"
            },
            Step(title: "數量", text: "OAStorage.all(model: BookStorage.self).count") {
                "\(OAStorage.all(model: BookStorage.self).count)"
            }
        ]
        
        var tmp: UIView?

        for view in texts.map({ $0.view() }) {
                view.to(scroll).left(12).enable()
                view.to(scroll).right(-12).lessThanOrEqual().enable()
                if let tmp = tmp {
                    view.to(scroll).top().equal(tmp).bottom(12).enable()
                } else {
                    view.to(scroll).top(20).enable()
                }
                tmp = view
        }

        tmp?.to(scroll).bottom(-20).lessThanOrEqual().enable()
        
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
            title.to(view).top(16).enable()
            title.to(view).left().enable()
            title.to(view).right().lessThanOrEqual(view).right().enable()
            title.to(view).bottom().enable()

            return view
        }

        let view = UIView()
        let title = UILabel()
        title.text = self.title
        title.font = .boldSystemFont(ofSize: 18)
        title.to(view).top().enable()
        title.to(view).left(16).enable()
        title.to(view).right().lessThanOrEqual(view).right().enable()
        
        let commend = UILabel()
        commend.text = "語法："
        commend.to(view).top().equal(title).bottom(4).enable()
        commend.to(view).left(12).equal(title).enable()
        
        let text = UILabel()
        text.text = textStr
        text.to(view).left().equal(commend).right().enable()
        text.to(view).centerY().equal(commend).enable()
        text.to(view).right().lessThanOrEqual(view).right().enable()
        
        let `return` = UILabel()
        `return`.text = "結果："
        `return`.to(view).top().equal(commend).bottom(2).enable()
        `return`.to(view).left().eq(commend).enable()
        `return`.to(view).bottom().enable()
        
        let result = UILabel()
        result.text = self.result
        result.to(view).left().equal(`return`).right().enable()
        result.to(view).centerY().equal(`return`).enable()
        result.to(view).right().lessThanOrEqual(view).right().enable()
        
        return view
    }
}
