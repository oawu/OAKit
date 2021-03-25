//
//  MainController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit

class MainController: UITableViewController {
    
    struct Sample {
        public let title: String
        public let vc: UIViewController
    }

    class Cell: UITableViewCell {
        @discardableResult
        public func fetchUI(data: Sample) -> Self {
            self.textLabel?.text = data.title
            self.accessoryType = .disclosureIndicator
            return self
        }
    }

    private let samples: [Sample] = [
        .init(title: "Storage", vc: StorageViewController()),
        .init(title: "Timer", vc: TimerViewController()),
        .init(title: "Request", vc: RequestViewController(style: .plain)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "OAKit 範例"
        self.tableView.register(Cell.self, forCellReuseIdentifier: "Main.Cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.samples.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { ((tableView.dequeueReusableCell(withIdentifier: "Main.Cell") as? Cell) ?? Cell(style: .default, reuseIdentifier: "Main.Cell")).fetchUI(data: self.samples[indexPath.row]) }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { self.navigationController?.pushViewController(self.samples[indexPath.row].vc, animated: true) }
}
