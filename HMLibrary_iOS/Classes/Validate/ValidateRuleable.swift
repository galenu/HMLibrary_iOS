//
//  ValidateRule.swift
//  JCXX
//
//  Created by gavin on 2023/7/26.
//

import UIKit

/// 校验规则协议
public protocol ValidateRuleable {
    
    /// 错误提示
    var msg: String? { get set }
}

/// 自定义校验规则
public struct ValidateCustomRule: ValidateRuleable {
    
    /// 错误提示
    public var msg: String?
    
    /// 校验回调
    public var validateHandler: (() -> ValidateResult)
    
    public init(msg: String, validateHandler: @escaping (() -> ValidateResult)) {
        self.msg = msg
        self.validateHandler = validateHandler
    }
}

/// 正则校验规则
public struct ValidateRegexRule: ValidateRuleable {
    
    /// 校验正则表达式
    public var regex = ""
    
    /// 错误提示
    public var msg: String?
    
    public init(regex: String, msg: String? = nil) {
        self.regex = regex
        self.msg = msg
    }
    
    /// 校验文本text是否通过正则表达式
    public func isPass() -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", self.regex).evaluate(with: self.msg)
    }
}
