//
//  I18nBundle.swift
//  HMLibrary_iOS
//
//  Created by CNCEMN188807 on 2024/4/25.
//

import UIKit

public class I18nBundle {
    
    /// 模块化资源的语言bundle，nil表示设置默认语言
    public var lprojBundle: Bundle?
    
    /// 如果从指定语言的bundle未读取到值，则默认从该Bundle中读取
    public var defaultBundleWhenValueEmpty: Bundle?
    
    public init(lprojBundle: Bundle? = nil, defaultBundleWhenValueEmpty: Bundle? = nil) {
        self.lprojBundle = lprojBundle
        self.defaultBundleWhenValueEmpty = defaultBundleWhenValueEmpty
    }
}
