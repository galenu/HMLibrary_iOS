//
//  ViewController.swift
//  HMLibrary_iOS
//
//  Created by galenu on 03/05/2024.
//  Copyright (c) 2024 galenu. All rights reserved.
//

import UIKit
import HMLibrary_iOS
import CoreBluetooth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logBtnClick(_ sender: Any) {
        HMLog.debug("logBtnClick测试log日志文件logBtnClick")
    }
    
    @IBAction func lightInfoClick(_ sender: Any) {
        HMRoute.push(LightModuleRoute.lightControl(deviceId: "1234"))
    }

    @IBAction func loadingBtnClick(_ sender: Any) {
        
        self.view.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.hiddenLoading()
        }
    }
    
    @IBAction func toastBtnClick(_ sender: Any) {
        
        self.view.showToast("toast 测试信息")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.hiddenToast()
        }
    }
    
    @IBAction func popupBtnClick(_ sender: Any) {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "测试弹框"
        self.showActionSheet(label, size: .size(width: HMAPP.width, height: 300))
    }
    
}

