//
//  ModelViewController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2019/10/1.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

class BookModel: OAModel<String> {

}

class ModelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Model Sample"
        
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .always
        scroll.to(self.view).top().enable()
        scroll.to(self.view).left().enable()
        scroll.to(self.view).right().enable()
        scroll.to(self.view).bottom().enable()
        
        BookModel.destroy()
        
        let texts: [Step] = [
            Step(title: "Model Key", text: "BookModel.key") {
                return "\"" + BookModel.key + "\""
            },
            Step(title: "單值"),
            Step(title: "清空", text: "BookModel.destroy()") {
                return BookModel.destroy() ? "true" : "false"
            },
            Step(title: "讀取", text: "BookModel.get()") {
                guard let val = BookModel.get() else { return "nil" }
                return "\"" + val + "\""
            },
            Step(title: "預設值讀取", text: "BookModel.get(default: \"OB\")") {
                return "\"" + BookModel.get(default: "OB") + "\""
            },
            Step(title: "寫入", text: "BookModel.set(\"OA\")") {
                return BookModel.set("OA") ? "true" : "false"
            },
            Step(title: "讀取", text: "BookModel.get()") {
                guard let val = BookModel.get() else { return "nil" }
                return "\"" + val + "\""
            },
            Step(title: "預設值取值", text: "BookModel.get(default: \"OB\")") {
                return "\"" + BookModel.get(default: "OB") + "\""
            },
            Step(title: "陣列"),
            Step(title: "清空", text: "BookModel.deleteAll()") {
                return BookModel.deleteAll() ? "true" : "false"
            },
            Step(title: "讀取", text: "BookModel.all()") {
                return "[" + BookModel.all().compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "新增", text: "BookModel.push(\"OA\")") {
                return BookModel.push("OA") ? "true" : "false"
            },
            Step(title: "再次新增", text: "BookModel.push(\"OB\")") {
                return BookModel.push("OB") ? "true" : "false"
            },
            Step(title: "讀取", text: "BookModel.all()") {
                return "[" + BookModel.all().compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "寫入", text: "BookModel.setArray([\"OA\", \"OB\", \"OC\", \"OD\", \"OE\"])") {
                return BookModel.setArray(["OA", "OB", "OC", "OD", "OE"]) ? "true" : "false"
            },
            Step(title: "讀取", text: "BookModel.getArray()") {
                return "[" + BookModel.getArray().compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "POP limit", text: "BookModel.pops(limit: 2)") {
                return "[" + BookModel.pops(limit: 2).compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "讀取", text: "BookModel.getArray()") {
                return "[" + BookModel.getArray().compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "POP one", text: "BookModel.pop()") {
                guard let val = BookModel.pop() else { return "nil" }
                return "\"" + val + "\""
            },
            Step(title: "讀取", text: "BookModel.getArray()") {
                return "[" + BookModel.getArray().compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "POP all", text: "BookModel.pops()") {
                return "[" + BookModel.pops(limit: 2).compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "讀取", text: "BookModel.getArray()") {
                return "[" + BookModel.getArray().compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "陣列功能"),
            Step(title: "清空", text: "BookModel.setArray([])") {
                return BookModel.setArray([]) ? "true" : "false"
            },
            Step(title: "讀取", text: "BookModel.getArray()") {
                return "[" + BookModel.getArray().compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "POP limit", text: "BookModel.pops(limit: 2)") {
                return "[" + BookModel.pops(limit: 2).compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
            Step(title: "POP one", text: "BookModel.pop()") {
                guard let val = BookModel.pop() else { return "nil" }
                return "\"" + val + "\""
            },
            Step(title: "POP all", text: "BookModel.pops()") {
                return "[" + BookModel.pops(limit: 2).compactMap { "\"" + $0 + "\"" }.joined(separator: ", ") + "]"
            },
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