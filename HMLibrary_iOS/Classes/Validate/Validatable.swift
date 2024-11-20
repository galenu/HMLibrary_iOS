//
//  Validatable.swift
//  JCXX
//
//  Created by gavin on 2023/7/26.
//

import UIKit
import RxSwift
import RxCocoa

/// 校验协议
public protocol Validatable {
        
    /// 设置校验规则 支持正则和自定义
    var validateRules: [ValidateRuleable] { get set }
    
    /// 校验所有结果Subject
    var validateResults: BehaviorRelay<[ValidateResult]> { get set }
    
    /// 校验最终结果Subject
    var validateResult: BehaviorRelay<ValidateResult> { get set }
    
    /// 验证格式
    /// - Parameter text: 验证文本
    /// - Returns: 逐步校验所有的结果
    @discardableResult
    func validateFormat(text: String?) -> [ValidateResult]
}

private var ValidateRulesKey: Void?
private var ValidateResultsKey: Void?
private var ValidateResultKey: Void?

public extension Validatable where Self: UIView {
        
    /// 所有校验规则
    var validateRules: [ValidateRuleable] {
        get { objc_getAssociatedObject(self, &ValidateRulesKey) as? [ValidateRuleable] ?? [] }
        set { objc_setAssociatedObject(self, &ValidateRulesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 校验所有结果Subject
    var validateResults: BehaviorRelay<[ValidateResult]> {
        get {
            if let obj = objc_getAssociatedObject(self, &ValidateResultsKey) as? BehaviorRelay<[ValidateResult]> {
                return obj
            } else {
                let defaultObj = BehaviorRelay(value: [ValidateResult.none])
                self.validateResults = defaultObj
                return defaultObj
            }
        }
        set {
            objc_setAssociatedObject(self, &ValidateResultsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 校验最终结果Subject
    var validateResult: BehaviorRelay<ValidateResult> {
        get {
            if let obj = objc_getAssociatedObject(self, &ValidateResultKey) as? BehaviorRelay<ValidateResult> {
                return obj
            } else {
                let defaultObj = BehaviorRelay(value: ValidateResult.none)
                self.validateResult = defaultObj
                return defaultObj
            }
        }
        set {
            objc_setAssociatedObject(self, &ValidateResultKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 验证格式
    /// - Parameter text: 验证文本
    /// - Returns: 逐步校验所有的结果
    @discardableResult
    func validateFormat(text: String?) -> [ValidateResult] {
        let text = text ?? ""
        if text.isEmpty {
            let emptyResults = [ValidateResult.none]
            self.validateResults.accept(emptyResults)
            self.validateResult.accept(emptyResults.toResult())
            return emptyResults
        }
        var validateResults = [ValidateResult]()
        for rule in self.validateRules {
            if let rule = rule as? ValidateRegexRule { // 正则表达式校验规则
                if rule.regex.isEmpty {
                    validateResults.append(.none)
                } else {
                    if rule.isPass() {
                        validateResults.append(.ok)
                    } else {
                        let errorMsg = rule.msg ?? ""
                        validateResults.append(.failed(msg: errorMsg))
                    }
                }
            } else if var rule = rule as? ValidateCustomRule { // 自定义校验规则
                let result = rule.validateHandler()
                switch result {
                case let .failed(message):
                    rule.msg = message
                default:
                    break
                }
                validateResults.append(result)
            }
        }
        self.validateResults.accept(validateResults)
        self.validateResult.accept(validateResults.toResult())
        return validateResults
    }
}

extension Array where Self.Element == ValidateResult {
    
    /// 将[ValidatorResult]转换成ValidatorResult
    public func toResult() -> ValidateResult {
        if let result = self.first(where: { !$0.ok }) { // 有一个未通过都视为失败
            return result
        } else if let result = self.last(where: { $0.ok }) { // 全部通过则表示校验成功
            return result
        }
        return .ok
    }
}
