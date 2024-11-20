//
//  HMRoute.swift
//  HMLibrary_iOS
//
//  Created by CNCEMN188807 on 2023/12/30.
//

import URLNavigator

/// 路由跳转
public struct HMRoute {

    /// 全局导航
    public static let navigator = Navigator()
    
    /// 通过url跳转
    @discardableResult
    public static func push(_ url: URLConvertible,
                            context: Any? = nil,
                            from: UINavigationControllerType? = nil,
                            animated: Bool = true) -> UIViewController? {
        return self.navigator._push(url, context: context, from: from, animated: animated)
    }
    
    /// 通过url跳转
    @discardableResult
    public static func present(_ url: URLConvertible,
                               context: Any? = nil,
                               wrap: UINavigationController.Type? = UINavigationController.self,
                               from: UIViewControllerType? = nil,
                               animated: Bool = true,
                               completion: (() -> Void)? = nil) -> UIViewController? {
        return self.navigator.present(url, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    /// 通过url跳转
    @discardableResult
    public static func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
        return self.navigator.viewController(for: url, context: context)
    }

    /// navigator.push  通过RouteTarget协议统一参数格式，可能由h5页面打开某一页，h5仅支持url传参数，所以统一用url传参, 禁止context传参
    /// - Parameters:
    ///   - target: RouteTarget协议将参数拼接入注册和打开的url
    ///   - from: UINavigationControllerType
    ///   - animated: animated
    /// - Returns: UIViewController
    @discardableResult
    public static func push(_ route: HMRouteable,
                            context: Any? = nil,
                            from: UINavigationControllerType? = nil,
                            animated: Bool = true) -> UIViewController? {
        let url = route.toURLConvertible()
        return self.push(url, context: context, from: from, animated: animated)
    }

    /// navigator.present  通过RouteTarget协议统一参数格式，可能由h5页面打开某一页，h5仅支持url传参数，所以统一用url传参, 禁止context传参
    /// - Parameters:
    ///   - target: RouteTarget协议将参数拼接入注册和打开的url
    ///   - wrap: UINavigationController
    ///   - from: UIViewControllerType
    ///   - animated: animated
    ///   - completion: completion
    /// - Returns: UIViewController
    @discardableResult
    public static func present(_ route: HMRouteable,
                               context: Any? = nil,
                               wrap: UINavigationController.Type? = UINavigationController.self,
                               from: UIViewControllerType? = nil,
                               animated: Bool = true,
                               completion: (() -> Void)? = nil) -> UIViewController? {
        let url = route.toURLConvertible()
        return self.present(url, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    /// 根据RouteTarget获取ViewController
    /// - Parameter target: RouteTarget
    /// - Returns: UIViewController
    @discardableResult
    public static func viewController(for route: HMRouteable, context: Any? = nil) -> UIViewController? {
        let url = route.toURLConvertible()
        return self.viewController(for: url, context: context)
    }
}

extension Navigator {
    
    fileprivate func _push(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        guard let viewController = self.viewController(for: url, context: context) else { return nil }
        guard (viewController is UINavigationController) == false else { return nil }
        guard let topMostVC = UIViewController.topMost else { return nil }
        guard let navigationController = from ?? topMostVC.navigationController else { return nil }
        guard self.delegate?.shouldPush(viewController: viewController, from: navigationController) != false else { return nil }
        topMostVC.push(to: viewController, animated: animated)
        return viewController
    }
    
    /// 通过RouteTarget注册路由到Route.navigator
    public func register(routeable: HMRouteable, _ factory: @escaping ViewControllerFactory) {
        let registerUrl = routeable.baseUrl + routeable.path
        self.register(registerUrl, factory)
    }
}
