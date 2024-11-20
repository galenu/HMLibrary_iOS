//
//  LanguageManager.swift
//  JCXX
//
//  Created by gavin on 2023/8/12.
//

import UIKit
import HMLibrary_iOS

/// 语言类型
public enum LanguageType: String, CaseIterable {

    /// 英语
    case en = "English"

    /// 简体中文
    case zhHans = "zh-Hans"

    /// 繁体中文
    case zhHant = "zh-Hant"
    
    case fr = "fr"
    
    case ja = "ja"
}

/// 显示语言, 根据语言读取本地化资源
public class LanguageManager {
    
    public static let shared = LanguageManager()
    
    /// 模块化资源的语言bundle，nil表示设置默认语言
    static var i18nBundle = I18nBundle()
    
    private init() {
        
    }

    /// 设置选择的语言，type = nil表示设置默认语言
    /// - Parameter type: LanguageType
    static func setLanguage(type: LanguageType?) {
        
        if let lprojBundlePath = Bundle.main.path(forResource: type?.rawValue, ofType: ".lproj") {
            self.i18nBundle.lprojBundle = Bundle(path: lprojBundlePath)
        }
        
        if let enBundlePath = Bundle.main.path(forResource: LanguageType.en.rawValue, ofType: ".lproj") {
            self.i18nBundle.defaultBundleWhenValueEmpty = Bundle(path: enBundlePath)
        }
        I18n.updateLanguage(i18nBundleId: "HMLibrary_iOS", bundle: self.i18nBundle)
    }
}
