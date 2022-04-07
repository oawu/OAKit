//
//  VC.Layout.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2022/1/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

extension VC {
    class Layout: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.secondarySystemBackground

            let label: UILabel = .init()
            label.text = "aaaaaaaaaaaaaaaaaa"
            label.backgroundColor = .green
            label.add(to: self.view, enable: "x;y;w=100;h>w")
        }
    }
}
