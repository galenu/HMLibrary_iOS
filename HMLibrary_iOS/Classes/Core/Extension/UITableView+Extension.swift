//
//  UITableView+Extension.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/22.
//

import UIKit

extension UITableView {

    /// 根据约束布局计算header高度
    public func tableHeaderViewSizeToFit(){
        if let headerView = self.tableHeaderView {
            headerView.setNeedsLayout()
            // 立马布局子视图
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            /// 高度未发生变化不更新
            if height == frame.height {
                return
            }
            frame.size.height = height
            headerView.frame = frame
            // 重新设置tableHeaderView
            self.tableHeaderView = headerView
        }
    }
}
