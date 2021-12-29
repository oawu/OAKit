//
//  Extension.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import SafariServices

extension UINavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        guard let completion = completion else {
            self.pushViewController(viewController, animated: animated)
            return
        }

        guard animated, let coordinator = transitionCoordinator else {
            return completion()
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    public func popViewController(animated: Bool, completion: (() -> ())?) {
        guard let completion = completion else {
            self.popViewController(animated: animated)
            return
        }
        guard animated, let coordinator = transitionCoordinator else {
            return completion()
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}

extension UITableView {
    public func reg<T: OA.Cell>(cell: T.Type) { self.register(cell, forCellReuseIdentifier: cell.id) }

    @discardableResult public func gen<T: OA.Cell>(cell: T.Type, indexPath: IndexPath) -> T { self.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as! T }
}

extension UIAlertController {
    public func presentTo(_ vc: UIViewController?, animated: Bool = true, completion: (() -> ())? = nil) {
        guard let vc = vc, !vc.isKind(of: UIAlertController.self) else { return }
        vc.present(self, animated: animated, completion: completion)
    }

    @discardableResult public func addAction(_ action: UIAlertAction, isPreferred: Bool = false) -> Self {
        self.addAction(action)
        if isPreferred {
            self.preferredAction = action
        }
        return self
    }

    @discardableResult public func addTextField(placeholder: String, configurationHandler: ((UITextField) -> Void)? = nil) -> Self {
        self.addTextField { input in
            input.placeholder = placeholder
            configurationHandler?(input)
        }
        return self
    }
}

extension UIFont {
    public func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont { UIFont(descriptor: fontDescriptor.withSymbolicTraits(traits)!, size: 0) }

    public func bold() -> UIFont { self.withTraits(traits: .traitBold) }

    public func italic() -> UIFont { self.withTraits(traits: .traitItalic) }
}

extension SFSafariViewController {
    public func presentTo(_ vc: UIViewController?, animated: Bool = true, completion: (() -> ())? = nil) {
        guard let vc = vc, !vc.isKind(of: UIAlertController.self) else { return }
        vc.present(self, animated: animated, completion: completion)
    }
}

extension UIView {
    @discardableResult public func add(to parent: UIView) -> OA.Layout { .init(parent: parent, child: self, for: nil) }
    @discardableResult public func add(to parent: UIView, for view: UIView) -> OA.Layout { .init(parent: parent, child: self, for: view) }

    @discardableResult public func add(to parent: UIView, enables: [String]) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enables, for: nil) }
    @discardableResult public func add(to parent: UIView, disables: [String]) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disables, for: nil) }

    @discardableResult public func add(to parent: UIView, enables: [String], for view: UIView) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enables, for: view) }
    @discardableResult public func add(to parent: UIView, disables: [String], for view: UIView) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disables, for: view) }

    @discardableResult public func add(to parent: UIView, enable: String) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.split(separator: ";").map { .init($0) }) }
    @discardableResult public func add(to parent: UIView, disable: String) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.split(separator: ";").map { .init($0) }) }

    @discardableResult public func add(to parent: UIView, enable: String, for view: UIView) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.split(separator: ";").map { .init($0) }, for: view) }
    @discardableResult public func add(to parent: UIView, disable: String, for view: UIView) -> [String: NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.split(separator: ";").map { .init($0) }, for: view) }

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

    @discardableResult public func blur(style: UIBlurEffect.Style) -> UIVisualEffectView {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: style)
        blur.clipsToBounds = true
        blur.layer.cornerRadius = self.layer.cornerRadius
        blur.layer.maskedCorners = self.layer.maskedCorners
        blur.add(to: self).t().e()
        blur.add(to: self).b().e()
        blur.add(to: self).l().e()
        blur.add(to: self).r().e()
        return blur
    }
}
extension Int {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = style
        return fmt.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension UInt {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = style
        return fmt.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension UIImage {
    public func thumbnail(maxSize: Int, minSize: Int, times: Int = 5) -> Data? {
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
