//
//  Protocol.swift
//  OAKit
//
//  Created by 吳政賢 on 2023/04/14.
//

import Foundation

public protocol OA_Table_Cell: UITableViewCell {
    static var id: String { get }
}

public protocol OA_Collection_Cell: UICollectionViewCell {
    static var id: String { get }
}
