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
    
    /// 给tableView按分组画阴影圆角边框
    /// - Parameters:
    ///   - cell: UITableViewCell
    ///   - indexPath: IndexPath
    public func drawSectionShadowCorners(cell: UITableViewCell,
                                         indexPath: IndexPath,
                                         backgroundColor: UIColor?,
                                         shadowColor: UIColor? = nil,
                                         borderColor: UIColor? = nil,
                                         cornerRadius: CGFloat = 12) {
        // 每组行数
        let rowCount = self.numberOfRows(inSection: indexPath.section)
        if rowCount == 0 {
            return
        }
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        // 圆角弧度半径
        let cornerRadius: CGFloat = cornerRadius
        let bounds = cell.bounds
        
        // 分组边框
        var borderLayer: CAShapeLayer?
        let borderPath = CGMutablePath()
        if let borderColor = borderColor {
            let layer = CAShapeLayer()
            layer.frame = bounds
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = borderColor.cgColor
            borderLayer = layer
        }
        
        // 分组圆角
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.fillColor = backgroundColor?.cgColor
        cornerLayer.strokeColor = UIColor.clear.cgColor
        var cornerPath = UIBezierPath(rect: bounds)
        
        // 分组圆角阴影
        if rowCount == 1 { // 只有1行 画全圆角
            cornerLayer.addShadow(positions: [.all], shadowColor: shadowColor)
            
            cornerPath = UIBezierPath(roundedRect: cornerLayer.frame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            if let borderLayer = borderLayer {
                borderPath.addRoundedRect(in: borderLayer.frame, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
            }
        } else { // 多行
            if indexPath.row == 0 { // 第一行 画上半圆角
                
                cornerLayer.addShadow(positions: [.left, .top, .right], shadowColor: shadowColor)
                cornerPath = UIBezierPath(roundedRect: cornerLayer.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                
                if let borderLayer = borderLayer {
                    borderPath.move(to: CGPoint(x: borderLayer.frame.minX, y: borderLayer.frame.maxY))
                    borderPath.addArc(tangent1End: CGPoint(x: borderLayer.frame.minX, y: borderLayer.frame.minY), tangent2End: CGPoint(x: borderLayer.frame.midX, y: borderLayer.frame.minY), radius: cornerRadius)
                    borderPath.addArc(tangent1End: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.minY), tangent2End: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.midY), radius: cornerRadius)
                    borderPath.addLine(to: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.maxY))
                }
            } else if indexPath.row == rowCount - 1 { // 最后一行 画下半圆角
                cornerLayer.addShadow(positions: [.left, .bottom, .right], shadowColor: shadowColor)
                cornerPath = UIBezierPath(roundedRect: cornerLayer.frame, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                
                if let borderLayer = borderLayer {
                    borderPath.move(to: CGPoint(x: borderLayer.frame.minX, y: borderLayer.frame.minY))
                    borderPath.addArc(tangent1End: CGPoint(x: borderLayer.frame.minX, y: borderLayer.frame.maxY), tangent2End: CGPoint(x: borderLayer.frame.midX, y: borderLayer.frame.maxY), radius: cornerRadius)
                    borderPath.addArc(tangent1End: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.maxY), tangent2End: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.midY), radius: cornerRadius)
                    borderPath.addLine(to: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.minY))
                }
            } else { // 中间行 不画圆角
                cornerLayer.addShadow(positions: [.left, .right], shadowColor: shadowColor)
                cornerPath = UIBezierPath(rect: cornerLayer.frame)
                
                if let borderLayer = borderLayer {
                    borderPath.move(to: CGPoint(x: borderLayer.frame.minX, y: borderLayer.frame.minY))
                    borderPath.addLine(to: CGPoint(x: borderLayer.frame.minX, y: borderLayer.frame.maxY))
                    borderPath.move(to: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.minY))
                    borderPath.addLine(to: CGPoint(x: borderLayer.frame.maxX, y: borderLayer.frame.maxY))
                }
            }
        }
        
        let bgView = UIView(frame: bounds)
        bgView.backgroundColor = .clear
        // 分组圆角
        cornerLayer.path = cornerPath.cgPath
        bgView.layer.insertSublayer(cornerLayer, at: 0)
        
        // 分组边框
        if let borderLayer = borderLayer {
            borderLayer.path = borderPath
            bgView.layer.insertSublayer(borderLayer, below: cornerLayer)
        }
        cell.backgroundView = bgView
    }
}
