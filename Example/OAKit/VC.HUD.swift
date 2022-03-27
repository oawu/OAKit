//
//  VC.HUD.swift
//  OAKit_Example
//
//  Created by 吳政賢 on 2021/12/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import OAKit

extension VC {
    class HUD: UITableViewController {

        class Cell: UITableViewCell, OA.TableCell {
            static let id: String = "Request.Cell"
            
            @discardableResult
            public func fetchUI(data: String) -> Self {
                self.textLabel?.text = data
                self.accessoryType = .disclosureIndicator
                return self
            }
        }
        private let samples: [String] = ["讀取中", "讀取後成功", "讀取後失敗", "單純顯示、隱藏", "改變", "進度"]

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
                OA.HUD.show(icon: .loading, description: "讀取中…").hide(delay: 5)

            case [0, 1]:
                OA.HUD.show(icon: .loading, description: "讀取中…") {_ in
                    setTimeout(second: 1) {
                        OA.HUD.view(icon: .done, description: "成功！").hide(delay: 5)
                    }
                }
            case [0, 2]:
                OA.HUD.show(icon: .loading, description: "讀取中…") {_ in
                    setTimeout(second: 1) {
                        OA.HUD.view(icon: .fail, description: "失敗！").hide(delay: 5)
                    }
                }
            case [0, 3]:
                OA.HUD.show(icon: .loading, description: "讀取中…")
                setTimeout(second: 3) {
                    OA.HUD.hide()
                }
            case [0, 4]:
                OA.HUD.show(icon: .loading, description: "讀取中…")
                OA.HUD.show(icon: .loading, description: "test…")

                setTimeout(second: 3) {
                    OA.HUD.hide()
                }
            case [0, 5]:
                OA.HUD.show(icon: .progress, description: "讀取中…")
                setTimeout(second: 1) {
                    OA.HUD.progress = 0.1
                    setTimeout(second: 0.1) {
                        OA.HUD.progress = 0.3
                        
                        setTimeout(second: 0.1) {
                            OA.HUD.progress = 0.4
                            
                            setTimeout(second: 0.1) {
                                OA.HUD.progress = 0.5
                                
                                setTimeout(second: 0.1) {
                                    OA.HUD.progress = 0.7
                                    
                                    setTimeout(second: 0.1) {
                                        OA.HUD.progress = 0.8
                                        
                                        setTimeout(second: 0.1) {
                                            OA.HUD.progress = 0.9
                                            
                                            setTimeout(second: 0.1) {
                                                OA.HUD.progress = 1.0
                                                
                                                setTimeout(second: 0.1) {
                                                    OA.HUD.view(icon: .done, description: "OK").hide(delay: 1)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                

                
            default: break
            }
        }
    }
}
