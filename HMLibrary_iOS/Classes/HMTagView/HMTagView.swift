//
//  HMTagView.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2024/1/9.
//

import UIKit

@IBDesignable

/// 标签Tag View
public class HMTagView: UIView {
        
    public weak var delegate: HMTagViewDelegate? {
        didSet {
            self.registerTagCell()
            self.reloadFlowLayout(animated: false)
        }
    }
    
    /// 最大高度 默认nil 表示跟随内容变高
    public var maxHeight: CGFloat?
    
    /// 内边距
    public var padding: UIEdgeInsets = .zero {
        didSet {
            self.collectionTopCons.constant = padding.top
            self.collectionBottomCons.constant = -padding.bottom
            self.collectionLeftCons.constant = padding.left
            self.collectionRightCons.constant = -padding.right
        }
    }
    
    public lazy var collectionView: UICollectionView = {
        // 默认布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 54, height: 32)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
        // 监听collectionView 的contentSize
        collectionView.addObserver(self, forKeyPath: contentSizeKeyPath,  options: [.old,.new], context: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
        
    private var collectionHeightCons: NSLayoutConstraint!
    private var collectionTopCons: NSLayoutConstraint!
    private var collectionBottomCons: NSLayoutConstraint!
    private var collectionLeftCons: NSLayoutConstraint!
    private var collectionRightCons: NSLayoutConstraint!
    
    private let contentSizeKeyPath = "contentSize"
    
    public init() {
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupUI()
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: contentSizeKeyPath, context: nil)
    }
    
    private func setupUI() {
        
        self.backgroundColor = .clear
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionHeightCons = collectionView.heightAnchor.constraint(equalToConstant: 32)
        self.collectionTopCons = collectionView.topAnchor.constraint(equalTo: topAnchor)
        self.collectionLeftCons = collectionView.leftAnchor.constraint(equalTo: leftAnchor)
        self.collectionRightCons = collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        self.collectionBottomCons = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            self.collectionTopCons,
            self.collectionLeftCons,
            self.collectionRightCons,
            self.collectionBottomCons,
            self.collectionHeightCons
        ])
    }
    
    public func updateTagViewHeight(_ contentHeight: CGFloat? = nil) {
        var height = collectionView.collectionViewLayout.collectionViewContentSize.height
        if let maxHeight = self.maxHeight {
            height = maxHeight
        } else if let contentHeight = contentHeight {
            height = contentHeight
        }
        self.collectionHeightCons.constant = height
    }
    
    /// 注册cell
    public func registerTagCell() {
        delegate?.tagView(self, registerTagCellFor: self.collectionView)
    }
    
    /// 刷新布局FlowLayout
    /// - Parameter animated: animated
    public func reloadFlowLayout(animated: Bool = true) {
        if let layout = delegate?.tagViewFlowLayout(self) {
            self.collectionView.setCollectionViewLayout(layout, animated: animated)
        }
    }
    
    /// reloadData
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    /// 监听contentSize高度变化
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, keyPath == contentSizeKeyPath,
              let object = object as? UICollectionView, object == self.collectionView,
              let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        self.updateTagViewHeight(contentSize.height)
        delegate?.tagView(self, contentSizeChanged: contentSize)
    }
}

// MARK: - UICollectionViewDelegate

extension HMTagView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.tagViewNumberOfSections(self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.tagView(self, numberOfItemsInSection: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = delegate?.tagView(self, collectionView: collectionView, cellForItemAt: indexPath)
        return cell ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tagView(self, didSelectItemAt: indexPath)
    }
}
