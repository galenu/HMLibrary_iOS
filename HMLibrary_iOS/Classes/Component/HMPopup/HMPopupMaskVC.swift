//
//  HMPopupMaskVC.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit
import SnapKit

/// 弹出框 可能有输入框 避免被键盘遮挡 用present UIViewController实现
public class HMPopupMaskVC: UIViewController {
    
    /// 弹出框属性配置
    public var attribute: HMPopupAttribute
    
    public init(attribute: HMPopupAttribute) {
        self.attribute = attribute
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(NSStringFromClass(type(of: self))) deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    private func setupUI() {
        
        self.view.clipsToBounds = true
        self.view.backgroundColor = .clear
        
        let bgBtn = UIButton()
        bgBtn.addTarget(self, action: #selector(bgClick), for: .touchUpInside)
        self.view.addSubview(bgBtn)
        bgBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func bgClick() {
        self.view.endEditing(true)
        if self.attribute.dismissWhenTapMask {
            HMPopup.dismiss(mask: self) {
                self.attribute.dismissHandlerWhenTapMask?()
            }
        }
    }
}
