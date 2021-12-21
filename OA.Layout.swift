//
//  OA.Layout.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/21.
//

import Foundation

import UIKit

public extension OA {
    class Layout {
        private let parent: UIView
        private let child: UIView
        private let view: UIView
        private var goal: Any? = nil
        
        private var multiplier: CGFloat = 1
        private var constant: CGFloat = 0
        
        private var childAttr: NSLayoutConstraint.Attribute? = nil
        private var goalAttr: NSLayoutConstraint.Attribute = .notAnAttribute
        private var relation: NSLayoutConstraint.Relation = .equal
        
        public init(parent: UIView, child: UIView, for view: UIView? = nil) {
            self.parent = parent
            self.child = child
            self.goal = parent
            self.view = view ?? parent
        }
        
        public func multiplier(_ multiplier: CGFloat = 1) -> Self {
            self.multiplier = multiplier
            return self
        }

        public func constant(_ constant: CGFloat) -> Self {
            self.constant = constant
            return self
        }

        @discardableResult
        private func join() -> Self {
            guard !self.parent.subviews.contains(self.child) else { return self }
            self.child.translatesAutoresizingMaskIntoConstraints = false
            self.parent.addSubview(self.child)
            return self
        }

        private func create(isActive: Bool) -> NSLayoutConstraint? {
            guard let childAttr = self.childAttr else { return nil }
            self.join()
            let constraint = NSLayoutConstraint(item: self.child, attribute: childAttr, relatedBy: self.relation, toItem: self.goal, attribute: self.goalAttr, multiplier: self.multiplier, constant: self.constant)

            self.view.addConstraint(constraint)
            
            constraint.isActive = isActive
            return constraint
        }

        private func tblrxy(_ attr: NSLayoutConstraint.Attribute, constant: CGFloat? = nil) -> Self {
            if let constant = constant {
                _ = self.constant(constant)
            }
            if self.childAttr == nil {
                self.childAttr = attr
            }
            self.goalAttr = attr

            return self
        }

        private func wh(_ attr: NSLayoutConstraint.Attribute, constant: CGFloat? = nil) -> Self {
            if let constant = constant {
                _ = self.constant(constant)
            }

            if self.childAttr == nil {
                self.childAttr = attr
                self.goal = nil
                self.goalAttr = .notAnAttribute
            } else {
                self.goalAttr = attr
                if self.goal == nil {
                    self.goal = self.parent
                }
            }
            return self
        }
        
        private func relation(_ relation: NSLayoutConstraint.Relation, goal: Any? = nil) -> Self {
            self.relation = relation
            guard let goal = goal else { return self }
            self.goal = goal
            return self
        }

        public func top(_ constant: CGFloat? = nil) -> Self { self.tblrxy(.top, constant: constant) }
        public func left(_ constant: CGFloat? = nil) -> Self { self.tblrxy(.left, constant: constant) }
        public func right(_ constant: CGFloat? = nil) -> Self { self.tblrxy(.right, constant: constant) }
        public func bottom(_ constant: CGFloat? = nil) -> Self { self.tblrxy(.bottom, constant: constant) }
        public func centerX(_ constant: CGFloat? = nil) -> Self { self.tblrxy(.centerX, constant: constant) }
        public func centerY(_ constant: CGFloat? = nil) -> Self { self.tblrxy(.centerY, constant: constant) }

        public func width(_ constant: CGFloat? = nil) -> Self { self.wh(.width, constant: constant) }
        public func height(_ constant: CGFloat? = nil) -> Self { self.wh(.height, constant: constant) }
        
        public func equal(_ goal: Any? = nil) -> Self { self.relation(.equal, goal: goal) }
        public func greaterThanOrEqual(_ goal: Any? = nil) -> Self { self.relation(.greaterThanOrEqual, goal: goal) }
        public func lessThanOrEqual(_ goal: Any? = nil) -> Self { self.relation(.lessThanOrEqual, goal: goal) }
        
        @discardableResult public func enable() -> NSLayoutConstraint? { self.create(isActive: true) }
        @discardableResult public func disable() -> NSLayoutConstraint? { self.create(isActive: false) }
        @discardableResult public func enable(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
            constraint = self.enable()
            return constraint
        }
        @discardableResult public func disable(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? {
            constraint = self.disable()
            return constraint
        }

        public func t(_ constant: CGFloat? = nil) -> Self { self.top(constant) }
        public func l(_ constant: CGFloat? = nil) -> Self { self.left(constant) }
        public func r(_ constant: CGFloat? = nil) -> Self { self.right(constant) }
        public func b(_ constant: CGFloat? = nil) -> Self { self.bottom(constant) }
        public func x(_ constant: CGFloat? = nil) -> Self { self.centerX(constant) }
        public func y(_ constant: CGFloat? = nil) -> Self { self.centerY(constant) }
        
        public func w(_ constant: CGFloat? = nil) -> Self { self.width(constant) }
        public func h(_ constant: CGFloat? = nil) -> Self { self.height(constant) }
        
        public func q(_ goal: Any? = nil) -> Self { self.equal(goal) }
        public func qG(_ goal: Any? = nil) -> Self { self.greaterThanOrEqual(goal) }
        public func qL(_ goal: Any? = nil) -> Self { self.lessThanOrEqual(goal) }
        
        @discardableResult public func e() -> NSLayoutConstraint? { self.enable() }
        @discardableResult public func d() -> NSLayoutConstraint? { self.disable() }
        @discardableResult public func e(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? { self.enable(constraint: &constraint) }
        @discardableResult public func d(constraint: inout NSLayoutConstraint?) -> NSLayoutConstraint? { self.disable(constraint: &constraint) }
    }
}
