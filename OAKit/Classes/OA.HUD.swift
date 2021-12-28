//
//  OA.HUD.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/28.
//

import Foundation

import UIKit

public extension OA {
    class HUD: UIWindow  {
        public enum `Type` { case loading, done, fail }
        public enum Style { case jelly, general }

        @available(iOS 13.0, *)
        public static var scene: UIWindowScene? = nil

        private static var _shared: HUD? = nil

        public static var shared: HUD? {
            if let shared = self._shared { return shared }
            self._shared = .init(())
            return self._shared
        }

        private static func initT (str: String, view: UIView) -> OA.Layout {
            let label: UILabel = .init()
            label.text = str
            label.minimumScaleFactor = 0.25
            label.adjustsFontForContentSizeCategory = true
            label.textColor = .black.withAlphaComponent(0.85)
            label.font = UIFont.preferredFont(forTextStyle: .body).bold()
            label.add(to: view).x().e()
            return label.add(to: view)
        }
        private static func initD (str: String, view: UIView) -> OA.Layout {
            let label: UILabel = .init()
            label.text = str
            label.minimumScaleFactor = 0.25
            label.adjustsFontForContentSizeCategory = true
            label.textColor = .black.withAlphaComponent(0.7)
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            label.add(to: view).x().e()
            return label.add(to: view)
        }

        private static func loading(view: UIView, title: String = "", description: String = "") {
            let activityIndicatorView: UIActivityIndicatorView
            if #available(iOS 13.0, *) {
                activityIndicatorView = .init(style: .large)
            } else {
                activityIndicatorView = .init()
            }
            activityIndicatorView.startAnimating()
            activityIndicatorView.add(to: view).x().e()
            activityIndicatorView.color = UIColor.black.withAlphaComponent(0.6)

            switch [title.isEmpty, description.isEmpty] {
            case [false, true]:
                activityIndicatorView.add(to: view).y(4).e()
                HUD.initD(str: title, view: view).t(28).e()

            case [true, false]:
                activityIndicatorView.add(to: view).y(-8).e()
                HUD.initD(str: description, view: view).t().q(activityIndicatorView).b(20).e()

            case [false, false]:
                activityIndicatorView.add(to: view).y().e()
                HUD.initT(str: title, view: view).t(24).e()
                HUD.initD(str: description, view: view).t().q(activityIndicatorView).b(15).e()

            default: activityIndicatorView.add(to: view).y().e()
            }
        }
        private static func done(view: UIView, title: String = "", description: String = "") {
            let ani: UIView = .init()
            ani.add(to: view).w(90).e()
            ani.add(to: view).h(90).e()
            ani.add(to: view).x().e()

            let p1: UIBezierPath = .init()
            p1.addArc(withCenter: .init(x: 90 / 2, y: 90 / 2),
              radius: 90 / 2,
              startAngle: -CGFloat.pi / 2,
              endAngle: -CGFloat.pi / 2 + 0.001,
              clockwise: false)

            let p2: UIBezierPath = .init()
            p2.move(to: .init(x: 21, y: 47.0))
            p2.addLine(to: .init(x: 39.0, y: 65.0))
            p2.addLine(to: .init(x: 71.0, y: 30.0))

            let l1: CAShapeLayer = .init()
            l1.frame       = .init(x: 0, y: 00, width: 90, height: 90)
            l1.path        = p1.cgPath
            l1.fillMode    = .forwards
            l1.lineCap     = .round
            l1.lineJoin    = .round
            l1.fillColor   = nil
            l1.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
            l1.lineWidth   = 6.0
            l1.position = .init(x: 90 / 2, y: 90 / 2)
            l1.anchorPoint = .init(x: 0.5, y: 0.5)

            let l2: CAShapeLayer = .init()
            l2.frame       = .init(x: 0, y: 00, width: 90, height: 90)
            l2.path        = p2.cgPath
            l2.fillMode    = .forwards
            l2.lineCap     = .round
            l2.lineJoin    = .round
            l2.fillColor   = nil
            l2.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
            l2.lineWidth   = 6.0
            l2.position = .init(x: 90 / 2, y: 90 / 2)
            l2.anchorPoint = .init(x: 0.5, y: 0.5)

            let caani: CAKeyframeAnimation = .init(keyPath: "strokeEnd")
            caani.values = [0, 1]
            caani.keyTimes = [0, 1]
            caani.duration = 0.3
            caani.timingFunction = CAMediaTimingFunction(name: .easeOut)
            l1.add(caani, forKey: "checkmarkStrokeAnim")
            l2.add(caani, forKey: "checkmarkStrokeAnim")

            ani.layer.addSublayer(l1)
            ani.layer.addSublayer(l2)
            
            switch [title.isEmpty, description.isEmpty] {
            case [false, true]:
                ani.add(to: view).y(12).e()
                HUD.initT(str: title, view: view).t(16).e()

            case [true, false]:
                ani.add(to: view).y(-16).e()
                HUD.initD(str: description, view: view).t().q(ani).b(15).e()

            case [false, false]:
                ani.add(to: view).y().e()
                HUD.initT(str: title, view: view).t(8).e()
                HUD.initD(str: description, view: view).t().q(ani).b(8).e()

            default:
                ani.add(to: view).y().e()
            }
        }
        private static func fail(view: UIView, title: String = "", description: String = "") {
            let ani: UIView = .init()
            ani.add(to: view).w(80).e()
            ani.add(to: view).h(72).e()
            ani.add(to: view).x().e()

            let path: UIBezierPath = .init()
            path.move(to: .init(x: 6, y: 6))
            path.addLine(to: .init(x: 74, y: 66))
            path.move(to: .init(x: 74, y: 6))
            path.addLine(to: .init(x: 6, y: 66))

            let layer: CAShapeLayer = .init()
            layer.frame = .init(x: 0, y: 00, width: 80, height: 72)
            layer.path = path.cgPath

            layer.fillMode    = .forwards
            layer.lineCap     = .round
            layer.lineJoin    = .round

            layer.fillColor   = nil
            layer.strokeColor = UIColor.black.withAlphaComponent(0.6).cgColor
            layer.lineWidth   = 7.0
            ani.layer.addSublayer(layer)
            layer.position = .init(x: 40, y: 36)
            layer.anchorPoint = .init(x: 0.5, y: 0.5)

            let animation: CAKeyframeAnimation = .init(keyPath: "strokeEnd")
            animation.values = [0, 1]
            animation.keyTimes = [0, 1]
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            layer.add(animation, forKey: "checkmarkStrokeAnim")

            switch [title.isEmpty, description.isEmpty] {
            case [false, true]:
                ani.add(to: view).y(10).e()
                HUD.initT(str: title, view: view).t(28).e()

            case [true, false]:
                ani.add(to: view).y(-16).e()
                HUD.initD(str: description, view: view).t().q(ani).b(15).e()

            case [false, false]:
                ani.add(to: view).y().e()
                HUD.initT(str: title, view: view).t(20).e()
                HUD.initD(str: description, view: view).t().q(ani).b(15).e()

            default:
                ani.add(to: view).y(-10).e()
            }
        }

        @discardableResult public static func content(_ content: @escaping (UIView) -> ()) -> HUD? { Self.shared?.content(content) }
        @discardableResult public static func content(type: `Type`, title: String = "", description: String = "") -> HUD? { Self.shared?.content(type: type, title: title, description: description) }
        @discardableResult public static func show(style: Style? = .jelly, completion: ((VC) -> ())? = nil) -> HUD? { Self.shared?.show(style: style, completion: completion) }
        @discardableResult public static func show(style: Style? = .jelly, completion: @escaping () -> ()) -> HUD? { Self.shared?.show(style: style, completion: completion) }
        @discardableResult public static func hide(delay: TimeInterval = 0, style: Style? = .general, completion: (() -> ())? = nil) -> HUD? { self.shared?.hide(delay: delay, style: style, completion: completion) }

        required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        private init?(_:()) {
            if #available(iOS 13.0, *) {
                if Self.scene == nil { Self.scene = UIApplication.shared.connectedScenes.filter ({ $0.activationState == .foregroundActive }).first as? UIWindowScene }
                guard let scene = Self.scene else { return nil }
                super.init(windowScene: scene)
                self.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            } else {
                super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            }
            
            self.windowLevel = UIWindow.Level.alert - 1
        }

        private weak var vc: VC? = nil
        private lazy var content: ((UIView) -> ())? = nil

        public class VC: UIViewController {
            private let style: Style?, content: ((UIView) -> ())?, size: CGFloat, showed: (VC) -> (((VC) -> ())?)

            init (style: Style? = .jelly, content: ((UIView) -> ())? = nil, showed: @escaping (VC) -> (((VC) -> ())?)) {
                self.style = style
                self.content = content
                self.showed = showed
                self.size = 165
                super.init(nibName: nil, bundle: nil)
            }

            required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

            private lazy var box: UIView = .init()
            private lazy var cover: UIView = .init()
            private lazy var container: UIView = .init()

            public override func viewDidLoad() {
                super.viewDidLoad()

                self.cover.backgroundColor = .init(white: 0.0, alpha: 0.25)

                self.cover.alpha = 0
                self.cover.add(to: self.view).t().e()
                self.cover.add(to: self.view).b().e()
                self.cover.add(to: self.view).l().e()
                self.cover.add(to: self.view).r().e()
                self.cover.add(to: self.view).x().e()
                self.cover.add(to: self.view).y().e()

                self.box.alpha = 0
                self.box.layer.cornerRadius = 20
                self.box.blur(style: .light).backgroundColor = .init(white: 1, alpha: 0.36)
                self.box.add(to: self.view).x().e()
                self.box.add(to: self.view).y().e()
                self.box.add(to: self.view).w(self.size).e()
                self.box.add(to: self.view).h(self.size).e()
                
                self.container.alpha = 0.85
                self.container.layer.masksToBounds = true
                self.container.layer.cornerRadius = self.box.layer.cornerRadius
                self.container.add(to: self.box).t().e()
                self.container.add(to: self.box).b().e()
                self.container.add(to: self.box).l().e()
                self.container.add(to: self.box).r().e()
                self.container.add(to: self.box).x().e()
                self.container.add(to: self.box).y().e()

                self.content?(self.container)
            }

            public override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                let completion = self.showed(self)
                guard let style = self.style else {
                    self.box.alpha = 1
                    self.cover.alpha = 1
                    return completion?(self) ?? ()
                }

                switch style {
                    case .general:
                        self.box.transform = .init(scaleX: 0.76, y: 0.76)
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.cover.alpha = 1 }, completion: nil)
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0.1, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.alpha = 1 }, completion: nil)
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.transform = .init(scaleX: 1, y: 1) }, completion: { _ in completion?(self) })

                    case .jelly:
                        OA.Timer.delay(key: "OA.HUD.show.\(String(UInt(bitPattern: ObjectIdentifier(self))))", second: 0.1) {
                            self.box.transform = .init(scaleX: 0.65, y: 0.65)
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.cover.alpha = 1 }, completion: nil)
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.35, delay: 0, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.alpha = 1 }, completion: nil)
                            let ani = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.4, animations: { self.box.transform = .init(scaleX: 1, y: 1) })
                            ani.addAnimations { completion?(self) }
                            ani.startAnimation()
                        }
                }
                
            }

            public func hide(delay: TimeInterval = 0, style: Style? = .general, animated: Bool = true, completion: (() -> ())? = nil) {
                OA.Timer.delay(key: "OA.HUD.hide.\(String(UInt(bitPattern: ObjectIdentifier(self))))", second: delay) {

                    guard let style = style else {
                        self.box.alpha = 0
                        self.cover.alpha = 0
                        return completion?() ?? ()
                    }

                    switch style {
                        case .general:
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.cover.alpha = 0 }, completion: nil)
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.alpha = 0 }, completion: nil)
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.transform = .init(scaleX: 0.85, y: 0.85) }, completion: { _ in completion?() })

                        case .jelly:
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.cover.alpha = 0 }, completion: nil)

                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: {
                                self.box.alpha = 0.7
                                self.box.transform = .init(scaleX: 0.95, y: 0.95)
                            }, completion: { _ in
                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.15, delay: 0, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: {
                                    self.box.transform = .init(scaleX: 1.1, y: 1.1)
                                    self.box.alpha = 0.5
                                }, completion: { _ in
                                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.20, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.alpha = 0 }, completion: nil)
                                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.transform = .init(scaleX: 0.8, y: 0.8) }, completion: { _ in completion?() })
                                })
                            })
                    }
                }
            }

            public func content(_ content: @escaping (UIView) -> ()) {
                DispatchQueue.main.async {
                    self.container.constraints.forEach { self.container.removeConstraint($0) }
                    self.container.subviews.forEach { $0.removeFromSuperview() }
                    content(self.container)
                }
            }
            public func content(type: `Type`, title: String = "", description: String = "") {
                switch type {
                case .loading: return self.content { HUD.loading(view: $0, title: title, description: description) }
                case .done: return self.content { HUD.done(view: $0, title: title, description: description) }
                case .fail: return self.content { HUD.fail(view: $0, title: title, description: description) }
                }
            }
        }

        @discardableResult public func show(style: Style? = .jelly, completion: ((VC) -> ())? = nil) -> Self {
            DispatchQueue.main.async {
                self.rootViewController = VC(style: style, content: self.content) {
                    self.vc = $0
//                    completion?($0)
                    return completion
                }
                self.isHidden = false
                self.makeKeyAndVisible()
            }
            return self
        }
        @discardableResult public func show(style: Style? = .jelly, completion: @escaping() -> ()) -> Self { self.show(style: style) { _ in completion() } }

        @discardableResult public func hide(delay: TimeInterval = 0, style: Style? = .general, completion: (() -> ())? = nil) -> Self {
            DispatchQueue.main.async {
                if let vc = self.rootViewController as? VC {
                    vc.hide(delay: delay, style: style) { self.close(completion: completion) }
                } else {
                    self.close(completion: completion)
                }
            }
            return self
        }

        @discardableResult private func close(completion: (() -> ())? = nil) -> Self {
            self.vc = nil
            self.rootViewController = nil
            self.resignKey()
            self.removeFromSuperview()
            self.isHidden = true
            completion?()
            return self
        }

        @discardableResult public func content(_ content: @escaping (UIView) -> ()) -> Self {
            if let vc = self.vc {
                vc.content(content)
                return self
            }
            self.content = content
            return self
        }

        @discardableResult public func content(type: `Type`, title: String = "", description: String = "") -> Self {
            if let vc = self.vc {
                vc.content(type: type, title: title, description: description)
                return self
            }

            switch type {
            case .loading: return self.content { HUD.loading(view: $0, title: title, description: description) }
            case .done: return self.content { HUD.done(view: $0, title: title, description: description) }
            case .fail: return self.content { HUD.fail(view: $0, title: title, description: description) }
            }
        }
    }
}
