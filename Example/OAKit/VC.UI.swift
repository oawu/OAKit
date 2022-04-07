//
//  VC.UI.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2022/3/12.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

extension VC {
    class UI: UIViewController {
        enum Item: String, OA.UI.Delegate.Item {
            case item1, item2

            var title: String { self.rawValue }
            var subtitle: String { "sub: \(self.rawValue)" }
            static func == (lhs: Self, rhs: Self) -> Bool { lhs.rawValue == rhs.rawValue }
        }
        struct User: OA.UI.Delegate.Item {
            let id: UInt64
            let name: String
            var title: String { self.name }
            var subtitle: String { "" }
            static func == (lhs: VC.UI.User, rhs: VC.UI.User) -> Bool { lhs.id == rhs.id }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.secondarySystemBackground
            
            let error = OA.UI.Error()
            
            let horizontal = OA.UI.Stack(ui: UIScrollView(), type: .horizontal).height(100)
                .append(OA.UI.Stack(ui: UIView().border(5, .blue)).width(150))
                .append(OA.UI.Stack(ui: UIView().border(5, .red)).width(30))
                .append(OA.UI.Stack(ui: UIView().border(5, .green)).width(50))
                .append(OA.UI.Stack(ui: UIView().border(5, .purple)).width(80))
                .append(OA.UI.Stack(ui: UIView().border(5, .yellow)).width(120))
            
            horizontal.body.border(1, .red)
            
            let scroll = OA.UI.scroll(to: self.view, enable: "x; y")
                .append(horizontal)
                .append(OA.UI.Input(title: "標題", bgColor: .red))
            
            if #available(iOS 13.0, *) {
                scroll.append(OA.UI.Input(title: "地址", icon: .init(systemName: "location.magnifyingglass")))
            } else {
                scroll.append(OA.UI.Input(title: "地址", icon: nil))
            }
            
            scroll.append(OA.UI.Input(title: "數字", type: .uint))
                .append(OA.UI.Input(title: "內容", type: .textView))
                .append(OA.UI.Check<Item>(title: "選擇", values: [.item1, .item2]).on(change: {
                    error.messages = []
                }))
                .append(OA.UI.Check<User>(title: "使用者", values: [.init(id: 1, name: "User 1"), .init(id: 2, name: "User 2")]).on(click: {
                    error.messages = []
                }))
                .append(OA.UI.Choice(title: "請選擇"))
            
            error.add(to: scroll)
            
            scroll.append(OA.UI.Button(title: "確定").on(click: {
                error.messages = ["錯誤 1", "錯誤 2"]
            }))
            
            let b = OA.UI.Button(title: "確定")
            b.on(click: {
                b.text = "\(OA.Func.randomString())"
                b.isEnable = false
                b.color = .red
            })
            scroll.append(b)
            
            scroll.frame.border(1, .red)
            scroll.frame.add(to: self.view).t().q(self.view.safeAreaLayoutGuide).t().e()
            scroll.frame.add(to: self.view).l().q(self.view.safeAreaLayoutGuide).l().e()
            scroll.frame.add(to: self.view).b().q(self.view.safeAreaLayoutGuide).b().e()
            scroll.frame.add(to: self.view).r().q(self.view.safeAreaLayoutGuide).r().e()
        }
    }
}
