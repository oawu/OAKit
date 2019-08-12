//
//  OABorder.swift
//
//  Created by 吳政賢 on 2019/3/19.
//  Copyright © 2019 ioa.tw. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
//    test
    public func border(_ width: CGFloat, _ color: UIColor) {
        self.layer.borderWidth = width / UIScreen.main.scale;
        self.layer.borderColor = color.cgColor;
    }
}
