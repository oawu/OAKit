//
//  OALayout.swift
//  OAKit
//
//  Created by 吳政賢 on 2020/1/21.
//

import Foundation
import UIKit

public class OALayout {
    private let parent: UIView
    private let child: UIView
    private var goal: Any?
    private var multiplier: CGFloat = 1
    private var constant: CGFloat = 0
    private var childAttr: NSLayoutConstraint.Attribute?
    private var goalAttr: NSLayoutConstraint.Attribute = .notAnAttribute
    private var relation: NSLayoutConstraint.Relation = .equal

    public init(parent: UIView, child: UIView) {
        self.parent = parent
        self.child = child
        self.goal = parent
    }

    private func toCGFloat<T: Numeric>(_ v: T?) -> CGFloat? {
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
    
    @discardableResult
    private func join() -> Self {
        guard !self.parent.subviews.contains(self.child) else { return self }

        self.child.translatesAutoresizingMaskIntoConstraints = false
        self.parent.addSubview(self.child)
        return self
    }

    private func create() -> NSLayoutConstraint? {
        guard let childAttr = self.childAttr else {
            return nil
        }
        
        self.join()

        let constraint = NSLayoutConstraint(
            item: self.child,
            attribute: childAttr,
            relatedBy: self.relation,
            toItem: self.goal,
            attribute: self.goalAttr,
            multiplier: self.multiplier,
            constant: self.constant)
        
        constraint.isActive = false

        self.parent.addConstraint(constraint)
        return constraint
    }
    
    public func goal(_ goal: Any? = nil) -> Self {
        guard let goal = goal else { return self }
        self.goal = goal
        return self
    }
    
    public func equal(_ goal: Any? = nil) -> Self {
        self.relation = .equal
        return self.goal(goal)
    }
    public func greaterThanOrEqual(_ goal: Any? = nil) -> Self {
        self.relation = .greaterThanOrEqual
        return self.goal(goal)
    }
    public func lessThanOrEqual(_ goal: Any? = nil) -> Self {
        self.relation = .lessThanOrEqual
        return self.goal(goal)
    }

    public func multiplier<T: Numeric>(_ multiplier: T? = 1) -> Self {
        guard let multiplier = self.toCGFloat(multiplier) else { return self }
        self.multiplier = multiplier
        return self
    }
    public func constant<T: Numeric>(_ constant: T? = 0) -> Self {
        guard let constant = self.toCGFloat(constant) else { return self }
        self.constant = constant
        return self
    }
    
    public func top() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .top
        } else {
            self.childAttr = .top
            self.goalAttr = .top
        }
        return self
    }
    public func left() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .left
        } else {
            self.childAttr = .left
            self.goalAttr = .left
        }
        return self
    }
    public func right() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .right
        } else {
            self.childAttr = .right
            self.goalAttr = .right
        }
        return self
    }
    public func bottom() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .bottom
        } else {
            self.childAttr = .bottom
            self.goalAttr = .bottom
        }
        return self
    }
    public func centerX() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .centerX
        } else {
            self.childAttr = .centerX
            self.goalAttr = .centerX
        }
        return self
    }
    public func centerY() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .centerY
        } else {
            self.childAttr = .centerY
            self.goalAttr = .centerY
        }
        return self
    }
    public func width() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .width
            guard self.goal == nil else { return self }
            self.goal = parent
        } else {
            self.childAttr = .width
            self.goal = nil
            self.goalAttr = .notAnAttribute
        }
        return self
    }
    public func height() -> Self {
        if let _ = self.childAttr {
            self.goalAttr = .height
            guard self.goal == nil else { return self }
            self.goal = parent
        } else {
            self.childAttr = .height
            self.goal = nil
            self.goalAttr = .notAnAttribute
        }
        return self
    }
    
    public func top<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).top()
    }
    public func left<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).left()
    }
    public func right<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).right()
    }
    public func bottom<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).bottom()
    }
    public func centerX<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).centerX()
    }
    public func centerY<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).centerY()
    }
    public func width<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).width()
    }
    public func height<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.constant(constant).height()
    }
    
    public func eq(_ goal: Any? = nil) -> Self {
        return self.equal(goal)
    }
    public func gEq(_ goal: Any? = nil) -> Self {
        return self.greaterThanOrEqual(goal)
    }
    public func lEq(_ goal: Any? = nil) -> Self {
        return self.lessThanOrEqual(goal)
    }

    public func m<T: Numeric>(_ multiplier: T = 1) -> Self {
        return self.multiplier(multiplier)
    }
    public func c<T: Numeric>(_ constant: T = 0) -> Self {
        return self.constant(constant)
    }

    public func t() -> Self {
        return top()
    }
    public func l() -> Self {
        return self.left()
    }
    public func r() -> Self {
        return self.right()
    }
    public func b() -> Self {
        return self.bottom()
    }
    public func x() -> Self {
        return self.centerX()
    }
    public func y() -> Self {
        return self.centerY()
    }
    public func w() -> Self {
        return self.width()
    }
    public func h() -> Self {
        return self.height()
    }
    
    public func t<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.top(constant)
    }
    public func l<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.left(constant)
    }
    public func r<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.right(constant)
    }
    public func b<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.bottom(constant)
    }
    public func x<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.centerX(constant)
    }
    public func y<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.centerY(constant)
    }
    public func w<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.width(constant)
    }
    public func h<T: Numeric>(_ constant: T? = nil) -> Self {
        return self.height(constant)
    }
    
    @discardableResult
    public func enable() -> NSLayoutConstraint? {
        guard let constraint = self.create() else { return nil }
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    public func disable() -> NSLayoutConstraint? {
        guard let constraint = self.create() else { return nil }
        constraint.isActive = false
        return constraint
    }
    @discardableResult
    public func enable(_ constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
        constraint = self.enable()
        return constraint
    }
    @discardableResult
    public func disable(_ constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
        constraint = self.disable()
        return constraint
    }
    
    @discardableResult
    public func e() -> NSLayoutConstraint? {
        return self.enable()
    }
    @discardableResult
    public func d() -> NSLayoutConstraint? {
        return self.disable()
    }
    @discardableResult
    public func e(_ constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
        constraint = self.enable()
        return constraint
    }
    @discardableResult
    public func d(_ constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
        constraint = self.disable()
        return constraint
    }
}

extension UIView {
    public func add(_ child: UIView) -> OALayout {
        return OALayout(parent: self, child: child)
    }
    
    public func to(_ parent: UIView) -> OALayout {
        return OALayout(parent: parent, child: self)
    }
    
    public func add(to parent: UIView) -> OALayout {
        return OALayout(parent: parent, child: self)
    }
    
    public  func shadow(_ x: CGFloat, _ y: CGFloat, _ blur: CGFloat, _ color: UIColor, _ opacity: CGFloat? = nil) {
        self.layer.shadowOpacity = Float(opacity ?? 1);
        self.layer.shadowRadius  = blur / UIScreen.main.scale;
        self.layer.shadowOffset  = CGSize(width: x, height: y);
        self.layer.shadowColor   = color.cgColor;
    }

    public func border(_ width: CGFloat, _ color: UIColor) {
        self.layer.borderWidth = width / UIScreen.main.scale;
        self.layer.borderColor = color.cgColor;
    }
    
    public func border(_ width: CGFloat, _ color: UIColor, _ debug: Bool) {
        guard debug else { return }

        self.layer.borderWidth = width / UIScreen.main.scale;
        self.layer.borderColor = color.cgColor;
    }
}
