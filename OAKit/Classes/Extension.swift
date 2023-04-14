//
//  Extension.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import SafariServices

public extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        guard let completion = completion else {
            self.pushViewController(viewController, animated: animated)
            return
        }

        guard animated, let coordinator = transitionCoordinator else {
            return completion()
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    func popViewController(animated: Bool, completion: (() -> ())?) {
        self.popViewController(animated: animated)
        guard let completion = completion else {
            return
        }
        guard animated, let coordinator = transitionCoordinator else {
            return completion()
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}

public extension UITableView {
    func reg<T: OA.TableCell>(cell: T.Type) { self.register(cell, forCellReuseIdentifier: cell.id) }
    @discardableResult func gen<T: OA.TableCell>(cell: T.Type, indexPath: IndexPath) -> T { self.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as! T }
}

public extension UICollectionView {
    func reg<T: OA.CollectionCell>(cell: T.Type) { self.register(cell, forCellWithReuseIdentifier: cell.id) }
    @discardableResult func gen<T: OA.CollectionCell>(cell: T.Type, indexPath: IndexPath) -> T { self.dequeueReusableCell(withReuseIdentifier: cell.id, for: indexPath) as! T }
}

public extension UIAlertController {
    func presentTo(_ vc: UIViewController?, animated: Bool = true, completion: (() -> ())? = nil) {
        guard let vc = vc, !vc.isKind(of: UIAlertController.self) else { return }
        vc.present(self, animated: animated, completion: completion)
    }
    @discardableResult func addAction(_ action: UIAlertAction, isPreferred: Bool = false) -> Self {
        self.addAction(action)
        if isPreferred {
            self.preferredAction = action
        }
        return self
    }
    @discardableResult func addTextField(placeholder: String, configurationHandler: ((UITextField) -> Void)? = nil) -> Self {
        self.addTextField { input in
            input.placeholder = placeholder
            configurationHandler?(input)
        }
        return self
    }
}

public extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont { UIFont(descriptor: fontDescriptor.withSymbolicTraits(traits)!, size: 0) }
    func bold() -> UIFont { self.withTraits(traits: .traitBold) }
    func italic() -> UIFont { self.withTraits(traits: .traitItalic) }
}

public extension UITextField {
    var autoFont: UIFont? {
        set {
            self.font = newValue
            self.adjustsFontForContentSizeCategory = true
        }
        get {
            self.font
        }
    }
}
public extension UITextView {
    var autoFont: UIFont? {
        set {
            self.font = newValue
            self.adjustsFontForContentSizeCategory = true
        }
        get {
            self.font
        }
    }
}
public extension UILabel {
    var textFont: UIFont? {
        set {
            self.font = newValue
            self.adjustsFontForContentSizeCategory = true
        }
        get {
            self.font
        }
    }
}

public extension SFSafariViewController {
    func presentTo(_ vc: UIViewController?, animated: Bool = true, completion: (() -> ())? = nil) {
        guard let vc = vc, !vc.isKind(of: UIAlertController.self) else { return }
        vc.present(self, animated: animated, completion: completion)
    }
}

public extension UIView {
    @discardableResult func add(to parent: UIView) -> OA.Layout { .init(parent: parent, child: self, for: nil) }
    @discardableResult func add(to parent: UIView, for view: UIView) -> OA.Layout { .init(parent: parent, child: self, for: view) }

    @discardableResult func add(to parent: UIView, enables: [String]) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enables, for: nil) }
    @discardableResult func add(to parent: UIView, disables: [String]) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disables, for: nil) }
    @discardableResult func add(to parent: UIView, enables: [String], for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enables, for: view) }
    @discardableResult func add(to parent: UIView, disables: [String], for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disables, for: view) }

    @discardableResult func add(to parent: UIView, enable: String) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.split(separator: ";").map { .init($0) }) }
    @discardableResult func add(to parent: UIView, disable: String) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.split(separator: ";").map { .init($0) }) }
    @discardableResult func add(to parent: UIView, enable: String, for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.split(separator: ";").map { .init($0) }, for: view) }
    @discardableResult func add(to parent: UIView, disable: String, for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.split(separator: ";").map { .init($0) }, for: view) }
    
    @discardableResult func add(to parent: UIView, enable: OA.Layout.QuickFull) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.rawValue.split(separator: ";").map { .init($0) }) }
    @discardableResult func add(to parent: UIView, disable: OA.Layout.QuickFull) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.rawValue.split(separator: ";").map { .init($0) }) }
    @discardableResult func add(to parent: UIView, enable: OA.Layout.QuickFull, for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.rawValue.split(separator: ";").map { .init($0) }, for: view) }
    @discardableResult func add(to parent: UIView, disable: OA.Layout.QuickFull, for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.rawValue.split(separator: ";").map { .init($0) }, for: view) }
    
    @discardableResult func shadow(_ x: CGFloat, _ y: CGFloat, _ blur: CGFloat, _ color: UIColor, _ opacity: CGFloat? = nil) -> Self {
        self.layer.shadowOpacity = .init(opacity ?? 1)
        self.layer.shadowRadius  = blur / UIScreen.main.scale
        self.layer.shadowOffset  = .init(width: x, height: y)
        self.layer.shadowColor   = color.cgColor
        return self
    }

    @discardableResult func border(_ width: CGFloat, _ color: UIColor) -> Self {
        self.layer.borderWidth = width / UIScreen.main.scale
        self.layer.borderColor = color.cgColor
        return self
    }
    @discardableResult func border(_ width: CGFloat, _ color: UIColor, _ debug: Bool) -> Self {
        if debug {
            return self.border(width, color)
        }
        return self
    }

    @discardableResult func blur(style: UIBlurEffect.Style, radius: CGFloat? = nil) -> UIVisualEffectView {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: style)
        blur.clipsToBounds = true
        blur.layer.cornerRadius = radius ?? self.layer.cornerRadius
        blur.layer.maskedCorners = self.layer.maskedCorners
        blur.add(to: self, enable: "t; l; b; r")
        return blur
    }
    
    @discardableResult func removeSubviewsAndConstraints() -> Self {
        self.subviews.forEach { $0.removeSubviewsAndConstraints() }
        
        self.constraints.filter { [weak self] constraint in
            guard let v1 = constraint.firstItem as? UIView, let v2 = self else { return false }
            return v1 != v2
        }.forEach { [weak self] constraint in
            self?.removeConstraint(constraint)
        }

        self.subviews.forEach { $0.removeFromSuperview() }

        return self
    }
}

public extension UIImage {
    func thumbnail(maxSize: Int, minSize: Int, times: Int = 5) -> Data? {
        var maxQuality: CGFloat = 1.0
        var minQuality: CGFloat = 0.0
        var bestData: Data? = nil

        for _ in 1...times {
            let thisQuality = (maxQuality + minQuality) / 2
            guard let data = self.jpegData(compressionQuality: thisQuality) else { return bestData }
            bestData = data

            let thisSize = data.count
            if thisSize > maxSize {
                maxQuality = thisQuality
            } else {
                minQuality = thisQuality
                if thisSize > minSize {
                    return bestData
                }
            }
        }

        return bestData
    }
}
public extension TimeInterval {
    var datetime: String {
        let format: DateFormatter = .init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from: .init(timeIntervalSince1970: self))
    }
    static var today: TimeInterval {
        let format: DateFormatter = .init()
        format.dateFormat = "yyyy-MM-dd 00:00:00"
        format.timeZone = .current
        return format.date(from: format.string(from: .init(timeIntervalSince1970: .now)))?.timeIntervalSince1970 ?? .now
    }
    static var now: TimeInterval { NSDate().timeIntervalSince1970 }
}
public extension Date {
    func format(format str: String) -> String {
        let format: DateFormatter = .init()
        format.dateFormat = str
        return format.string(from: self)
    }
}
public extension Int {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = style
        return fmt.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension UInt {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = style
        return fmt.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension Int8 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension UInt8 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension Int16 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension UInt16 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension Int32 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension UInt32 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension Int64 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
public extension UInt64 {
    func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
