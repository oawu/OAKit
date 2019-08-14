//
//  OAShadow.swift
//
//  Created by 吳政賢 on 2019/3/19.
//  Copyright © 2019 ioa.tw. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public  func shadow(_ x: CGFloat, _ y: CGFloat, _ blur: CGFloat, _ color: UIColor, _ opacity: CGFloat! = nil) {
        self.layer.shadowOpacity = opacity == nil ? 1 : Float(opacity);
        self.layer.shadowRadius  = blur / UIScreen.main.scale;
        self.layer.shadowOffset  = CGSize(width: x, height: y);
        self.layer.shadowColor   = color.cgColor;
    }

    public func border(_ width: CGFloat, _ color: UIColor) {
        self.layer.borderWidth = width / UIScreen.main.scale;
        self.layer.borderColor = color.cgColor;
    }
}


