//
//  OA.Cell.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

import UIKit

public protocol OACell: UITableViewCell {
    static var id: String { get }
}

extension OA {
    public typealias Cell = OACell
}
