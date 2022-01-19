//
//  OA.HUD.swift
//  OAKit
//
//  Created by 吳政賢 on 2021/12/28.
//

import Foundation

import UIKit

public extension OA {
    enum HUD {
        public enum Icon {
            case loading, done, fail
        }
    
        @available(iOS 13.0, *)
        public static var scene: UIWindowScene? = nil
        public static var window: UIWindow? = nil
    
        @discardableResult
        public static func show(icon: Icon, title: String? = nil, description: String? = nil, animated: Bool = true, completion: ((VC) -> ())? = nil) -> HUD.Type {
            if #available(iOS 13.0, *) {
                if Self.scene == nil { Self.scene = UIApplication.shared.connectedScenes.filter ({ $0.activationState == .foregroundActive }).first as? UIWindowScene }
                guard let scene = Self.scene else { return HUD.self }
                self.window = .init(windowScene: scene)
                self.window?.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            } else {
                self.window = .init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            }

            self.window?.windowLevel = UIWindow.Level.alert - 1
            self.window?.rootViewController = VC(icon: icon, title: title, description: description, animated: animated, showed: { _ in completion })
            self.window?.isHidden = false
            self.window?.makeKeyAndVisible()
            return HUD.self
        }

        public static func hide(delay: TimeInterval = 0, animated: Bool = true, completion: (() -> ())? = nil) {
            OA.Timer.delay(key: "OA.HUD.hide.\(String(UInt(bitPattern: ObjectIdentifier(self))))", second: delay) {
                (self.window?.rootViewController as? VC)?.hide(animated: animated) {
                    self.window?.rootViewController = nil
                    self.window?.resignKey()
                    self.window?.removeFromSuperview()
                    self.window?.isHidden = true
                    completion?()
                }
            }
        }
        
        @discardableResult
        public static func view(icon: Icon, title: String? = nil, description: String? = nil) -> HUD.Type {
            (self.window?.rootViewController as? VC)?.content(icon: icon, title: title ?? "", description: description ?? "", animated: false, completion: nil)
            return HUD.self
        }
        
        public class VC: UIViewController {

            required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

            private var i: Icon, t: String, d: String, a: Bool, showed: (VC) -> (((VC) -> ())?), size: CGFloat

            init (icon: Icon, title: String? = nil, description: String? = nil, animated: Bool = true, showed: @escaping (VC) -> (((VC) -> ())?)) {
                self.i = icon
                self.t = title ?? ""
                self.d = description ?? ""
                self.a = animated
                self.showed = showed
                self.size = 165
                super.init(nibName: nil, bundle: nil)
            }
            
            private lazy var box: UIView = .init()
            private lazy var cover: UIView = .init()
            private lazy var container: UIView = .init()
            private lazy var anis: [UIViewPropertyAnimator] = []

            public override func viewDidLoad() {
                super.viewDidLoad()
                
                self.cover.backgroundColor = .init(white: 0.0, alpha: 0.25)

                self.cover.alpha = 0
                self.cover.add(to: self.view, enable: "t; b; l; r; x; y")
                
                self.box.alpha = 0
                self.box.layer.cornerRadius = 20
                self.box.blur(style: .light).backgroundColor = .init(white: 1, alpha: 0.36)
                self.box.add(to: self.view, enable: "x; y; w=\(self.size); h=\(self.size)")
                
                self.container.alpha = 0.85
                self.container.layer.masksToBounds = true
                self.container.layer.cornerRadius = self.box.layer.cornerRadius
                self.container.add(to: self.box, enable: "t; b; l; r; x; y")
                
                self.content(icon: self.i, title: self.t, description: self.d, animated: self.a) {
                    let completion = self.showed(self)
                    return completion?(self) ?? ()
                }
            }
            
            private func initD (str: String) -> OA.Layout {
                let label: UILabel = .init()
                label.text = str
                label.minimumScaleFactor = 0.25
                label.adjustsFontForContentSizeCategory = true
                label.textColor = .black.withAlphaComponent(0.7)
                label.font = UIFont.preferredFont(forTextStyle: .subheadline)
                label.add(to: self.container).x().e()
                return label.add(to: self.container)
            }
            private func initT (str: String) -> OA.Layout {
                let label: UILabel = .init()
                label.text = str
                label.minimumScaleFactor = 0.25
                label.adjustsFontForContentSizeCategory = true
                label.textColor = .black.withAlphaComponent(0.85)
                label.font = UIFont.preferredFont(forTextStyle: .body).bold()
                label.add(to: self.container).x().e()
                return label.add(to: self.container)
            }
            
            public func hide(animated: Bool = true, completion: (() -> ())? = nil) {
                self.anis.forEach { $0.stopAnimation(true) }
                
                guard animated else {
                    self.box.alpha = 0
                    self.cover.alpha = 0
                    return completion?() ?? ()
                }

                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.cover.alpha = 0 }, completion: nil)
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.alpha = 0 }, completion: nil)
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: { self.box.transform = .init(scaleX: 0.85, y: 0.85) }, completion: { _ in completion?() })
            }
            
            public func content(icon: Icon, title: String, description: String, animated: Bool, completion: (() -> ())? = nil) {
                self.container.constraints.forEach { self.container.removeConstraint($0) }
                self.container.subviews.forEach { $0.removeFromSuperview() }

                switch icon {
                case .loading:
                    let view: UIActivityIndicatorView
                    if #available(iOS 13.0, *) {
                        view = .init(style: .large)
                    } else {
                        view = .init()
                    }
                    view.startAnimating()
                    view.add(to: self.container, enable: "x")
                    view.color = UIColor.black.withAlphaComponent(0.6)

                    switch [title.isEmpty, description.isEmpty] {
                    case [false, true]:
                        view.add(to: self.container, enable: "y=4")
                        self.initD(str: title).t(28).e()

                    case [true, false]:
                        view.add(to: self.container, enable: "y=-8")
                        self.initD(str: description).t().q(view).b(20).e()

                    case [false, false]:
                        view.add(to: self.container, enable: "y")
                        self.initT(str: title).t(24).e()
                        self.initD(str: description).t().q(view).b(15).e()

                    default: view.add(to: self.container, enable: "y")
                    }
                case .done:
                    let ani: UIView = .init()
                    ani.add(to: view).w(90).e()
                    ani.add(to: view).h(90).e()
                    ani.add(to: view).x().e()

                    let p1: UIBezierPath = .init()
                    p1.addArc(withCenter: .init(x: 90 / 2, y: 90 / 2), radius: 90 / 2, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + 0.001, clockwise: false)

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
                        ani.add(to: self.container).y(12).e()
                        self.initT(str: title).t(16).e()

                    case [true, false]:
                        ani.add(to: self.container).y(-16).e()
                        self.initD(str: description).t().q(ani).b(15).e()

                    case [false, false]:
                        ani.add(to: self.container).y().e()
                        self.initT(str: title).t(8).e()
                        self.initD(str: description).t().q(ani).b(8).e()

                    default:
                        ani.add(to: self.container).y().e()
                    }
                case .fail:
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
                        ani.add(to:  self.container).y(10).e()
                        self.initT(str: title).t(28).e()

                    case [true, false]:
                        ani.add(to:  self.container).y(-16).e()
                        self.initD(str: description).t().q(ani).b(15).e()

                    case [false, false]:
                        ani.add(to:  self.container).y().e()
                        self.initT(str: title).t(20).e()
                        self.initD(str: description).t().q(ani).b(15).e()

                    default:
                        ani.add(to:  self.container).y(-10).e()
                    }
                }

                guard animated else {
                    self.anis.forEach { $0.stopAnimation(true) }
                    self.cover.alpha = 1
                    self.box.alpha = 1
                    self.box.transform = .init(scaleX: 1, y: 1)
                    return completion?() ?? ()
                }

                self.box.transform = .init(scaleX: 0.65, y: 0.65)
                
                self.anis.append(UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0.1, options: [.curveEaseOut, .transitionCrossDissolve, .allowUserInteraction], animations: {
                    self.cover.alpha = 1
                }, completion: { _ in
                    completion?()
                }))

                self.anis.append(UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.2, options: [.curveEaseIn, .transitionCrossDissolve, .allowUserInteraction], animations: {
                    self.box.alpha = 1
                }, completion: nil))

                let ani = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.45, animations: {
                    self.box.transform = .init(scaleX: 1, y: 1)
                })
                self.anis.append(ani)
                ani.addCompletion { _ in completion?() }
                ani.startAnimation(afterDelay: 0.2)
            }
        }
    }
}
