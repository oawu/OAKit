//
//  ViewController.swift
//  OAKit
//
//  Created by comdan66 on 05/20/2019.
//  Copyright (c) 2019 comdan66. All rights reserved.
//

import UIKit
import OAKit

class Book: OAModel {
    static var key: String? = "Book"
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Book.deleteAll())
        Book.create(["name": "OA1", "sex": "男生"])
        Book.create(["name": "OA2", "sex": "男生"])
        Book.create(["name": "OA3", "sex": "男生"])
        Book.create(["name": "OA4", "sex": "男生"])
        Book.create(["name": "OA5", "sex": "男生"])
        
        print(Book.all(type: [String: String].self))
        print("====================")
        print(Book.pops(type: [String: String].self, limit: 2))
        print("====================")
        print(Book.all(type: [String: String].self))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

