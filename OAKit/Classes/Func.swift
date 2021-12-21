//
//  Func.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import Foundation
import UIKit

@discardableResult public func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor { .init(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a)) }
@discardableResult public func setTimeout(second: TimeInterval, block: @escaping () -> (), key: String = "", replace: Bool = false) -> Foundation.Timer { OA.Timer.delay(key: key, second: second, replace: replace, repeats: false, block: block) }
@discardableResult public func setInterval(second: TimeInterval, block: @escaping () -> (), key: String = "", replace: Bool = false) -> Foundation.Timer { OA.Timer.delay(key: key, second: second, replace: replace, repeats: true, block: block) }
