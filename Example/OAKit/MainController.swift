//
//  MainController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2019/10/1.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class MainController: UITableViewController {
    private let samples: [Sample] = [
        Sample(title: "Model Sample", vc: ModelViewController()),
        Sample(title: "Timer Sample", vc: TimerViewController()),
        Sample(title: "Request Sample", vc: RequestViewController(style: .plain)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "OAKit Sample"
        
        self.tableView.register(SampleCell.self, forCellReuseIdentifier: "SampleCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.samples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell") as? SampleCell else {
            return SampleCell(style: .default, reuseIdentifier: "SampleCell").fetchUI(data: self.samples[indexPath.row])
        }
        return cell.fetchUI(data: self.samples[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(self.samples[indexPath.row].vc, animated: true)
    }
}

struct Sample {
    public let title: String
    public let vc: UIViewController
}

class SampleCell: UITableViewCell {
    @discardableResult
    public func fetchUI(data: Sample) -> Self {
        self.textLabel?.text = data.title
        self.accessoryType = .disclosureIndicator
        return self
    }
}
