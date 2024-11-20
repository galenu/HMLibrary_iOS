//
//  HMPopup+Extension.swift
//  HMLibrary_iOS
//
//  Created by CNCEMN188807 on 2023/12/25.
//

import UIKit

extension HMPopup {
    
    class func endEditing() {
        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        keyWindow.endEditing(true)
    }
    
    class func rootViewController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return nil }
        guard let rootVC = keyWindow.rootViewController else { return nil }
        return rootVC
    }
    
    class func getContainerVC(_ vc: UIViewController?, isPresented: Bool = true) -> UIViewController? {
        if isPresented {
            if let vc = vc {
                return self.allPresentedControllers(for: vc).last
            } else {
                if let rootVC = rootViewController() {
                    return self.allPresentedControllers(for: rootVC).last
                }
                return nil
            }
        } else {
            if let vc = vc {
                return vc
            } else {
                let rootVC = rootViewController()
                return rootVC
            }
        }
    }
    
    class func allPresentedControllers(for vc: UIViewController) -> [UIViewController] {
        var preVC = vc
        var presentedControllers = [vc]
        while let presentedViewController = preVC.presentedViewController {
            presentedControllers.append(presentedViewController)
            preVC = presentedViewController
        }
        return presentedControllers
    }
    
    class func allPopupMask(name: String? = nil, for vc: UIViewController? = nil) -> [HMPopupMaskVC]? {
        guard let containerVC = self.getContainerVC(vc, isPresented: false) else { return nil }
        
        guard let allPopups = self.allPresentedControllers(for: containerVC).filter({ vc in
            return vc.isKind(of: HMPopupMaskVC.self)
        }) as? [HMPopupMaskVC] else {
            return nil
        }
        let filterPopups = allPopups.filter { popup in
            return popup.attribute.name == name
        }
        return filterPopups
    }
}
