//
//  ViewController.swift
//  HMLibrary_iOS
//
//  Created by galenu on 12/24/2023.
//  Copyright (c) 2023 galenu. All rights reserved.
//

import UIKit
import HMLibrary_iOS

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
    
}

