//
//  HUDViewController.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2021/12/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

class HUDViewController: UITableViewController {
    
    class Cell: UITableViewCell, OA.Cell {
        static let id: String = "Request.Cell"
        
        @discardableResult
        public func fetchUI(data: String) -> Self {
            self.textLabel?.text = data
            self.accessoryType = .disclosureIndicator
            return self
        }
    }
    private let samples: [String] = ["讀取中", "讀取後成功", "讀取後失敗"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reg(cell: Cell.self)
    }
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.samples.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { tableView.gen(cell: Cell.self, indexPath: indexPath).fetchUI(data: self.samples[indexPath.row]) }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath {
        case [0, 0]:
            OA.HUD.content(type: .loading, description: "讀取中…")?.show {
                OA.HUD.hide(delay: 2)
            }
        case [0, 1]:
            OA.HUD.content(type: .loading, description: "讀取中…")?.show {
                setTimeout(second: 1) {
                    OA.HUD.content(type: .done, description: "成功！")?.hide(delay: 2)
                }
            }
        case [0, 2]:
            OA.HUD.content(type: .loading, description: "讀取中…")?.show {
                setTimeout(second: 1) {
                    OA.HUD.content(type: .fail, description: "失敗！")?.hide(delay: 2)
                }
            }
        default: break
        }
    }
}
