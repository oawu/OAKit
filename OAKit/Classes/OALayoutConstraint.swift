//
//  OALayoutConstraint.swift
//
//  Created by 吳政賢 on 2019/3/19.
//  Copyright © 2019 ioa.tw. All rights reserved.
//

import Foundation
import UIKit

public class OALayoutConstraint {
    public static let wh: [NSLayoutConstraint.Attribute]  = [.width, .height]
    
    private var cView:      Any!                          = nil
    private var multiplier: CGFloat                       = 1
    private var constant:   CGFloat                       = 0
    private var aView:      UIView!                       = nil
    private var bView:      UIView!                       = nil
    private var attr1:      NSLayoutConstraint.Attribute! = nil
    private var attr2:      NSLayoutConstraint.Attribute! = nil
    private var relation:   NSLayoutConstraint.Relation   = .equal
    
    init(_ a: UIView, _ b: UIView) {
        self.aView = a
        self.bView = b
        
        guard !self.aView.subviews.contains(self.bView) else { return }
        
        self.bView.translatesAutoresizingMaskIntoConstraints = false
        self.aView.addSubview(self.bView)
    }
    
    private func toCGFloat<T: Numeric>(_ v: T!) -> CGFloat! {
        guard let val = v else { return nil }
        
        switch val {
        case let n as Float:   return CGFloat(n)
        case let n as Double:  return CGFloat(n)
        case let n as Int:     return CGFloat(n)
        case let n as UInt:    return CGFloat(n)
        case let n as Int8:    return CGFloat(n)
        case let n as UInt8:   return CGFloat(n)
        case let n as Int16:   return CGFloat(n)
        case let n as UInt16:  return CGFloat(n)
        case let n as Int32:   return CGFloat(n)
        case let n as UInt32:  return CGFloat(n)
        case let n as Int64:   return CGFloat(n)
        case let n as UInt64:  return CGFloat(n)
        case let n as CGFloat: return n
        default: return nil
        }
    }
    
    public func right() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .right
        } else {
            self.attr2 = .right
        }
        return self
    }
    
    public func right<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.right() }
        self.constant = constant
        return self.right()
    }
    
    public func left() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .left
        } else {
            self.attr2 = .left
        }
        return self
    }
    
    public func left<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.left() }
        self.constant = constant
        return self.left()
    }
    
    public func top() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .top
        } else {
            self.attr2 = .top
        }
        return self
    }
    
    public func top<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.top() }
        self.constant = constant
        return self.top()
    }
    
    public func bottom() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .bottom
        } else {
            self.attr2 = .bottom
        }
        return self
    }
    
    public func bottom<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.bottom() }
        self.constant = constant
        return self.bottom()
    }
    
    public func width() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .width
        } else {
            self.attr2 = .width
        }
        return self
    }
    
    public func width<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.width() }
        self.constant = constant
        return self.width()
    }
    
    public func height() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .height
        } else {
            self.attr2 = .height
        }
        return self
    }
    
    public func height<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.height() }
        self.constant = constant
        return self.height()
    }
    
    public func centerX() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .centerX
        } else {
            self.attr2 = .centerX
        }
        return self
    }
    
    public func centerX<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.centerX() }
        self.constant = constant
        return self.centerX()
    }
    
    public func centerY() -> OALayoutConstraint {
        if self.attr1 == nil {
            self.attr1 = .centerY
        } else {
            self.attr2 = .centerY
        }
        return self
    }
    
    public func centerY<T: Numeric>(_ c: T! = nil) -> OALayoutConstraint {
        guard let constant = self.toCGFloat(c) else { return self.centerY() }
        self.constant = constant
        return self.centerY()
    }
    
    public func multiplier<T: Numeric>(_ multiplier: T = 1) -> OALayoutConstraint {
        guard let val = self.toCGFloat(multiplier) else { return self }
        self.multiplier = val
        return self
    }
    
    public func constant<T: Numeric>(_ constant: T = 0) -> OALayoutConstraint {
        guard let val = self.toCGFloat(constant) else { return self }
        self.constant = val
        return self
    }
    
    public func eq() -> OALayoutConstraint {
        self.relation = .equal
        return self
    }
    
    public func equal() -> OALayoutConstraint {
        self.relation = .equal
        return self
    }
    
    public func equal(_ who: Any?) -> OALayoutConstraint {
        guard let cView = who else { return self.equal() }
        self.cView = cView
        return self.equal()
    }
    
    public func eq(_ who: Any?) -> OALayoutConstraint {
        guard let cView = who else { return self.equal() }
        self.cView = cView
        return self.equal()
    }
    
    public func greaterThanOrEqual() -> OALayoutConstraint {
        self.relation = .greaterThanOrEqual
        return self
    }
    
    public func greaterThanOrEqual(_ who: Any?) -> OALayoutConstraint {
        guard let cView = who else { return self.greaterThanOrEqual() }
        self.cView = cView
        return self.greaterThanOrEqual()
    }
    
    public func lessThanOrEqual() -> OALayoutConstraint {
        self.relation = .lessThanOrEqual
        return self
    }
    
    public func lessThanOrEqual(_ who: Any?) -> OALayoutConstraint {
        guard let cView = who else { return self.lessThanOrEqual() }
        self.cView = cView
        return self.lessThanOrEqual()
    }
    
    private func create() -> NSLayoutConstraint! {
        guard let bView = self.bView, let attr1 = self.attr1 else { return nil }
        
        let cView: Any! = self.cView == nil && OALayoutConstraint.wh.contains(attr1) ? nil : (self.cView == nil ? self.aView : self.cView)
        let attr2: NSLayoutConstraint.Attribute! = self.cView == nil && OALayoutConstraint.wh.contains(attr1) ? .notAnAttribute : (self.attr2 == nil ? attr1 : self.attr2)
        
        let constraint = NSLayoutConstraint(item: bView, attribute: attr1, relatedBy: self.relation, toItem: cView, attribute: attr2, multiplier: self.multiplier, constant: self.constant)
        self.aView.addConstraint(constraint)
        return constraint
    }
    
    public func enable(_ forConstraint: inout NSLayoutConstraint!) {
        forConstraint = self.enable()
    }
    
    public func disable(_ forConstraint: inout NSLayoutConstraint!) {
        forConstraint = self.disable()
    }
    
    @discardableResult
    public func enable() -> NSLayoutConstraint! {
        guard let constraint = self.create() else { return nil }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func disable() -> NSLayoutConstraint! {
        guard let constraint = self.create() else { return nil }
        constraint.isActive = false
        return constraint
    }
}

extension UIView {
    public func add(_ b: UIView) -> OALayoutConstraint {
        return OALayoutConstraint(self, b)
    }
}
extension UIView {
    public func to(_ a: UIView) -> OALayoutConstraint {
        return OALayoutConstraint(a, self)
    }
}
