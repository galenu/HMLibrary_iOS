//
//  LightInfoVC.swift
//  HMLibrary_iOS_Example
//
//  Created by CNCEMN188807 on 2023/12/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class LightInfoVC: UIViewController {
    
    init(deviceId: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
