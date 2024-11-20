//
//  HMNavigationController.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit

public class HMNavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.isNavigationBarHidden = true
        self.navigationBar.isTranslucent = false
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        self.modalPresentationStyle = .fullScreen
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}

extension HMNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 2 {
            let index = self.viewControllers.count - 2
            if let vc = self.viewControllers.safeValue(index), vc.removeWhenPush {
                self.viewControllers.remove(at: index)
            }
        }
    }
}

extension HMNavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count > 1, let vc = self.topViewController, vc.enablePopGecture {
            return true
        }
        return false
    }
}

private var enablePopGectureKey: Void?
private var removeWhenPushKey: Void?

extension UIViewController {

    /// 是否可以滑动返回
    public var enablePopGecture: Bool {
        get {
            return objc_getAssociatedObject(self, &enablePopGectureKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &enablePopGectureKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 当Push的时候从栈里移除的标记
    public var removeWhenPush: Bool {
        get {
            return objc_getAssociatedObject(self, &removeWhenPushKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &removeWhenPushKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

