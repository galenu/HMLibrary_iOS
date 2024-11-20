//
//  UITextView+Validatable.swift
//  JCXX
//
//  Created by gavin on 2023/7/27.
//

import UIKit

extension UITextView: Validatable {
    
    /// 结束编辑时进行校验
    public func validateOnEditingDidEnd(_ enabled: Bool) {
        if enabled {
            NotificationCenter.default.addObserver(self, selector: #selector(self.validateEditingDidEnd), name: UITextView.textDidEndEditingNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
        }
    }
    
    /// 输入改变时进行校验
    public func validateOnEditingChanged(_ enabled: Bool) {
        if enabled {
            NotificationCenter.default.addObserver(self, selector: #selector(self.validateEditingChanged), name: UITextView.textDidChangeNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        }
    }
    
    @objc private func validateEditingDidEnd() {
        self.validateFormat(text: self.text)
    }
    
    @objc private func validateEditingChanged() {
        self.validateFormat(text: self.text)
    }
}
