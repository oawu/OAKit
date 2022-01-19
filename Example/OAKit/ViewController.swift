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
    
    @objc func click(_ sender: UIButton? = nil) {
    }
    override func viewDidLoad() {
        let button: UIButton = .init()
        button.add(to: self.view, enable: "x; y")
        button.setTitle("點我", for: .normal)
        if #available(iOS 13.0, *) {
            button.setTitleColor(.link, for: .normal)
        } else {
            button.setTitleColor(.blue, for: .normal)
        }
        button.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
    }
}
