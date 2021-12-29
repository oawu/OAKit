//
//  ViewController.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import OAKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        let view = UILabel()
        view.text = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        view.border(1, .red)
//        view.add(to: self.view, enables: [
//            "y", "h=50", "l",
//            "r-200"
//        ])
        view.add(to: self.view, enable: "y; h=50 ; ; l;r-200")
    }
}
