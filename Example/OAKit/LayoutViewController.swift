//
//  LayoutViewController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2022/1/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

class LayoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .secondarySystemBackground
        } else {
            self.view.backgroundColor = .white
        }
        
        
        let label: UILabel = .init()
        label.text = "aaaaaaaaaaaaaaaaaa"
        label.backgroundColor = .green
        label.add(to: self.view, enable: "l<;y;h=10;w>44")
    }
}
