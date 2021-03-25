//
//  Extension.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit

extension UIView {
    public func add(to parent: UIView) -> OA.Layout {
        return .init(parent: parent, child: self)
    }

    public func shadow(_ x: CGFloat, _ y: CGFloat, _ blur: CGFloat, _ color: UIColor, _ opacity: CGFloat? = nil) {
        self.layer.shadowOpacity = Float(opacity ?? 1);
        self.layer.shadowRadius  = blur / UIScreen.main.scale;
        self.layer.shadowOffset  = CGSize(width: x, height: y);
        self.layer.shadowColor   = color.cgColor;
    }

    public func border(_ width: CGFloat, _ color: UIColor) {
        self.layer.borderWidth = width / UIScreen.main.scale;
        self.layer.borderColor = color.cgColor;
    }
}
