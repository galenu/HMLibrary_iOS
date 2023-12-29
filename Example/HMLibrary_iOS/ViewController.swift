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
        HMLog.debug("测试log日志文件")
        
        HMLog.info("infoinfoinfo测试log日志文件21111111111111111")
        HMLog.error("errorerrorerrorerrorerror测试log日志文件errorerrorerrorerror")
    }

    @IBAction func logBtnClick(_ sender: Any) {
        
        HMLog.verbose("logBtnClick测试log日志文件logBtnClick")
    }
    
}

