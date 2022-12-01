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
            self.view.backgroundColor = UIColor.secondarySystemBackground()

            let label: UILabel = .init()
            label.text = "aaaaaaaaaaaaaaaaaa"
            label.backgroundColor = .green
            label.add(to: self.view, enable: "st; sl; sr; sb")
//            label.add(to: self.view, enable: "st")
//            label.add(to: self.view, enable: "st=20")
//            label.add(to: self.view, enable: "t=st,20")
//            label.add(to: self.view, enable: "t=sb,-100")
        }
    }
}
