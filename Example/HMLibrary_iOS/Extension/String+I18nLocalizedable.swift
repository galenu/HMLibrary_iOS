//
//  String+I18nLocalizedable.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/27.
//

import HMLibrary_iOS
//import RswiftResources

/// 国际化文本协议
protocol I18nLocalizedable {
    
    /// 国际化key
    var localizedKey: String{ get }
    
    /// 国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]?) -> String
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]?) -> I18nTextDynamicBlock
}

extension I18nLocalizedable {
    
    /// 国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> String {
        return I18n.localized(localizedKey, bundle: LanguageManager.i18nBundle, args: args)
    }
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18n.localized(localizedKey, bundle: { LanguageManager.i18nBundle }, args: args)
    }
}

// MARK: - 默认给String添加国际化方法
extension String: I18nLocalizedable {
    
    var localizedKey: String {
        return self
    }
}

//extension StringResource: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
//
//extension StringResource1: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
//
//extension StringResource2: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
//
//extension StringResource3: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
