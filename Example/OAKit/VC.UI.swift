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
            self.view.backgroundColor = .secondarySystemBackground
            
            let error = OA.UI.Error()
            
            let scroll = OA.UI.scroll(to: self.view)
                .append(OA.UI.Stack(ui: UIScrollView(), type: .horizontal).height(100)
                            .append(OA.UI.Stack(ui: UIView().border(5, .blue)).width(150))
                            .append(OA.UI.Stack(ui: UIView().border(5, .red)).width(30))
                            .append(OA.UI.Stack(ui: UIView().border(5, .green)).width(50))
                            .append(OA.UI.Stack(ui: UIView().border(5, .purple)).width(80))
                            .append(OA.UI.Stack(ui: UIView().border(5, .yellow)).width(120))
                )
                .append(OA.UI.Input(title: "標題"))
                .append(OA.UI.Input(title: "地址", icon: .init(systemName: "location.magnifyingglass")))
                .append(OA.UI.Input(title: "數字", type: .uint))
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
        }
    }
}