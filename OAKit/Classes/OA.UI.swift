//
//  OA.UI.swift
//  OAKit
//
//  Created by 吳政賢 on 2022/3/12.
//

import UIKit

@objc public protocol OA_UI_Action_Delegate {
    func click(_ sender: UIButton?) -> ()
}

public protocol OA_UI_Item_Delegate {
   var title: String { get }
   var subtitle: String { get }
   static func == (lhs: Self, rhs: Self) -> Bool
}

public extension OA {
    enum UI {
        public enum Delegate {
            public typealias Item = OA_UI_Item_Delegate
            public typealias Action = OA_UI_Action_Delegate
        }

        public static var debug: Bool = false
        public typealias Closure = () -> ()
        
        public enum Parse {
            public enum UFloat {
                private static func de0(strs: [String], re: Bool) -> [String] {
                    var nums: [String] = []
                    var has: Bool = false
                    for str in strs {
                        if str == "." {
                            if !has {
                                nums.append(str)
                                has = true
                            }
                        } else if let n = UInt8(str) {
                            if n != 0 {
                                nums.append(str)
                            } else if !nums.isEmpty {
                                nums.append(str)
                            }
                        }
                    }
                    return !re || has ? nums : strs
                }
                public static func done(str: String) -> String {
                    var strs: [String] = Array(Self.de0(strs: Array(Self.de0(strs: str.trimmingCharacters(in: .whitespacesAndNewlines).map { .init($0) }, re: false).reversed()), re: true).reversed())
                    if strs.isEmpty { return "0" }
                    if strs.first! == "." {
                        strs.insert("0", at: 0)
                    }
                    if strs.last! == "." {
                        strs.removeLast()
                    }
                    return strs.joined()
                }
                public static func ing(str: String) -> String {
                    let strs = Self.de0(strs: str.map { .init($0) }, re: false)
                    if strs.isEmpty { return "0" }
                    if strs.first! == "." { return "0\(strs.joined())"}
                    return strs.joined()
                }
            }
            public enum `UInt` {
                private static func de0(strs: [String]) -> [String] {
                    var nums: [String] = []
                    for str in strs {
                        if let n = UInt8(str) {
                            if n != 0 {
                                nums.append(str)
                            } else if !nums.isEmpty {
                                nums.append(str)
                            }
                        }
                    }
                    return nums
                }

                public static func done(str: String) -> String {
                    let strs = Self.de0(strs: str.trimmingCharacters(in: .whitespacesAndNewlines).map { .init($0) })
                    if strs.isEmpty { return "0" }
                    return strs.joined()
                }
                public static func ing(str: String) -> String {
                    let strs = Self.de0(strs: str.trimmingCharacters(in: .whitespacesAndNewlines).map { .init($0) })
                    if strs.isEmpty { return "" }
                    return strs.joined()
                }
            }
        }

        public enum Action {
            public class Button: NSObject, OA_UI_Action_Delegate {
                private var _click: Closure? = nil

                public init(onClick click: Closure? = nil) {
                    self._click = click
                }
                @objc public func click(_ sender: UIButton? = nil) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self._click?()
                }
                @discardableResult public func on(click: @escaping Closure) -> Self {
                    self._click = click
                    return self
                }
            }

            public class TextInput: NSObject, OA_UI_Action_Delegate, UITextFieldDelegate, UITextViewDelegate {
                private var _icon: Closure? = nil
                private var _focus: Closure? = nil
                private var _change: Closure? = nil
                private var _blur: Closure? = nil

                public init(onClickIcon: Closure? = nil, onFocus: Closure? = nil, onChange: Closure? = nil, onBlur: Closure? = nil) {
                    self._icon = onClickIcon
                    self._focus = onFocus
                    self._change = onChange
                    self._blur = onBlur
                }
                @objc public func click(_ sender: UIButton? = nil) {
                    switch sender?.tag ?? 0 {
                    case 1:
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        self._focus?()
                    case 2:
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        self._icon?()
                    default: ()
                    }
                }
                @discardableResult public func on(clickIcon: @escaping Closure) -> Self {
                    self._icon = clickIcon
                    return self
                }

                @discardableResult public func on(focus: @escaping Closure) -> Self {
                    self._focus = focus
                    return self
                }
                @discardableResult public func on(change: @escaping Closure) -> Self {
                    self._change = change
                    return self
                }
                @discardableResult public func on(blur: @escaping Closure) -> Self {
                    self._blur = blur
                    return self
                }

                @objc func editingChanged(_ sender: UITextField? = nil) {
                    self._change?()
                }
                public func textFieldDidEndEditing(_ textField: UITextField) {
                    self._blur?()
                }
                public func textViewDidEndEditing(_ textView: UITextView) {
                    self._blur?()
                }
                public func textViewDidChange(_ textView: UITextView) {
                    self._change?()
                }
            }

            public class Check<C: OA_UI_Item_Delegate>: NSObject, OA_UI_Action_Delegate {
                private var _tags: [Int: C] = [:]
                private var _click: ((C?) -> ())? = nil
                public init(onClick click: ((C?) -> ())? = nil) {
                    self._click = click
                }
                @discardableResult public func tag(_ tag: Int, val: C) -> Self {
                    self._tags[tag] = val
                    return self
                }
                @discardableResult public func on(click: @escaping (C?) -> ()) -> Self {
                    self._click = click
                    return self
                }

                @objc public func click(_ sender: UIButton? = nil) {
                    let i = sender?.tag ?? 0
                    guard let click = self._click else { return }

                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    click(self._tags[i])
                }
            }
        }
        @discardableResult public static func loading(to base: UIView, enable: String = "t; r; l; b; x; y") -> UIView {
            let view: UIView = .init()
            view.isHidden = false
            if #available(iOS 13.0, *) {
                view.backgroundColor = .secondarySystemBackground
            } else {
                view.backgroundColor = rgba(242, 242, 247, 1.0)
            }
            view.add(to: base, enable: enable)

            let base: UIView = .init()
            base.add(to: view, enable: "x; b=y")

            let spinner: UIActivityIndicatorView = .init()
            if #available(iOS 13.0, *) {
                spinner.style = .medium
            } else {
                spinner.style = .gray
            }
            spinner.startAnimating()
            spinner.add(to: base, enable: "l; t")

            let label: UILabel = .init()
            label.textColor = .systemGray
            label.text = "載入中.."
            label.textAlignment = .center
            label.adjustsFontForContentSizeCategory = true
            label.font = .preferredFont(forTextStyle: .body)
            label.add(to: base, enable: "r")
            label.add(to: base).y().q(spinner).e()
            label.add(to: base).l().q(spinner).r(8).e()

            return view
        }
        @discardableResult public static func button<T: OA_UI_Action_Delegate>(to view: UIView, target: (action: T?, tag: Int)? = nil, enable: String = "l; r; t; b") -> UIButton {
            let button: UIButton = .init()
            button.add(to: view, enable: enable)
            if let target = target, let action = target.action {
                button.tag = target.tag
                button.addTarget(action, action: #selector(action.click(_:)), for: .touchUpInside)
            }
            if OA.UI.debug {
                button.border(1, .red)
                button.backgroundColor = rgba(0, 0, 255, 0.2)
            }
            return button
        }
        @discardableResult public static func button<T: OA_UI_Action_Delegate>(to view: UIView, action: T? = nil, enable: String = "l; r; t; b") -> UIButton { Self.button(to: view, target: (action: action, tag: 0), enable: enable) }
        
        @discardableResult public static func section(to base: UIView, title: String = "", bgColor color: UIColor? = nil) -> (cell: UIView, header: UILabel?) {
            let bgColor: UIColor
            if let color = color {
                bgColor = color
            } else {
                if #available(iOS 13.0, *) {
                    bgColor = .systemBackground
                } else {
                    bgColor = rgba(255, 255, 255, 1.0)
                }
            }
            
            let cell: UIView = .init()
            if #available(iOS 13.0, *) {
                cell.border(1, .separator.withAlphaComponent(0.16))
            } else {
                cell.border(1, rgba(60, 60, 67, 0.29).withAlphaComponent(0.16))
            }
            cell.layer.cornerRadius = 16.0
            cell.backgroundColor = bgColor
            cell.add(to: base, enable: "x; l; b; r")

            let space: CGFloat = 20.0
                
            let header: UILabel?
            if !title.isEmpty {
                header = .init()
                header?.border(1, .red, OA.UI.debug)
                header?.text = title
                if #available(iOS 13.0, *) {
                    header?.textColor = .secondaryLabel
                } else {
                    header?.textColor = rgba(60, 60, 67, 0.6)
                }
                header?.adjustsFontForContentSizeCategory = true
                header?.font = .preferredFont(forTextStyle: .caption1)
                header?.add(to: base, enable: "x; t=\(4.0 + space); l=16; r=-16")
            } else {
                header = nil
            }

            if let header = header {
                cell.add(to: base).t().q(header).b(4).e()
            } else {
                cell.add(to: base, enable: "t=\(space)")
            }

            return (cell: cell, header: header)
        }
        
        @discardableResult public static func scroll(to base: UIView, type: OA.UI.Stack.`Type` = .vertical, padding: UIEdgeInsets = .init(top: 4, left: 16, bottom: 24, right: 16), enable: String = "t; l; b; r; x; y") -> OA.UI.Stack {
            OA.UI.Stack(ui: { () -> UIScrollView in
                let scroll: UIScrollView = .init()
                scroll.contentInsetAdjustmentBehavior = .always
                return scroll
            }(), type: type, padding: padding).add(to: base, enable: enable)
        }

        public class Unit: NSObject {
            private let _body: UIView
            private let _frame: UIView
            private var _isShow: Bool?
            private var _margin: UIEdgeInsets
            private var _padding: UIEdgeInsets
            private let _layFrameBody: (t: NSLayoutConstraint?, b: NSLayoutConstraint?, l: NSLayoutConstraint?, r: NSLayoutConstraint?)

            private lazy var _parent: Stack? = nil
            private lazy var _next: Unit? = nil
            private lazy var _prev: Unit? = nil
            
            private lazy var _anis: [UIViewPropertyAnimator] = []
            private lazy var _width: (lay: NSLayoutConstraint?, val: CGFloat?) = (lay: nil, val: nil)
            private lazy var _height: (lay: NSLayoutConstraint?, val: CGFloat?) = (lay: nil, val: nil)
            private lazy var _zLay: (w: NSLayoutConstraint?, h: NSLayoutConstraint?) = (w: nil, h: nil)

            private lazy var _layFrameParent: (x: NSLayoutConstraint?, y: NSLayoutConstraint?, w: NSLayoutConstraint?, h: NSLayoutConstraint?, t: NSLayoutConstraint?, b: NSLayoutConstraint?, l: NSLayoutConstraint?, r: NSLayoutConstraint?) = (x: nil, y: nil, w: nil, h: nil, t: nil, b: nil, l: nil, r: nil)
            private lazy var _onShows: [Closure] = []
            private lazy var _onHides: [Closure] = []
            private lazy var _onAdds: [Closure] = []

            public var body: UIView { self._body }
            public var isShow: Bool? { self._isShow }
            public var parent: Stack? { self._parent }
            public var next: Unit? { self._next }
            public var prev: Unit? { self._prev }

            public var margin: UIEdgeInsets { self._margin }
            public var padding: UIEdgeInsets { self._padding }
            public var frame: UIView { self._isShow == nil ? self._body : self._frame }

            public init(ui body: UIView, padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, isShow: Bool? = true) {
                let frame: UIView = .init()

                body.border(4, .green, OA.UI.debug)
                frame.border(4, .blue, OA.UI.debug)

                self._body = body
                self._frame = frame
                self._isShow = isShow
                self._margin = margin
                self._padding = padding

                self._layFrameBody.t = body.add(to: frame).t(OA.UI.debug ? 5 : 0).e()
                self._layFrameBody.b = body.add(to: frame).b(OA.UI.debug ? -5 : 0).e()
                self._layFrameBody.l = body.add(to: frame).l(OA.UI.debug ? 5 : 0).e()
                self._layFrameBody.r = body.add(to: frame).r(OA.UI.debug ? -5 : 0).e()

                super.init()
            }

            @discardableResult public func on(show: @escaping Closure) -> Self {
                self._onShows.append(show)
                return self
            }
            @discardableResult public func on(hide: @escaping Closure) -> Self {
                self._onHides.append(hide)
                return self
            }
            @discardableResult public func on(add: @escaping Closure) -> Self {
                self._onAdds.append(add)
                return self
            }
            @discardableResult public func on<T: Unit>(show: @escaping (T?) -> ()) -> Self { self.on(show: { show(self as? T) }) }
            @discardableResult public func on<T: Unit>(hide: @escaping (T?) -> ()) -> Self { self.on(hide: { hide(self as? T) }) }
            @discardableResult public func on<T: Unit>(add: @escaping (T?) -> ()) -> Self { self.on(add: { add(self as? T) }) }

            @discardableResult public func toggle(animated: Bool = true, completion: Closure? = nil) -> Self {
                guard let isShow = self.isShow else {
                    completion?()
                    return self
                }

                return isShow
                    ? self.hide(animated: animated, completion: completion)
                    : self.show(animated: animated, completion: completion)
            }
            @discardableResult public func hide(animated: Bool = true, completion: Closure? = nil) -> Self {
                guard let parent = self.parent, self.isShow != nil, !self.frame.isHidden else {
                    completion?()
                    return self
                }

                self._anis.forEach { $0.stopAnimation(true) }

                guard animated else {

                    self.frame.alpha = 0
                    self.frame.isHidden = true
                    self.frame.clipsToBounds = true
                    self.frame.layoutIfNeeded()

                    self._lays(parent: parent, false)

                    parent.body.layoutIfNeeded()
                    self._isShow = false
                    completion?()
                    self._onHides.forEach { $0() }

                    return self
                }

                self._lays(parent: parent, false)

                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: {
                    self.frame.alpha = 0
                    self.frame.layoutIfNeeded()
                    parent.body.layoutIfNeeded()
                }, completion: { _ in
                    self.frame.clipsToBounds = true
                    self.frame.isHidden = true
                    self._isShow = false
                    completion?()
                    self._onHides.forEach { $0() }
                })

                return self
            }
            @discardableResult public func show(animated: Bool = true, completion: Closure? = nil) -> Self {
                guard let parent = self.parent, self.isShow != nil, self.frame.isHidden else {
                    completion?()
                    return self
                }

                self._anis.forEach { $0.stopAnimation(true) }

                guard animated else {
                    self._lays(parent: parent, true)
                    self.frame.layoutIfNeeded()
                    self.frame.clipsToBounds = false
                    self.frame.isHidden = false
                    self.frame.alpha = 1
                    parent.body.layoutIfNeeded()
                    self._isShow = true
                    completion?()
                    self._onShows.forEach { $0() }
                    return self
                }

                self._lays(parent: parent, true)
                self.frame.clipsToBounds = true
                self.frame.isHidden = false

                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: {
                    self.frame.alpha = 1
                    self.frame.layoutIfNeeded()
                    parent.body.layoutIfNeeded()
                }, completion: { _ in
                    self._isShow = true
                    completion?()
                    self._onShows.forEach { $0() }
                })

                return self
            }
            @discardableResult public func padding(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, animated: Bool = false, completion: Closure? = nil) -> Self {
                var f: Bool = false
                var l: Bool = false
                var a: Bool = false
                if let top = top {
                    self._padding.top = top
                    if let stock = self as? Stack {
                        switch stock.type {
                        case .auto:
                            f = true
                            stock.children.first?.reloadT().reloadH()

                        case .vertical:
                            f = true
                            stock.children.first?.reloadT()

                        case .horizontal:
                            a = true
                            stock.children.forEach { $0.reloadT().reloadH() }
                        }
                    }
                }
                if let left = left {
                    self._padding.left = left
                    if let stock = self as? Stack {
                        switch stock.type {
                        case .auto:
                            f = true
                            stock.children.first?.reloadL().reloadW()

                        case .vertical:
                            a = true
                            stock.children.forEach { $0.reloadL().reloadW() }

                        case .horizontal:
                            f = true
                            stock.children.first?.reloadL()
                        }
                    }
                }
                if let bottom = bottom {
                    self._padding.bottom = bottom
                    if let stock = self as? Stack {
                        switch stock.type {
                        case .auto:
                            l = true
                            stock.children.last?.reloadB().reloadH()

                        case .vertical:
                            l = true
                            stock.children.last?.reloadB()

                        case .horizontal:
                            a = true
                            stock.children.forEach { $0.reloadB().reloadH() }
                        }
                    }
                }
                if let right = right {
                    self._padding.right = right
                    if let stock = self as? Stack {
                        switch stock.type {
                        case .auto:
                            l = true
                            stock.children.last?.reloadR().reloadW()

                        case .vertical:
                            a = true
                            stock.children.forEach { $0.reloadR().reloadW() }

                        case .horizontal:
                            l = true
                            stock.children.last?.reloadR()
                        }
                    }
                }

                guard let stock = self as? Stack else {
                    completion?()
                    return self
                }
                guard animated else {
                    if a { stock.children.forEach { $0.frame.layoutIfNeeded() } }
                    else if f { stock.children.first?.frame.layoutIfNeeded() }
                    else if l { stock.children.last?.frame.layoutIfNeeded() }
                    completion?()
                    return self
                }

                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: {
                    if a { stock.children.forEach { $0.frame.layoutIfNeeded() } }
                    else if f { stock.children.first?.frame.layoutIfNeeded() }
                    else if l { stock.children.last?.frame.layoutIfNeeded() }
                }, completion: { _ in
                    completion?()
                })

                return self
            }
            @discardableResult public func margin(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, animated: Bool = false, completion: Closure? = nil) -> Self {
                var has: Bool = false
                if let top = top {
                    self._margin.top = top
                    switch self.parent?.type {
                    case .none: ()
                    case .vertical: self.reloadT()
                    case .auto: self.reloadT().reloadH()
                    case .horizontal: self.reloadT().reloadH()
                    }
                    has = true
                }
                if let left = left {
                    self._margin.left = left
                    switch self.parent?.type {
                    case .none: ()
                    case .horizontal: self.reloadL()
                    case .auto: self.reloadL().reloadW()
                    case .vertical: self.reloadL().reloadW()
                    }
                    has = true
                }
                if let bottom = bottom {
                    self._margin.bottom = bottom
                    switch self.parent?.type {
                    case .none: ()
                    case .vertical: self.reloadB()
                    case .auto: self.reloadB().reloadH()
                    case .horizontal: self.reloadB().reloadH()
                    }
                    has = true
                }
                if let right = right {
                    self._margin.right = right
                    switch self.parent?.type {
                    case .none: ()
                    case .horizontal: self.reloadR()
                    case .auto: self.reloadR().reloadW()
                    case .vertical: self.reloadR().reloadW()
                    }
                    has = true
                }

                guard has else { return self }

                guard animated else {
                    self.frame.layoutIfNeeded()
                    self.parent?.body.layoutIfNeeded()
                    completion?()
                    return self
                }
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: {
                    self.frame.layoutIfNeeded()
                    self.parent?.body.layoutIfNeeded()
                }, completion: { _ in
                    completion?()
                })

                return self
            }

            @discardableResult public func add() -> Self {
                self._onAdds.forEach { $0() }
                return self
            }

            @discardableResult public func toggle(animated: Bool = true, completion: @escaping (Self) -> ()) -> Self { self.toggle(animated: animated) { completion(self) } }
            @discardableResult public func hide(animated: Bool = true, completion: @escaping (Self) -> ()) -> Self { self.hide(animated: animated) { completion(self) } }
            @discardableResult public func show(animated: Bool = true, completion: @escaping (Self) -> ()) -> Self { self.show(animated: animated) { completion(self) } }
            @discardableResult public func padding(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, animated: Bool = false, completion: @escaping (Self) -> ()) -> Self { self.padding(top: top, left: left, bottom: bottom, right: right) { completion(self) } }
            @discardableResult public func margin(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, animated: Bool = false, completion: @escaping (Self) -> ()) -> Self { self.margin(top: top, left: left, bottom: bottom, right: right) { completion(self) } }

            @discardableResult public func reloadX() -> Self {
                guard let parent = self.parent else { return self }

                if let x = self._layFrameParent.x {
                    x.constant = 0
                } else {
                    self._layFrameParent.x = self.frame.add(to: parent.body).x(0).d()
                }

                return self
            }
            @discardableResult public func reloadY() -> Self {
                guard let parent = self.parent else { return self }

                if let y = self._layFrameParent.y {
                    y.constant = 0
                } else {
                    self._layFrameParent.y = self.frame.add(to: parent.body).y(0).d()
                }

                return self
            }
            @discardableResult public func reloadT() -> Self {
                guard let parent = self.parent else { return self }

                if let prev = self._prev, parent.type == .vertical {
                    let val = prev.margin.bottom + self.margin.top
                    if let t = self._layFrameParent.t {
                        t.constant = val
                    } else {
                        self._layFrameParent.t = self.frame.add(to: parent.body).t().q(prev.frame).b(val).e()
                    }
                } else {
                    let val = parent.padding.top + self.margin.top
                    if let t = self._layFrameParent.t {
                        t.constant = val
                    } else {
                        self._layFrameParent.t = self.frame.add(to: parent.body).t(val).e()
                    }
                }

                return self
            }
            @discardableResult public func reloadW() -> Self {
                guard let parent = self.parent else { return self }
                let val = (parent.padding.left + self.margin.left) + (parent.padding.right + self.margin.right)

                if let w = self._layFrameParent.w {
                    w.constant = -val
                } else {
                    self._layFrameParent.w = self.frame.add(to: parent.body).w().q(parent.body).w(-val).e()
                }

                return self
            }
            @discardableResult public func reloadH() -> Self {
                guard let parent = self.parent else { return self }
                let val = (parent.padding.top + self.margin.top) + (parent.padding.bottom + self.margin.bottom)

                if let h = self._layFrameParent.h {
                    h.constant = -val
                } else {
                    self._layFrameParent.h = self.frame.add(to: parent.body).h().q(parent.body).h(-val).e()
                }

                return self
            }
            @discardableResult public func reloadL() -> Self {
                guard let parent = self.parent else { return self }

                if let prev = self._prev, parent.type == .horizontal {
                    let val = prev.margin.right + self.margin.left
                    if let l = self._layFrameParent.l {
                        l.constant = val
                    } else {
                        self._layFrameParent.l = self.frame.add(to: parent.body).l().q(prev.frame).r(val).e()
                    }
                } else {
                    let val = parent.padding.left + self.margin.left
                    if let l = self._layFrameParent.l {
                        l.constant = val
                    } else {
                        self._layFrameParent.l = self.frame.add(to: parent.body).l(val).e()
                    }
                }

                return self
            }
            @discardableResult public func reloadB() -> Self {
                guard let parent = self.parent else { return self }

                if let next = self._next, parent.type == .vertical {
                    next.reloadT().reloadH()
                } else {
                    let val = -(parent.padding.bottom + self.margin.bottom)
                    if let b = self._layFrameParent.b {
                        b.constant = val
                    } else {
                        self._layFrameParent.b = self.frame.add(to: parent.body).b(val).e()
                    }
                }

                return self
            }
            @discardableResult public func reloadR() -> Self {
                guard let parent = self.parent else { return self }

                let val = parent.padding.right + self.margin.right

                if let next = self._next, parent.type == .horizontal {
                    next.reloadL().reloadW()
                } else {
                    if let r = self._layFrameParent.r {
                        r.constant = -val
                    } else {
                        self._layFrameParent.r = self.frame.add(to: parent.body).r(-(val)).e()
                    }
                }

                return self
            }

            @discardableResult public func width(_ val: CGFloat? = nil) -> Self {
                let value: CGFloat
                if let val = val {
                    value = val
                } else if let val = self._width.val {
                    value = val
                } else {
                    return self
                }

                if let lay = self._width.lay {
                    lay.constant = value
                } else if let parent = self.parent {
                    self._width.lay = parent.type == .horizontal ? self.frame.add(to: parent.body).w(value).e() : self.frame.add(to: parent.body).w(value).d()
                } else {
                    self._width.val = value
                }

                return self
            }
            @discardableResult public func height(_ val: CGFloat? = nil) -> Self {
                let value: CGFloat
                if let val = val {
                    value = val
                } else if let val = self._height.val {
                    value = val
                } else {
                    return self
                }

                if let lay = self._height.lay {
                    lay.constant = value
                } else if let parent = self.parent {
                    self._height.lay = parent.type == .vertical ? self.frame.add(to: parent.body).h(value).e() : self.frame.add(to: parent.body).h(value).d()
                } else {
                    self._height.val = value
                }

                return self
            }

            @discardableResult private func zH(parent: Unit, enable: Bool) -> Self {
                if enable {
                    if let h = self._zLay.h {
                        h.isActive = true
                    } else {
                        self._zLay.h = self.frame.add(to: parent.body).h(0).e()
                    }
                } else {
                    if let h = self._zLay.h {
                        h.isActive = false
                    } else {
                        self._zLay.h = self.frame.add(to: parent.body).h(0).d()
                    }
                }

                return self
            }
            @discardableResult private func zW(parent: Unit, enable: Bool) -> Self {
                if enable {
                    if let w = self._zLay.w {
                        w.isActive = true
                    } else {
                        self._zLay.w = self.frame.add(to: parent.body).w(0).e()
                    }

                } else {
                    if let w = self._zLay.w {
                        w.isActive = false
                    } else {
                        self._zLay.w = self.frame.add(to: parent.body).w(0).d()
                    }
                }

                return self
            }

            @discardableResult public func add(to view: UIView, enable: String = "t; l; b; r; x; y") -> Self {
                self._isShow = nil
                self.frame.add(to: view, enable: enable)
                return self
            }
            @discardableResult public func add(to parent: Stack) -> Self {
                guard self._parent == nil else { return self }
                self._parent = parent

                parent.append(self)

                return self
            }
            @discardableResult private func _prev(_ prev: Unit) -> Self {
                if self._prev != nil { return self }
                self._prev = prev
                return self
            }
            @discardableResult internal func next(_ next: Unit) -> Self {
                if self._next != nil { return self }
                self._next = next

                if let parent = self.parent {
                    switch parent.type {
                        case .vertical: self._layFrameParent.b?.isActive = false
                        case .horizontal: self._layFrameParent.r?.isActive = false
                        case .auto: ()
                    }
                }

                next._prev(self)

                return self
            }
            @discardableResult private func _lays(parent: Stack, _ show: Bool) -> Self {
                if show {
                    switch parent.type {
                        case .vertical:
                            self.zH(parent: parent, enable: false)
                            self._height.lay?.isActive = true
                            self._layFrameParent.h?.isActive = true
                            self._layFrameBody.t?.isActive = true
                            self._layFrameBody.b?.isActive = true

                        case .horizontal:
                            self.zW(parent: parent, enable: false)
                            self._width.lay?.isActive = true
                            self._layFrameParent.w?.isActive = true
                            self._layFrameBody.l?.isActive = true
                            self._layFrameBody.r?.isActive = true

                        case .auto:
                            self.zH(parent: parent, enable: false)
                            self.zW(parent: parent, enable: false)
                            self._layFrameParent.x?.isActive = false
                            self._layFrameParent.y?.isActive = false
                            self._layFrameParent.h?.isActive = true
                            self._layFrameParent.w?.isActive = true
                            self._layFrameParent.t?.isActive = true
                            self._layFrameParent.b?.isActive = true
                            self._layFrameParent.l?.isActive = true
                            self._layFrameParent.r?.isActive = true
                            self._layFrameBody.t?.isActive = true
                            self._layFrameBody.b?.isActive = true
                            self._layFrameBody.l?.isActive = true
                            self._layFrameBody.r?.isActive = true
                    }
                } else {
                    switch parent.type {
                        case .vertical:
                            self._layFrameBody.t?.isActive = false
                            self._layFrameBody.b?.isActive = false
                            self._layFrameParent.h?.isActive = false
                            self._height.lay?.isActive = false
                            self.zH(parent: parent, enable: true)

                        case .horizontal:
                            self._layFrameBody.l?.isActive = false
                            self._layFrameBody.r?.isActive = false
                            self._layFrameParent.w?.isActive = false
                            self._width.lay?.isActive = false
                            self.zW(parent: parent, enable: true)

                        case .auto:
                            self._layFrameParent.x?.isActive = true
                            self._layFrameParent.y?.isActive = true
                            self._layFrameBody.t?.isActive = false
                            self._layFrameBody.b?.isActive = false
                            self._layFrameBody.l?.isActive = false
                            self._layFrameBody.r?.isActive = false
                            self._layFrameParent.h?.isActive = false
                            self._layFrameParent.w?.isActive = false
                            self._layFrameParent.t?.isActive = false
                            self._layFrameParent.b?.isActive = false
                            self._layFrameParent.l?.isActive = false
                            self._layFrameParent.r?.isActive = false
                            self.zH(parent: parent, enable: true)
                            self.zW(parent: parent, enable: true)
                    }
                }
                return self
            }
        }

        public class Stack: Unit {
            public enum `Type` {
                case auto, vertical, horizontal
            }

            private let _type: `Type`
            private lazy var _children: [Unit] = []

            public var type: `Type` { self._type }
            public var children: [Unit] { self._children }

            public init(ui body: UIView, type: `Type` = .auto, padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, isShow: Bool? = true) {
                self._type = type
                super.init(ui: body, padding: padding, margin: margin, isShow: isShow)
            }

            @discardableResult public func append(_ child: Unit) -> Self {
                if self.type == .auto {
                    guard self.children.isEmpty else { return self }
                }

                if self.children.contains(child) { return self }
                self.children.last?.next(child)
                self._children.append(child)

                child.add(to: self)

                child.reloadT().reloadL().reloadB().reloadR()

                switch self.type {
                    case .auto: child.reloadW().reloadH().reloadX().reloadY()
                    case .vertical: child.reloadW().height()
                    case .horizontal: child.reloadH().width()
                }
        
                child.frame.layoutIfNeeded()
                self.body.layoutIfNeeded()

                if let isShow = child.isShow, !isShow {
                    child.hide(animated: false)
                }

                child.add()

                return self
            }
        }

        public class Time: Unit {
            public enum `Type` {
                case date, dateAndTime
                var mode: UIDatePicker.Mode {
                    switch self {
                        case .date: return .date
                        case .dateAndTime: return .dateAndTime
                    }
                }
                var format: String {
                    switch self {
                        case .date: return "yyyy-MM-dd"
                        case .dateAndTime: return "yyyy-MM-dd HH:mm:dd"
                    }
                }
            }

            private let _view: UIView
            private let _picker: UIDatePicker
            private let _d4: (title: String, must: Bool, header: String, type: `Type`, bgColor: UIColor)
            
            private lazy var _onChanges: [(TimeInterval, String) -> ()] = []

            private var _format: DateFormatter {
                let format: DateFormatter = .init()
                format.dateFormat = self._d4.type.format
                format.timeZone = .current
                return format
            }
            public var value: TimeInterval {
                get { self._picker.date.timeIntervalSince1970 }
                set { DispatchQueue.main.async { self._picker.date = Date(timeIntervalSince1970: newValue) } }
            }

            public init(title: String, value: TimeInterval = NSDate().timeIntervalSince1970, must: Bool = true, header: String = "", type: `Type` = .date, padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, bgColor color: UIColor? = nil, isShow: Bool? = true) {
                let bgColor: UIColor
                if let color = color {
                    bgColor = color
                } else {
                    if #available(iOS 13.0, *) {
                        bgColor = .systemBackground
                    } else {
                        bgColor = rgba(255, 255, 255, 1.0)
                    }
                }

                self._view = .init()
                self._picker = .init()

                self._d4 = (title: title, must: must, header: header, type: type, bgColor: bgColor)

                super.init(ui: self._view, padding: padding, margin: margin, isShow: isShow)

                self._initUI()

                self.on(add: { self.value = value })
            }

            private func _initUI() {
                let section = section(to: self._view, title: self._d4.header, bgColor: self._d4.bgColor)
                let header = self._ui(base: section.cell, text: self._d4.title, must: self._d4.must)

                self._picker.border(1, .red, OA.UI.debug)
                self._picker.datePickerMode = self._d4.type.mode
                if #available(iOS 13.4, *) {
                    self._picker.preferredDatePickerStyle = .compact
                } else {
                }
                self._picker.add(to: section.cell).l().q(header).e()
                self._picker.add(to: section.cell).t().q(header).b(4).e()
                self._picker.add(to: section.cell, enable: "b=-8")
                self._picker.addTarget(self, action: #selector(change(_:)), for: .valueChanged)
            }
            @objc func change(_ sender: UIDatePicker? = nil) {
                self._onChanges.forEach { $0(self._picker.date.timeIntervalSince1970, self._format.string(from: self._picker.date)) }
            }
            private func _ui(base: UIView, text: String, must: Bool) -> UIView {
                let view: UIView = .init()
                view.border(1, .red, OA.UI.debug)
                view.add(to: base, enable: "t=8")

                let title: UILabel = .init()
                title.text = text
                if #available(iOS 13.0, *) {
                    title.textColor = .secondaryLabel
                } else {
                    title.textColor = rgba(60, 60, 67, 0.6)
                }
                title.border(1, .red, OA.UI.debug)
                title.adjustsFontForContentSizeCategory = true
                title.font = .preferredFont(forTextStyle: .caption1)
                title.add(to: view, enable: "t; b; r")

                if must {
                    let mark: UILabel = .init()
                    mark.border(1, .red, OA.UI.debug)
                    mark.text = "＊"
                    mark.textColor = .systemRed
                    mark.textAlignment = .center
                    mark.adjustsFontForContentSizeCategory = true
                    mark.font = .preferredFont(forTextStyle: .caption1)
                    
                    mark.add(to: view, enable: "l=-12; w=12")
                    mark.add(to: view).y().q(title).e()
                    mark.add(to: view).r().q(title).l().e()
                    view.add(to: base, enable: "l=20")
                } else {
                    view.add(to: base, enable: "l=16")
                    title.add(to: view, enable: "l")
                }

                return view
            }
            @discardableResult public func on(change: @escaping (TimeInterval, String) -> ()) -> Self {
                self._onChanges.append(change)
                return self
            }
            @discardableResult public func on(change: @escaping (TimeInterval) -> ()) -> Self { self.on(change: { val, _ in change(val) }) }
            @discardableResult public func on(change: @escaping Closure) -> Self { self.on(change: { _, _ in change() }) }
        }

        public class Input: Unit {
            public enum `Type` {
                case uint, ufloat, textField, textView
                var keyboardType: UIKeyboardType {
                    switch self {
                        case .uint: return .numberPad
                        case .ufloat: return .decimalPad
                        case .textField: return .asciiCapable
                        case .textView: return .asciiCapable
                    }
                }
            }

            private let _view: UIView
            private var _last: String
            private let _action: Action.TextInput
            private let _d4: (title: String, value: String, must: Bool, placeholder: String, header: String, icon: UIImage?, type: `Type`, keyboard: UIKeyboardType, bgColor: UIColor)

            private let _text: UITextView?
            private let _field: UITextField?
            private let _placeholder: UILabel?

            public var value: String {
                get { self._d4.type == .textView ? (self._text?.text ?? "") : (self._field?.text ?? "") }
                set { self._reflash(str: self._check(str: newValue)) }
            }

            private lazy var _onClickIcons: [Closure] = []
            private lazy var _onFocues: [Closure] = []
            private lazy var _onChanges: [(String) -> ()] = []
            private lazy var _onBlurs: [Closure] = []

            private weak var _button: UIButton? = nil
            private weak var _cell: UIView? = nil

            public init(title: String, value: String = "", must: Bool = true, placeholder: String? = nil, header: String = "", icon: UIImage? = nil, type: `Type` = .textField, keyboard: UIKeyboardType? = nil, padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, bgColor color: UIColor? = nil, isShow: Bool? = true) {
                let bgColor: UIColor
                if let color = color {
                    bgColor = color
                } else {
                    if #available(iOS 13.0, *) {
                        bgColor = .systemBackground
                    } else {
                        bgColor = rgba(255, 255, 255, 1.0)
                    }
                }
                self._d4 = (title: title, value: value, must: must, placeholder: placeholder ?? "請輸入\(title)…", header: header, icon: icon, type: type, keyboard: keyboard ?? type.keyboardType, bgColor: bgColor)
                self._view = .init()
                self._last = ""
                self._action = .init()
                
                if type == .textView {
                    self._text = .init()
                    self._placeholder = .init()
                    self._field = nil
                } else {
                    self._field = .init()
                    self._text = nil
                    self._placeholder = nil
                }

                super.init(ui: self._view, padding: padding, margin: margin, isShow: isShow)
                self._initUI()
                self._last = self._done(str: self._d4.value)
                self._reflash(str: self._last)
            }

            @discardableResult public func on(clickIcon: @escaping Closure) -> Self {
                self._onClickIcons.append(clickIcon)
                return self
            }
            @discardableResult public func on(focus: @escaping Closure) -> Self {
                self._onFocues.append(focus)
                return self
            }
            @discardableResult public func on(change: @escaping (String) -> ()) -> Self {
                self._onChanges.append(change)
                return self
            }
            @discardableResult public func on(blur: @escaping Closure) -> Self {
                self._onBlurs.append(blur)
                return self
            }
            @discardableResult public func focus(completion: Closure? = nil) -> Self {
                if let text = self._text {
                    self._reflash(str: self._ing(str: text.text ?? ""))
                    text.becomeFirstResponder()
                } else if let field = self._field {
                    self._reflash(str: self._ing(str: field.text ?? ""))
                    field.becomeFirstResponder()
                }

                self._button?.isHidden = true
                if #available(iOS 13.0, *) {
                    self._cell?.border(3, .link)
                } else {
                    self._cell?.border(3, rgba(0, 122, 255, 1.0))
                }
                self._onFocues.forEach { $0() }
                completion?()
                return self
            }
            @discardableResult public func blur(completion: Closure? = nil) -> Self {
                if let text = self._text {
                    self._reflash(str: self._done(str: text.text ?? ""))
                    text.resignFirstResponder()
                } else if let field = self._field {
                    self._reflash(str: self._done(str: field.text ?? ""))
                    field.resignFirstResponder()
                }

                self._button?.isHidden = false
                if #available(iOS 13.0, *) {
                    self._cell?.border(1, .separator.withAlphaComponent(0.16))
                } else {
                    self._cell?.border(1, rgba(60, 60, 67, 0.29).withAlphaComponent(0.16))
                }
                self._onBlurs.forEach { $0() }
                completion?()
                return self
            }

            @discardableResult public func on(clickIcon: @escaping (Self) -> ()) -> Self { self.on(clickIcon: { clickIcon(self) }) }
            @discardableResult public func on(focus: @escaping (Self) -> ()) -> Self { self.on(focus: { focus(self) }) }
            @discardableResult public func on(change: @escaping (String, Self) -> ()) -> Self { self.on(change: { change($0, self) }) }
            @discardableResult public func on(change: @escaping Closure) -> Self { self.on(change: { _ in change() }) }
            @discardableResult public func on(blur: @escaping (Self) -> ()) -> Self { self.on(blur: { blur(self) }) }
            @discardableResult public func focus(completion: @escaping (Self) -> ()) -> Self { self.focus { completion(self) } }
            @discardableResult public func blur(completion: @escaping (Self) -> ()) -> Self { self.blur { completion(self) } }

            private func _initUI() {
                let section = section(to: self._view, title: self._d4.header, bgColor: self._d4.bgColor)
                self._cell = section.cell

                let header = self._ui(base: section.cell, text: self._d4.title, must: self._d4.must)

                weak var tmp: UIView?

                if let text = self._text {
                    tmp = self._ui(to: section.cell, header: header, text: text)
                } else if let field = self._field {
                    tmp = self._ui(to: section.cell, field: field)
                }

                tmp?.add(to: section.cell, enable: "b=-4")
                tmp?.add(to: section.cell).t().q(header).b(-4).e()
                tmp?.add(to: section.cell).l().q(header).e()

                let button = UI.button(to: section.cell, target: (action: self._action, tag: 1),enable: "l; t; b")
                self._button = button

                let icon: UIView? = {
                    guard let icon = $0 else { return nil }
                    let view: UIView = .init()
                    view.border(1, .red, OA.UI.debug)
                    
                    let image: UIImageView = .init(image: icon)
                    image.border(1, .red, OA.UI.debug)
                    image.add(to: view, enable: "x=2; y; w=32; h=32")

                    let line: UIView = .init()
                    if #available(iOS 13.0, *) {
                        line.backgroundColor = .separator.withAlphaComponent(0.18)
                    } else {
                        line.backgroundColor = rgba(60, 60, 67, 0.29).withAlphaComponent(0.18)
                    }
                    line.add(to: view, enable: "l=5; t=12; b=-12; w=1")

                    return view
                }(self._d4.icon)

                if let icon = icon {
                    icon.add(to: section.cell, enable: "r; t; b; w=64")
                    UI.button(to: icon, target: (action: self._action, tag: 2))

                    tmp?.add(to: section.cell).r().q(icon).l(-5).e()
                    header.add(to: section.cell).r().q(icon).l(-5).e()
                    button.add(to: section.cell).r().q(icon).l(-5).e()
                } else {
                    tmp?.add(to: section.cell, enable: "r=-16")
                    header.add(to: section.cell, enable: "r=-16")
                    button.add(to: section.cell, enable: "r")
                }

                self._action.on(focus: {
                    self.focus()
                }).on(blur: {
                    self.blur()
                }).on(change: {
                    let val = self._text?.text ?? self._field?.text ?? ""
                    self._reflash(str: self._ing(str: val))
                    _ = self._check(str: val)
                }).on(clickIcon: {
                    self._onClickIcons.forEach { $0() }
                })
            }

            private func _done(str: String) -> String {
                switch self._d4.type {
                    case .uint: return Parse.`UInt`.done(str: str)
                    case .ufloat: return Parse.UFloat.done(str: str)
                    case .textField: return str
                    case .textView: return str
                }
            }
            private func _ing(str: String) -> String {
                switch self._d4.type {
                    case .uint: return Parse.`UInt`.ing(str: str)
                    case .ufloat: return Parse.UFloat.ing(str: str)
                    case .textField: return str
                    case .textView: return str
                }
            }

            private func _check(str: String) -> String {
                let val = self._done(str: str)
                if val == self._last { return val }
                self._last = val
                self._onChanges.forEach { $0(self._done(str: self._last)) }
                return val
            }
            private func _reflash(str: String) {
                self._text?.text = str
                self._field?.text = str
                self._placeholder?.isHidden = !(self._text?.text ?? "").isEmpty
            }

            private func _ui(to base: UIView, field: UITextField) -> UITextField {
                field.border(1, .red, OA.UI.debug)

                field.sizeToFit()
                field.delegate = self._action
                if #available(iOS 13.0, *) {
                    field.textColor = .label
                } else {
                    field.textColor = rgba(0, 0, 0, 1)
                }
                field.returnKeyType = .done
                field.backgroundColor = .clear
                field.adjustsFontForContentSizeCategory = true
                field.font = .preferredFont(forTextStyle: .body)
                field.keyboardType = self._d4.keyboard

                field.placeholder = self._d4.placeholder
                field.add(to: base, enable: "h=36")
                field.addTarget(self._action, action: #selector(self._action.editingChanged(_:)), for: .editingChanged)
                if #available(iOS 13.0, *) {
                    field.attributedPlaceholder = .init(string: self._d4.placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
                } else {
                    field.attributedPlaceholder = .init(string: self._d4.placeholder, attributes: [NSAttributedString.Key.foregroundColor:rgba(60, 60, 67, 0.3), NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
                }
                return field
            }
            private func _ui(to base: UIView, header: UIView, text: UITextView) -> UITextView {
                text.border(1, .red, OA.UI.debug)

                text.sizeToFit()
                text.delegate = self._action
                if #available(iOS 13.0, *) {
                    text.textColor = .label
                } else {
                    text.textColor = rgba(0, 0, 0, 1)
                }
                text.returnKeyType = .default
                text.backgroundColor = .clear
                text.adjustsFontForContentSizeCategory = true
                text.font = .preferredFont(forTextStyle: .body)
                text.keyboardType = self._d4.keyboard

                text.isScrollEnabled = false
                text.textContainer.lineFragmentPadding = 0
                text.add(to: base, enable: "h>52")

                self._placeholder?.border(1, .red, OA.UI.debug)
                
                if #available(iOS 13.0, *) {
                    self._placeholder?.textColor = .tertiaryLabel
                } else {
                    self._placeholder?.textColor = rgba(60, 60, 67, 0.3)
                }
                self._placeholder?.text = self._d4.placeholder
                self._placeholder?.adjustsFontForContentSizeCategory = true
                self._placeholder?.font = .preferredFont(forTextStyle: .caption1)
                self._placeholder?.add(to: base).l().q(header).e()
                self._placeholder?.add(to: base).t().q(header).b(8).e()

                return text
            }
            private func _ui(base: UIView, text: String, must: Bool) -> UIView {
                let view: UIView = .init()
                view.border(1, .red, OA.UI.debug)
                view.add(to: base, enable: "t=8")

                let title: UILabel = .init()
                title.text = text
                if #available(iOS 13.0, *) {
                    title.textColor = .secondaryLabel
                } else {
                    title.textColor = rgba(60, 60, 67, 0.6)
                }
                title.border(1, .red, OA.UI.debug)
                title.adjustsFontForContentSizeCategory = true
                title.font = .preferredFont(forTextStyle: .caption1)
                title.add(to: view, enable: "t; b; r")

                if must {
                    let mark: UILabel = .init()
                    mark.border(1, .red, OA.UI.debug)
                    mark.text = "＊"
                    mark.textColor = .systemRed
                    mark.textAlignment = .center
                    mark.adjustsFontForContentSizeCategory = true
                    mark.font = .preferredFont(forTextStyle: .caption1)
                    
                    mark.add(to: view, enable: "l=-12; w=12")
                    mark.add(to: view).y().q(title).e()
                    mark.add(to: view).r().q(title).l().e()
                    view.add(to: base, enable: "l=20")
                } else {
                    view.add(to: base, enable: "l=16")
                    title.add(to: view, enable: "l")
                }

                return view
            }
        }

        public class Check<C: OA_UI_Item_Delegate>: Unit {
            typealias Item = (view: UIView, icon: UIImageView)

            private let _view: UIView
            private var _value: C?
            private let _action: Action.Check<C>
            private let _d4: (title: String, values: [C], bgColor: UIColor)

            private lazy var _items: [Item] = []
            private lazy var _onClicks: [(C?) -> ()] = []
            private lazy var _onChanges: [(C?) -> ()] = []

            public var value: C? {
                get { self._value }
                set {
                    let changed: Bool

                    if let last = self._value, let val = newValue { changed = !(last == val) }
                    else { changed = !(self._value == nil && newValue == nil) }

                    if changed {
                        self._value = newValue
                        self._reflash()
                        self._onChanges.forEach { $0(newValue) }
                    }
                }
            }

            public init(title: String, values: [C], value: C? = nil, padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, bgColor color: UIColor? = nil, isShow: Bool? = true) {
                let bgColor: UIColor
                if let color = color {
                    bgColor = color
                } else {
                    if #available(iOS 13.0, *) {
                        bgColor = .systemBackground
                    } else {
                        bgColor = rgba(255, 255, 255, 1)
                    }
                }
                self._view = .init()
                self._value = value
                self._action = .init()
                self._d4 = (title: title, values: values, bgColor: bgColor)

                super.init(ui: self._view, padding: padding, margin: margin, isShow: isShow)

                self._initUI()
                self._reflash()
            }

            @discardableResult public func on(click: @escaping (C?) -> ()) -> Self {
                self._onClicks.append(click)
                return self
            }
            @discardableResult public func on(change: @escaping (C?) -> ()) -> Self {
                self._onChanges.append(change)
                return self
            }

            @discardableResult public func on(click: @escaping (C?, Self) -> ()) -> Self { self.on(click: { click($0, self) }) }
            @discardableResult public func on(click: @escaping Closure) -> Self { self.on(click: { _ in click() }) }
            @discardableResult public func on(change: @escaping (C?, Self) -> ()) -> Self { self.on(change: { change($0, self) }) }
            @discardableResult public func on(change: @escaping Closure) -> Self { self.on(change: { _ in change() }) }

            private func _reflash() {
                self._d4.values.enumerated().forEach {
                    guard $0 < self._items.count else { return }

                    if let val = self._value, val == $1 {
                        if #available(iOS 13.0, *) {
                            self._items[$0].icon.tintColor = .link
                        } else {
                            self._items[$0].icon.tintColor = rgba(0, 122, 255, 1)
                        }
                    } else {
                        if #available(iOS 13.0, *) {
                            self._items[$0].icon.tintColor = .quaternaryLabel
                        } else {
                            self._items[$0].icon.tintColor = rgba(60, 60, 67, 0.18)
                        }
                    }
                }
            }
            private func _initUI() {
                let cell = section(to: self._view, title: self._d4.title, bgColor: self._d4.bgColor).cell

                self._d4.values.enumerated().forEach { self._items.append(self._check(to: cell, tag: $0, item: $1, action: self._action)) }
                self._items.last?.view.add(to: cell).b().e()

                self._action.on(click: { val in
                    self._onClicks.forEach { $0(val) }
                    self.value = val
                })
            }
            private func _check(to base: UIView, tag: Int, item: C, action: Action.Check<C>) -> Item {
                let view: UIView = .init()
                view.add(to: base, enable: "l; r")
                view.border(1, .red, OA.UI.debug)

                if let top = self._items.last?.view {
                    let line: UIView = .init()
                    if #available(iOS 13.0, *) {
                        line.backgroundColor = .separator.withAlphaComponent(0.18)
                    } else {
                        line.backgroundColor = rgba(60, 60, 67, 0.29).withAlphaComponent(0.18)
                    }
                    line.add(to: base, enable: "r; l=\(10 + 36 + 7); h=1")
                    line.add(to: base).t().q(top).b().e()
                    view.add(to: base).t().q(line).b().e()
                } else {
                    view.add(to: base, enable: "t")
                }
                
                let icon: UIImageView
                if #available(iOS 13.0, *) {
                    icon = .init(image: .init(systemName: "checkmark.circle.fill"))
                } else {
                    icon = .init(image: nil)
                }
                icon.border(1, .red, OA.UI.debug)
                if #available(iOS 13.0, *) {
                    icon.tintColor = .quaternaryLabel
                } else {
                    icon.tintColor = rgba(60, 60, 67, 0.18)
                }
                icon.add(to: view, enable: "y; l=10; w=36; h=36")

                let title: UILabel = .init()
                title.border(1, .red, OA.UI.debug)
                title.text = item.title
                if #available(iOS 13.0, *) {
                    title.textColor = .label
                } else {
                    title.textColor = rgba(0, 0, 0, 1)
                }
                title.adjustsFontForContentSizeCategory = true
                title.font = .preferredFont(forTextStyle: .body)
                title.add(to: view, enable: "t=12; r=-12")
                title.add(to: view).l().q(icon).r(10).e()

                if !item.subtitle.isEmpty {
                    let subtitle: UILabel = .init()
                    subtitle.text = item.subtitle
                    subtitle.numberOfLines = 0
                    if #available(iOS 13.0, *) {
                        subtitle.textColor = .secondaryLabel
                    } else {
                        subtitle.textColor = rgba(60, 60, 67, 0.6)
                    }
                    subtitle.lineBreakMode = .byWordWrapping
                    subtitle.adjustsFontForContentSizeCategory = true
                    subtitle.font = .preferredFont(forTextStyle: .caption1)
                    subtitle.add(to: view).t().q(title).b(4).e()
                    subtitle.add(to: view).l().q(title).e()
                    subtitle.add(to: view, enable: "r=-12; b=-10")
                    if OA.UI.debug { subtitle.border(1, .red) }
                } else {
                    title.add(to: view, enable: "r=-12; b=-12")
                }
                
                UI.button(to: view, target: (action: self._action.tag(tag, val: item), tag: tag))

                return (view: view, icon: icon)
            }
        }

        public class Choice: Unit {
            private let _view: UIView
            private let _d4: (title: String, placeholder: String, bgColor: UIColor)
            private let _label: UILabel
            private var _value: String

            private lazy var _action: Action.Button = .init()
            private lazy var _onClicks: [Closure] = []
            private lazy var _onUpdates: [(String) -> ()] = []
            private lazy var _onChanges: [(String) -> ()] = []
            private weak var _cell: UIView?

            public var value: String {
                get { self._value }
                set {
                    self._onUpdates.forEach { $0(newValue) }
                    guard self._value != newValue else { return }
                    self._value = newValue
                    self._reflash()
                    self._onChanges.forEach { $0(newValue) }
                }
            }

            public init(title: String, placeholder: String? = nil, value: String = "", padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, bgColor color: UIColor? = nil, isShow: Bool? = true) {
                let bgColor: UIColor
                if let color = color {
                    bgColor = color
                } else {
                    if #available(iOS 13.0, *) {
                        bgColor = .systemBackground
                    } else {
                        bgColor = rgba(255, 255, 255, 1)
                    }
                }
                self._view = .init()
                self._label = .init()
                self._value = value

                self._d4 = (title: title, placeholder: placeholder ?? "請選擇\(title)…", bgColor: bgColor)

                super.init(ui: self._view, padding: padding, margin: margin, isShow: isShow)

                self._initUI()
                self._reflash()
            }

            @discardableResult public func on(click: @escaping Closure) -> Self {
                guard self._onClicks.isEmpty else {
                    self._onClicks.append(click)
                    return self
                }

                if let cell = self._cell {
                    UI.button(to: cell, action: self._action.on(click: { self._onClicks.forEach { $0() } }))
                    self._onClicks.append(click)
                }

                return self
            }
            @discardableResult public func on(change: @escaping (String) -> ()) -> Self {
                self._onChanges.append(change)
                return self
            }
            @discardableResult public func on(update: @escaping (String) -> ()) -> Self {
                self._onUpdates.append(update)
                return self
            }

            @discardableResult public func on(click: @escaping (Self) -> ()) -> Self { self.on(click: { click(self) }) }
            @discardableResult public func on(change: @escaping (String, Self) -> ()) -> Self { self.on(change: { change($0, self) }) }
            @discardableResult public func on(change: @escaping Closure) -> Self { self.on(change: { _ in change() }) }
            @discardableResult public func on(update: @escaping (String, Self) -> ()) -> Self { self.on(update: { update($0, self) }) }
            @discardableResult public func on(update: @escaping Closure) -> Self { self.on(update: { _ in update() }) }

            private func _reflash() {
                if !self._value.isEmpty {
                    self._label.text = self._value
                    if #available(iOS 13.0, *) {
                        self._label.textColor = .label
                    } else {
                        self._label.textColor = rgba(0, 0, 0, 1)
                    }
                } else {
                    self._label.text = self._d4.placeholder
                    if #available(iOS 13.0, *) {
                        self._label.textColor = .link
                    } else {
                        self._label.textColor = rgba(0, 122, 255, 1)
                    }
                }
            }
            private func _initUI() {
                let cell = section(to: self._view, title: self._d4.title, bgColor: self._d4.bgColor).cell
                self._cell = cell

                let icon: UIImageView
                if #available(iOS 13.0, *) {
                    icon = .init(image: .init(systemName: "chevron.forward"))
                } else {
                    icon = .init(image: nil)
                }
                icon.border(1, .red, OA.UI.debug )
                if #available(iOS 13.0, *) {
                    icon.tintColor = .secondaryLabel
                } else {
                    icon.tintColor = rgba(60, 60, 67, 0.6)
                }
                icon.add(to: cell, enable: "y; r=-12; w=10; h=18")

                self._label.border(1, .red, OA.UI.debug )
                self._label.adjustsFontForContentSizeCategory = true
                self._label.font = .preferredFont(forTextStyle: .body)
                self._label.add(to: cell, enable: "t=15; b=-14; l=16; r=\(-30.0)")
            }
        }

        public class Error: Unit {
            private let _view: UIView
            private var _messages: [String]
            private var _bgColor: UIColor
            private var _onChanges: [(Bool) -> ()] = []
            
            private weak var _cell: UIView? = nil
            
            public var messages: [String] {
                get { self._messages }
                set {
                    DispatchQueue.main.async {
                        self._messages = newValue
                    }
                    self._reflash()
                }
            }

            public init(messages: [String] = [], padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, bgColor color: UIColor? = nil) {
                let bgColor: UIColor
                if let color = color {
                    bgColor = color
                } else {
                    if #available(iOS 13.0, *) {
                        bgColor = .systemBackground
                    } else {
                        bgColor = rgba(255, 255, 255, 1)
                    }
                }
                self._view = .init()
                self._messages = messages
                self._bgColor = bgColor

                super.init(ui: self._view, padding: padding, margin: margin, isShow: !messages.isEmpty)

                self._initUI()
                self._reflash()
            }

            @discardableResult public func on(change: @escaping (Bool) -> ()) -> Self {
                self._onChanges.append(change)
                return self
            }

            @discardableResult public func on(change: @escaping (Bool, Self) -> ()) -> Self { self.on(change: { change($0, self) }) }
            @discardableResult public func on(change: @escaping Closure) -> Self { self.on(change: { _ in change() }) }

            private func _reflash() {
                guard let cell = self._cell else { return }
                cell.subviews.forEach { $0.removeFromSuperview() }
                cell.constraints.forEach { cell.removeConstraint($0) }

                if self._messages.isEmpty {
                    self.hide(animated: true) { self._onChanges.forEach { $0(false) } }
                    return
                }

                let index = self._messages.count > 1

                self._messages.enumerated().reduce(nil) { (last: UILabel?, b: (Int, String)) in
                    let label: UILabel = .init()
                    label.numberOfLines = 0
                    label.textColor = .white
                    label.lineBreakMode = .byWordWrapping
                    label.adjustsFontForContentSizeCategory = true
                    label.font = .preferredFont(forTextStyle: .body)
                    label.text = "\(index ? "\(b.0 + 1). " : "")\(b.1)"
                    label.add(to: cell, enable: "l=12; r=-12")
                    if let last = last {
                        label.add(to: cell).t().q(last).b(4).e()
                    } else {
                        label.add(to: cell).t(10).e()
                    }
                    return label
                }?.add(to: cell).b(-10).e()

                self.show(animated: true) { self._onChanges.forEach { $0(true) } }
            }
            private func _initUI() {
                self._cell = section(to: self._view, bgColor: self._bgColor).cell
                self._cell?.border(1, .clear)
                self._cell?.backgroundColor = .systemRed
            }
        }

        public class Button: Unit {
            private let _title: String
            private let _view: UIView
            private let _bgColor: UIColor
            
            private let title: UILabel = .init()

            private lazy var _action: Action.Button = .init()
            private lazy var _onClicks: [Closure] = []
            private lazy var _isEnable: Bool = true
            
            public var text: String {
                get { self.title.text ?? "" }
                set { self.title.text = newValue }
            }
            public var color: UIColor {
                get { self.title.textColor }
                set { self.title.textColor = newValue }
            }
            public var isEnable: Bool {
                get { self._isEnable }
                set { self._isEnable = newValue }
            }

            public init(title: String, padding: UIEdgeInsets = .zero, margin: UIEdgeInsets = .zero, bgColor color: UIColor? = nil, isShow: Bool? = true) {
                let bgColor: UIColor
                if let color = color {
                    bgColor = color
                } else {
                    if #available(iOS 13.0, *) {
                        bgColor = .systemBackground
                    } else {
                        bgColor = rgba(255, 255, 255, 1)
                    }
                }
                
                self._view = .init()
                self._title = title
                self._bgColor = bgColor

                super.init(ui: self._view, padding: padding, margin: margin, isShow: isShow)
                self._initUI()
            }

            private func _initUI() {
                self.title.text = self._title
                if #available(iOS 13.0, *) {
                    self.title.textColor = .link
                } else {
                    self.title.textColor = rgba(0, 122, 255, 1)
                }
                self.title.textAlignment = .center
                self.title.adjustsFontForContentSizeCategory = true
                self.title.font = .preferredFont(forTextStyle: .body)
                self.title.add(to: section(to: self._view, bgColor: self._bgColor).cell, enable: "t; b; l; r; h>48")
            }

            @discardableResult public func on(click: @escaping Closure) -> Self {
                guard self._onClicks.isEmpty else {
                    self._onClicks.append(click)
                    return self
                }

                UI.button(to: self.frame, action: self._action.on(click: {
                    guard self._isEnable else { return }
                    self._onClicks.forEach { $0() }
                }))

                self._onClicks.append(click)
                return self
            }

            @discardableResult public func on(click: @escaping (Self) -> ()) -> Self { self.on(click: { click(self) }) }
        }
    }
}
