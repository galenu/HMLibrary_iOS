//
//  HMTagViewDelegate.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/1/9.
//

import UIKit

/// TagViewDelegate
public protocol HMTagViewDelegate: AnyObject {
    
    /// tag 布局
    /// - Parameter tagView: TagView
    /// - Returns: UICollectionViewAlignFlowLayout
    func tagViewFlowLayout(_ tagView: HMTagView) -> UICollectionViewFlowLayout
    
    /// 注册tag类型的 CollectionCell
    /// - Parameters:
    ///   - tagView: TagView
    ///   - collectionView: UICollectionView
    func tagView(_ tagView: HMTagView, registerTagCellFor collectionView: UICollectionView)
    
    /// tag分组数量
    /// - Parameter tagView: TagView
    /// - Returns: NumberOfSections
    func tagViewNumberOfSections(_ tagView: HMTagView) -> Int
    
    /// 每组的tag数量
    /// - Parameters:
    ///   - tagView: TagView
    ///   - section: 组
    /// - Returns: 每组数量
    func tagView(_ tagView: HMTagView, numberOfItemsInSection section: Int) -> Int
    
    /// 自定义每组的TagCell
    /// - Parameters:
    ///   - tagView: TagView
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    /// - Returns: UICollectionViewCell
    func tagView(_ tagView: HMTagView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    /// 选中某个tag事件
    /// - Parameters:
    ///   - tagView: TagView
    ///   - indexPath: indexPath
    func tagView(_ tagView: HMTagView, didSelectItemAt indexPath: IndexPath)
    
    /// tag contentSize计算完毕回调
    /// - Parameters:
    ///   - tagView: TagView
    ///   - size: tagView的contentSize
    func tagView(_ tagView: HMTagView, contentSizeChanged size: CGSize)
}

extension HMTagViewDelegate {
    
    public func tagViewNumberOfSections(_ tagView: HMTagView) -> Int {
        return 1
    }
    
    public func tagView(_ tagView: HMTagView, didSelectItemAt indexPath: IndexPath) { }
    
    public func tagView(_ tagView: HMTagView, contentSizeChanged size: CGSize) { }
}
