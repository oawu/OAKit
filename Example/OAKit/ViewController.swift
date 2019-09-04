//
//  ViewController.swift
//  OAKit
//
//  Created by comdan66 on 05/20/2019.
//  Copyright (c) 2019 comdan66. All rights reserved.
//

import UIKit
import OAKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        OATimer.replace.delay(key: "aa", timer: 5) {
            print("1")
        }
        OATimer.replace.delay(key: "aa", timer: 2) {
            print("2")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

