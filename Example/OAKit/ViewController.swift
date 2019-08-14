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
        let imageView = UIImageView()
        
        imageView.url("https://www.ioa.tw/img/md5/2649ac3f3f605e0474053e8505e01247.jpg")
        imageView.border(2, rgba(1, 2, 3, 1))

        imageView.to(self.view).centerX().enable()
        imageView.to(self.view).centerY().enable()
        imageView.to(self.view).width(100).enable()
        imageView.to(self.view).height(100).enable()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

