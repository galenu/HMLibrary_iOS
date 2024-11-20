//
//  HMNavigationable.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

/// push模式
public enum HMNavigationPushMode: Int {
    
    /// 系统默认push
    case `default`
    
    /// 如果栈里面已经存在VC，则pop到已存在的VC，如果不存在则push到VC
    case popWhenExist
}

/// pop模式
public enum HMNavigationPopMode: Int {
    
    /// pop到上一页
    case lastPage
    
    /// pop到root
    case root
}

/// UINavigationController跳转协议
public protocol HMNavigationable {
    
    /// push或pop到controller
    func push(to controller: UIViewController, mode: HMNavigationPushMode, cycleStep: Int, animated: Bool) -> UIViewController?
    
    /// 返回到指定类型中的页面。返回时会匹配到一个即执行。主要用于解决不同场景下，多入口返回到指定页面的问题
    func pop(to controllerTypes: [AnyClass]?, mode: HMNavigationPopMode, animated: Bool) -> UIViewController?
    
    /// 从navigationController的栈中查找第一个某个类型的控制器
    /// - Parameter controllerType: 控制器类型
    /// - Returns: UIViewController
    func firstViewController(for controllerType: AnyClass) -> UIViewController?
    
    /// 从导航栏移除控制器
    func removeNavigationViewControllers(_ controllerTypes: [AnyClass])
}

extension HMNavigationable {
    
    /// push或pop到controller
    /// - Parameters:
    ///   - controller: push的目标vc
    ///   - mode: push模式
    ///   - cycleStep: 栈里最大可循环的步长  eg:  1:  A push B push  A, 第二个A实际是pop到第一个
    ///   - animated: 是否动画
    /// - Returns: push或pop的目标vc
    @discardableResult
    public func push(to controller: UIViewController,
                     mode: HMNavigationPushMode = .popWhenExist,
                     cycleStep: Int = 1,
                     animated: Bool = true) -> UIViewController? {
        guard (controller is UINavigationController) == false else { return nil }
        guard let naVC = UIViewController.showingController()?.navigationController else { return nil }
        
        switch mode {
        case .default:
            naVC._push(vc: controller, animated: animated)
            return controller
        case .popWhenExist:
            let targetControllers = naVC.viewControllers.filter{ $0.isKind(of: controller.classForCoder) }
            if targetControllers.count >= cycleStep {
                guard let popToVC = targetControllers.last else { return nil }
                naVC.popToViewController(popToVC, animated: animated)
                return popToVC
            } else {
                naVC._push(vc: controller, animated: animated)
                return controller
            }
        }
    }
    
    /// 返回到指定类型中的页面。返回时会匹配到一个即执行。主要用于解决不同场景下，多入口返回到指定页面的问题
    /// - Parameters:
    ///   - controllerTypes: 返回层级，按此顺序返优先返回
    ///   - mode: 未找到置顶类型默认 返回类型
    ///   - animated: 是否动画
    /// - Returns: 返回到的vc
    @discardableResult
    public func pop(to controllerTypes: [AnyClass]? = nil,
                    mode: HMNavigationPopMode = .lastPage,
                    animated: Bool = true) -> UIViewController? {
        
        guard let naVC = UIViewController.showingController()?.navigationController else { return nil }
        
        func _popVC(mode: HMNavigationPopMode) {
            switch mode {
            case .lastPage:
                naVC.popViewController(animated: animated)
            case .root:
                naVC.popToRootViewController(animated: animated)
            }
        }
        
        if let controllerTypes = controllerTypes {
            var popToVC: UIViewController?
            for type in controllerTypes {
                if let vc = naVC.viewControllers.first(where: { return $0.isKind(of: type) }) {
                    popToVC = vc
                    break
                }
            }
            if let popToVC = popToVC { // 栈里面存在vc 直接回退
                naVC.popToViewController(popToVC, animated: animated)
                return popToVC
            } else {
                _popVC(mode: mode)
                return naVC.viewControllers.last
            }
        } else {
            _popVC(mode: mode)
            return naVC.viewControllers.last
        }
    }
    
    /// 从navigationController的栈中查找第一个某个类型的控制器
    /// - Parameter controllerType: 控制器类型
    /// - Returns: UIViewController
    public func firstViewController(for controllerType: AnyClass) -> UIViewController? {
        guard let naVC = UIViewController.showingController()?.navigationController else { return nil }
        let vc = naVC.viewControllers.first(where: { $0.isKind(of: controllerType) })
        return vc
    }
    
    /// 从导航栏移除控制器
    /// - Parameter controllerTypes: 移除控制器的类型数组
    public func removeNavigationViewControllers(_ controllerTypes: [AnyClass]) {
        guard let naVC = UIViewController.showingController()?.navigationController else { return }
        naVC.viewControllers.removeAll { vc in
            return controllerTypes.contains { type in
                return vc.isKind(of: type)
            }
        }
    }
}

extension UINavigationController {
    fileprivate func _push(vc: UIViewController, animated: Bool = true) {
        if self.viewControllers.count == 1 {
            vc.hidesBottomBarWhenPushed = true
        }
        self.pushViewController(vc, animated: animated)
    }
}

/// UIViewController默认遵循Navigationable协议
extension UIViewController: HMNavigationable { }

extension UIViewController {
    
    /// 获取当前显示的viewController
    /// - Returns: 当前显示viewController
    public static func showingController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return nil }
        guard let rootVC = keyWindow.rootViewController else { return nil }
        return self.showingController(of: rootVC)
    }
    
    /// 寻找controller上显示的VC
    /// - Parameter controller: 根控制器
    /// - Returns: 当前显示viewController
    public static func showingController(of controller: UIViewController) -> UIViewController {
        if let presentedVC = controller.presentedViewController {
            return self.showingController(of: presentedVC)
        } else if let navigationVC = controller as? UINavigationController, let topVC = navigationVC.visibleViewController {
            return self.showingController(of: topVC)
        } else if let tabbarVC = controller as? UITabBarController, let selectedVC = tabbarVC.selectedViewController {
            return self.showingController(of: selectedVC)
        } else if let pageVC = controller as? UIPageViewController, let firstVC = pageVC.viewControllers?.first {
            return self.showingController(of: firstVC)
        } else {
//            for subview in controller.view.subviews {
//                if let childVC = subview.next as? UIViewController {
//                    return self.showedController(of: childVC)
//                }
//            }
        }
        return controller
    }
    
    /// navigationController.pop  或 self.dismiss
    /// - Parameters:
    ///   - animated: animated
    ///   - completion: completion
    public func popOrDismissVC(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationVC = self.navigationController, navigationVC.viewControllers.count > 1 {
            navigationVC.popViewController(animated: animated)
        } else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    /// dissmiss所有模态Controller
    /// - Parameters:
    ///   - animated: animated
    ///   - completion: completion
    public func dissmissAllModalVC(animated: Bool = true, completion : (() -> Void)? = nil) {
        var rootVC = self
        while rootVC.presentingViewController != nil {
            rootVC = rootVC.presentingViewController ?? self
        }
        rootVC.dismiss(animated: animated, completion: completion)
    }
}
