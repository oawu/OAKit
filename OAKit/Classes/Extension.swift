//
//  Extension.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/03/25.
//  Copyright © 2019 www.ioa.tw. All rights reserved.
//

import UIKit
import SafariServices

extension UIColor {
    public static let label:                            UIColor = { if #available(iOS 13, *) { return .label                            } else { return rgba(0, 0, 0, 1) } }()
    public static let secondaryLabel:                   UIColor = { if #available(iOS 13, *) { return .secondaryLabel                   } else { return rgba(60, 60, 67, 0.6) } }()
    public static let tertiaryLabel:                    UIColor = { if #available(iOS 13, *) { return .tertiaryLabel                    } else { return rgba(60, 60, 67, 0.3) } }()
    public static let quaternaryLabel:                  UIColor = { if #available(iOS 13, *) { return .quaternaryLabel                  } else { return rgba(60, 60, 67, 0.18) } }()
    public static let systemFill:                       UIColor = { if #available(iOS 13, *) { return .systemFill                       } else { return rgba(120, 120, 128, 0.2) } }()
    public static let secondarySystemFill:              UIColor = { if #available(iOS 13, *) { return .secondarySystemFill              } else { return rgba(120, 120, 128, 0.16) } }()
    public static let tertiarySystemFill:               UIColor = { if #available(iOS 13, *) { return .tertiarySystemFill               } else { return rgba(118, 118, 128, 0.12) } }()
    public static let quaternarySystemFill:             UIColor = { if #available(iOS 13, *) { return .quaternarySystemFill             } else { return rgba(116, 116, 128, 0.08) } }()
    public static let placeholderText:                  UIColor = { if #available(iOS 13, *) { return .placeholderText                  } else { return rgba(60, 60, 67, 0.3) } }()
    public static let systemBackground:                 UIColor = { if #available(iOS 13, *) { return .systemBackground                 } else { return rgba(255, 255, 255, 1.0) } }()
    public static let secondarySystemBackground:        UIColor = { if #available(iOS 13, *) { return .secondarySystemBackground        } else { return rgba(242, 242, 247, 1.0) } }()
    public static let tertiarySystemBackground:         UIColor = { if #available(iOS 13, *) { return .tertiarySystemBackground         } else { return rgba(255, 255, 255, 1.0) } }()
    public static let systemGroupedBackground:          UIColor = { if #available(iOS 13, *) { return .systemGroupedBackground          } else { return rgba(242, 242, 247, 1.0) } }()
    public static let secondarySystemGroupedBackground: UIColor = { if #available(iOS 13, *) { return .secondarySystemGroupedBackground } else { return rgba(255, 255, 255, 1.0) } }()
    public static let tertiarySystemGroupedBackground:  UIColor = { if #available(iOS 13, *) { return .tertiarySystemGroupedBackground  } else { return rgba(242, 242, 247, 1.0) } }()
    public static let separator:                        UIColor = { if #available(iOS 13, *) { return .separator                        } else { return rgba(60, 60, 67, 0.29) } }()
    public static let opaqueSeparator:                  UIColor = { if #available(iOS 13, *) { return .opaqueSeparator                  } else { return rgba(198, 198, 200, 1.0) } }()
    public static let link:                             UIColor = { if #available(iOS 13, *) { return .link                             } else { return rgba(0, 122, 255, 1.0) } }()
    public static let darkText:                         UIColor = { if #available(iOS 13, *) { return .darkText                         } else { return rgba(0, 0, 0, 1.0) } }()
    public static let lightText:                        UIColor = { if #available(iOS 13, *) { return .lightText                        } else { return rgba(255, 255, 255, 0.6) } }()
    public static let systemBlue:                       UIColor = { if #available(iOS 13, *) { return .systemBlue                       } else { return rgba(0, 122, 255, 1.0) } }()
    public static let systemGreen:                      UIColor = { if #available(iOS 13, *) { return .systemGreen                      } else { return rgba(52, 199, 89, 1.0) } }()
    public static let systemIndigo:                     UIColor = { if #available(iOS 13, *) { return .systemIndigo                     } else { return rgba(88, 86, 214, 1.0) } }()
    public static let systemOrange:                     UIColor = { if #available(iOS 13, *) { return .systemOrange                     } else { return rgba(255, 149, 0, 1.0) } }()
    public static let systemPink:                       UIColor = { if #available(iOS 13, *) { return .systemPink                       } else { return rgba(255, 45, 85, 1.0) } }()
    public static let systemPurple:                     UIColor = { if #available(iOS 13, *) { return .systemPurple                     } else { return rgba(175, 82, 222, 1.0) } }()
    public static let systemRed:                        UIColor = { if #available(iOS 13, *) { return .systemRed                        } else { return rgba(255, 59, 48, 1.0) } }()
    public static let systemTeal:                       UIColor = { if #available(iOS 13, *) { return .systemTeal                       } else { return rgba(90, 200, 250, 1.0) } }()
    public static let systemYellow:                     UIColor = { if #available(iOS 13, *) { return .systemYellow                     } else { return rgba(255, 204, 0, 1.0) } }()
    public static let systemGray:                       UIColor = { if #available(iOS 13, *) { return .systemGray                       } else { return rgba(142, 142, 147, 1.0) } }()
    public static let systemGray2:                      UIColor = { if #available(iOS 13, *) { return .systemGray2                      } else { return rgba(174, 174, 178, 1.0) } }()
    public static let systemGray3:                      UIColor = { if #available(iOS 13, *) { return .systemGray3                      } else { return rgba(199, 199, 204, 1.0) } }()
    public static let systemGray4:                      UIColor = { if #available(iOS 13, *) { return .systemGray4                      } else { return rgba(209, 209, 214, 1.0) } }()
    public static let systemGray5:                      UIColor = { if #available(iOS 13, *) { return .systemGray5                      } else { return rgba(229, 229, 234, 1.0) } }()
    public static let systemGray6:                      UIColor = { if #available(iOS 13, *) { return .systemGray6                      } else { return rgba(242, 242, 247, 1.0) } }()
}

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

extension UITableView {
    public func reg<T: OA.TableCell>(cell: T.Type) { self.register(cell, forCellReuseIdentifier: cell.id) }

    @discardableResult public func gen<T: OA.TableCell>(cell: T.Type, indexPath: IndexPath) -> T { self.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as! T }
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

    @discardableResult public func add(to parent: UIView, enables: [String]) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enables, for: nil) }
    @discardableResult public func add(to parent: UIView, disables: [String]) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disables, for: nil) }

    @discardableResult public func add(to parent: UIView, enables: [String], for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enables, for: view) }
    @discardableResult public func add(to parent: UIView, disables: [String], for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disables, for: view) }

    @discardableResult public func add(to parent: UIView, enable: String) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.split(separator: ";").map { .init($0) }) }
    @discardableResult public func add(to parent: UIView, disable: String) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.split(separator: ";").map { .init($0) }) }

    @discardableResult public func add(to parent: UIView, enable: String, for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, enables: enable.split(separator: ";").map { .init($0) }, for: view) }
    @discardableResult public func add(to parent: UIView, disable: String, for view: UIView) -> [NSLayoutConstraint] { OA.Layout.quick(parent: parent, child: self, disables: disable.split(separator: ";").map { .init($0) }, for: view) }

    @discardableResult public func shadow(_ x: CGFloat, _ y: CGFloat, _ blur: CGFloat, _ color: UIColor, _ opacity: CGFloat? = nil) -> Self {
        self.layer.shadowOpacity = .init(opacity ?? 1)
        self.layer.shadowRadius  = blur / UIScreen.main.scale
        self.layer.shadowOffset  = .init(width: x, height: y)
        self.layer.shadowColor   = color.cgColor
        return self
    }

    @discardableResult public func border(_ width: CGFloat, _ color: UIColor) -> Self {
        self.layer.borderWidth = width / UIScreen.main.scale
        self.layer.borderColor = color.cgColor
        return self
    }
    @discardableResult public func border(_ width: CGFloat, _ color: UIColor, _ debug: Bool) -> Self {
        if debug {
            return self.border(width, color)
        }
        return self
    }

    @discardableResult public func blur(style: UIBlurEffect.Style, radius: CGFloat? = nil) -> UIVisualEffectView {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: style)
        blur.clipsToBounds = true
        blur.layer.cornerRadius = radius ?? self.layer.cornerRadius
        blur.layer.maskedCorners = self.layer.maskedCorners
        blur.add(to: self, enable: "t; l; b; r")
        return blur
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
extension TimeInterval {
    public var datetime: String {
        let format: DateFormatter = .init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from: .init(timeIntervalSince1970: self))
    }
    public static var today: TimeInterval {
        let format: DateFormatter = .init()
        format.dateFormat = "yyyy-MM-dd 00:00:00"
        format.timeZone = .current
        return format.date(from: format.string(from: .init(timeIntervalSince1970: .now)))?.timeIntervalSince1970 ?? .now
    }
    public static var now: TimeInterval { NSDate().timeIntervalSince1970 }
}
extension Date {
    public func format(format str: String) -> String {
        let format: DateFormatter = .init()
        format.dateFormat = str
        return format.string(from: self)
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
extension Int8 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension UInt8 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension Int16 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension UInt16 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension Int32 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension UInt32 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension Int64 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension UInt64 {
    public func format(style: NumberFormatter.Style = .decimal) -> String {
        let format: NumberFormatter = .init()
        format.numberStyle = style
        return format.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
