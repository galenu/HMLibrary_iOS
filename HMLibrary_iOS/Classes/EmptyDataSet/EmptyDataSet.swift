//
//  EmptyDataSet.swift
//  JCXX
//
//  Created by gavin on 2023/7/20.
//

import UIKit
import SnapKit

private var emptyDataViewKey: Void?
private var loadFailedViewKey: Void?
private var hiddenEmptyDataSetWhenFirstReloadKey: Void?

/// 保证UITableView UICollectionView的方法只被交换一次
private var hasSwizzledUITableViewReloadData = false
private var hasSwizzledUICollectionViewReloadData = false

extension UIView {
        
    /// 空数据占位视图
    fileprivate var emptyDataView: UIView? {
        get {
            return objc_getAssociatedObject(self, &emptyDataViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &emptyDataViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 加载失败占位视图
    fileprivate var loadFailedView: UIView? {
        get {
            return objc_getAssociatedObject(self, &loadFailedViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &loadFailedViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public class EmptyDataSet {
    
    /// 添加空数据占位视图，UITableView  UICollectionView不需要手动隐藏，在reload时自动控制显示还是隐藏，如果是普通view，必须手动隐藏
    /// - Parameters:
    ///   - emptyView: 空数据占位视图
    ///   - edgeInsets: 占位视图边距， 默认充满父视图
    @discardableResult
    public static func showEmptyDataView<T: UIView>(for view: UIView,
                                                    emptyView: T,
                                                    edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> T {
        
        // 移除旧的占位视图
        view.emptyDataView?.removeFromSuperview()
        view.emptyDataView = nil
        
        self.hiddenLoadFailedView(for: view)
        
        // 添加新的
        view.emptyDataView = emptyView
        emptyView.backgroundColor = view.backgroundColor
        view.addSubview(emptyView)
        emptyView.snp.remakeConstraints { (make) in
            make.edges.equalTo(edgeInsets)
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-edgeInsets.top)
        }
                
        // 如果是UITableView UICollectionView，替换reloadData方法，在reloadData时判断显示还是隐藏 如果是普通view，必须手动隐藏
        if let _ = view as? UITableView {
            emptyView.isHidden = true
            
            if !hasSwizzledUITableViewReloadData {
                hasSwizzledUITableViewReloadData = true
                let reloadOriginalSelector = #selector(UITableView.reloadData)
                let reloadSwizzledSelector = #selector(UITableView.emptyDataSetSwizzledReloadData)
                view.swizzlingMethod(UITableView.self,
                                     originalSelector: reloadOriginalSelector,
                                     swizzledSelector: reloadSwizzledSelector)
                
                let updatesOriginalSelector = #selector(UITableView.endUpdates)
                let updatesSwizzledSelector = #selector(UITableView.emptyDataSetSwizzledEndUpdates)
                view.swizzlingMethod(UITableView.self,
                                     originalSelector: updatesOriginalSelector,
                                     swizzledSelector: updatesSwizzledSelector)
            }
            
        } else if let _ = view as? UICollectionView {
            emptyView.isHidden = true
            
            if !hasSwizzledUICollectionViewReloadData {
                hasSwizzledUICollectionViewReloadData = true
                let reloadOriginalSelector = #selector(UICollectionView.reloadData)
                let reloadSwizzledSelector = #selector(UICollectionView.emptyDataSetSwizzledReloadData)
                view.swizzlingMethod(UICollectionView.self,
                                     originalSelector: reloadOriginalSelector,
                                     swizzledSelector: reloadSwizzledSelector)
            }
        }
        return emptyView
    }
    
    /// 加载失败占位视图, 必须手动隐藏
    /// - Parameters:
    ///   - view: 添加占位视图的父视图
    ///   - emptyFailedView: 加载失败占位视图
    ///   - edgeInsets: 占位视图边距， 默认充满父视图
    @discardableResult
    public static func showLoadFailedView<T: UIView>(for view: UIView,
                                                     failedView: T,
                                                     edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> T {
        
        // 移除旧的占位视图
        view.loadFailedView?.removeFromSuperview()
        view.loadFailedView = nil
        
        self.hiddenEmptyDataView(for: view)
        
        // 添加新的
        view.loadFailedView = failedView
        failedView.backgroundColor = view.backgroundColor
        view.addSubview(failedView)
        failedView.snp.remakeConstraints { (make) in
            make.edges.equalTo(edgeInsets)
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-edgeInsets.top)
        }
        return failedView
    }
    
    /// 隐藏空数据占位视图
    public static func hiddenEmptyDataView(for view: UIView) {
        view.emptyDataView?.isHidden = true
    }
    
    /// 隐藏加载失败占位视图
    public static func hiddenLoadFailedView(for view: UIView) {
        view.loadFailedView?.isHidden = true
    }
}

extension EmptyDataSet {
    
    /// UITableView UICollectionView调用reloadData时刷新
    fileprivate static func reloadEmptyDataSet(for view: UIView) {
        self.hiddenLoadFailedView(for: view)
        view.emptyDataView?.isHidden = self.getItemsCount(for: view) != 0
    }
    
    /// TableView或CollectionView的数据条数
    fileprivate static func getItemsCount(for view: UIView) -> Int? {
        var items : Int?
        if let tableView = view as? UITableView {
            var sections = 1
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: tableView)
                    if sections == 0 {
                        return 0
                    }
                }
                if dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))) {
                    for i in 0 ..< sections {
                        items = (items ?? 0) + dataSource.tableView(tableView, numberOfRowsInSection: i)
                    }
                }
            }
        } else if let collectionView = view as? UICollectionView {
            
            var sections = 1
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: collectionView)
                    if sections == 0 {
                        return 0
                    }
                }
                if dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) {
                    for i in 0 ..< sections {
                        items = (items ?? 0) + dataSource.collectionView(collectionView, numberOfItemsInSection: i)
                    }
                }
            }
        }
        return items
    }
}

// MARK: - Method Swizzling

extension UITableView {
    
    /// 第一次reloadData时隐藏EmptyDataView 默认true
    public var hiddenEmptyDataSetWhenFirstReload: Bool {
        get {
            return (objc_getAssociatedObject(self, &hiddenEmptyDataSetWhenFirstReloadKey) as? Bool ?? true)
        }
        set {
            objc_setAssociatedObject(self, &hiddenEmptyDataSetWhenFirstReloadKey, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc fileprivate func emptyDataSetSwizzledReloadData() {
        self.emptyDataSetSwizzledReloadData()
        if !self.hiddenEmptyDataSetWhenFirstReload {
            EmptyDataSet.reloadEmptyDataSet(for: self)
        }
        self.hiddenEmptyDataSetWhenFirstReload = false
    }
    
    @objc fileprivate func emptyDataSetSwizzledEndUpdates() {
        self.emptyDataSetSwizzledEndUpdates()
        if !self.hiddenEmptyDataSetWhenFirstReload  {
            EmptyDataSet.reloadEmptyDataSet(for: self)
        }
        self.hiddenEmptyDataSetWhenFirstReload = false
    }
}

extension UICollectionView {
    
    /// 第一次reloadData时隐藏EmptyDataView 默认true
    public var hiddenEmptyDataSetWhenFirstReload: Bool {
        get {
            return (objc_getAssociatedObject(self, &hiddenEmptyDataSetWhenFirstReloadKey) as? Bool ?? true)
        }
        set {
            objc_setAssociatedObject(self, &hiddenEmptyDataSetWhenFirstReloadKey, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc fileprivate func emptyDataSetSwizzledReloadData() {
        self.emptyDataSetSwizzledReloadData()
        if !self.hiddenEmptyDataSetWhenFirstReload {
            EmptyDataSet.reloadEmptyDataSet(for: self)
        }
        self.hiddenEmptyDataSetWhenFirstReload = false
    }
}
