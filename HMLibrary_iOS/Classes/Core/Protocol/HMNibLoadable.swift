//
//  HMNibLoadable.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/24.
//

import UIKit

/// 从Nib中加载
extension UIView {
    
    /// 从xib中加载  xib名称 默认类名
    /// - Parameters:
    ///   - nibName: xib name  默认类名
    ///   - bundle: Bundle  默认调用类所在Bundle  Bundle(for: self)
    /// - Returns: UIView
    public static func loadFromNib(nibName: String? = nil, owner: Any? = nil, bundle: Bundle? = nil) -> Self {
        var name = String(describing: self)
        if let nibName = nibName {
            name = nibName
        }
        var targetBundle = Bundle(for: self)
        if let bundle = bundle {
            targetBundle = bundle
        }
        guard let view = targetBundle.loadNibNamed(name, owner: owner, options: nil)?.first as? Self else {
            fatalError("Load view:\(name) failed from xib, bunlde:\(targetBundle)")
        }
        return view
    }
}

extension UIViewController {
    
    /// 从xib中加载UIViewController  xib名称必须与类名一致
    /// - Parameters:
    ///   - nibName: xib name  默认类名
    ///   - bundle: Bundle  默认调用类所在Bundle  Bundle(for: self)
    ///   - Returns: UIViewController
    public static func loadFromNib(nibName: String? = nil, bundle: Bundle? = nil) -> Self {
        var name = String(describing: self)
        if let nibName = nibName {
            name = nibName
        }
        var targetBundle = Bundle(for: self)
        if let bundle = bundle {
            targetBundle = bundle
        }
        return Self.init(nibName: name, bundle: targetBundle)
    }
    
    /// 从Storyboard加载UIViewController  StoryBoard ID必须与类名一致
    /// - Parameter name: Storyboard name
    /// - Parameter bundle: 默认调用类所在Bundle  Bundle(for: self)
    /// - Returns: UIViewController
    public static func loadFromStoryboard(name: String, bundle: Bundle? = nil) -> Self {
        let identifier = String(describing: self)
        var targetBundle = Bundle(for: self)
        if let bundle = bundle {
            targetBundle = bundle
        }
        guard let vc = UIStoryboard(name: name, bundle: targetBundle).instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Load viewController:\(identifier) failed from Storyboard:\(name) bunlde:\(targetBundle)")
        }
        return vc
    }
}
