//
//  OA.Cell.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation
import UIKit

public protocol OA_Table_Cell: UITableViewCell {
    static var id: String { get }
}

extension OA {
    public typealias TableCell = OA_Table_Cell
}

public protocol OA_Collection_Cell: UICollectionViewCell {
    static var id: String { get }
}

extension OA {
    public typealias CollectionCell = OA_Collection_Cell
}
