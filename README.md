# HMLibrary_iOS

[![CI Status](https://img.shields.io/travis/galenu/HMLibrary_iOS.svg?style=flat)](https://travis-ci.org/galenu/HMLibrary_iOS)
[![Version](https://img.shields.io/cocoapods/v/HMLibrary_iOS.svg?style=flat)](https://cocoapods.org/pods/HMLibrary_iOS)
[![License](https://img.shields.io/cocoapods/l/HMLibrary_iOS.svg?style=flat)](https://cocoapods.org/pods/HMLibrary_iOS)
[![Platform](https://img.shields.io/cocoapods/p/HMLibrary_iOS.svg?style=flat)](https://cocoapods.org/pods/HMLibrary_iOS)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
#### iOS开发基础组件库HMLibrary_iOS.
- 通用组件
- 通用协议，扩展，工具类
- 空页面占位视图：EmptyDataSet
```
import HMLibrary_iOS

extension UIView {
    
    /// 添加空数据占位视图，UITableView  UICollectionView不需要手动隐藏，在reload时自动控制显示还是隐藏，如果是普通view，必须手动隐藏
    /// - Parameters:
    ///   - view: 空数据占位视图, 默认YLEmptyDataView
    ///   - edgeInsets: 占位视图边距， 默认充满父视图
    @discardableResult
    func showEmptyDataView<T: UIView>(_ view: T = DefaultEmptyDataView(), edgeInsets: UIEdgeInsets) -> T {
        return EmptyDataSet.showEmptyDataView(for: self, emptyView: view, edgeInsets: edgeInsets)
    }
    
    /// 添加空数据占位视图，UITableView  UICollectionView不需要手动隐藏，在reload时自动控制显示还是隐藏，如果是普通view，必须手动隐藏
    /// - Parameters:
    ///   - view: 空数据占位视图, 默认DefaultEmptyDataView
    ///   - marginTop: 占位顶部边距， 默认导航栏+状态栏
    @discardableResult
    func showEmptyDataView<T: UIView>(_ view: T = DefaultEmptyDataView(), marginTop: CGFloat = 0) -> T {
        return self.showEmptyDataView(view, edgeInsets: UIEdgeInsets(top: marginTop, left: 0, bottom: 0, right: 0))
    }

    
    /// 加载失败占位视图
    /// - Parameters:
    ///   - view: 加载失败占位视图， 默认DefaultLoadFailedView
    ///   - edgeInsets: 占位视图边距， 默认充满父视图
    @discardableResult
    func showLoadFailedView<T: UIView>(_ view: T = DefaultLoadFailedView(), edgeInsets: UIEdgeInsets) -> T {
        return EmptyDataSet.showLoadFailedView(for: self, failedView: view, edgeInsets: edgeInsets)
    }
    
    /// 加载失败占位视图
    /// - Parameters:
    ///   - view: 加载失败占位视图
    ///   - marginTop: 占位顶部边距， 默认导航栏+状态栏
    @discardableResult
    func showLoadFailedView<T: UIView>(_ view: T = DefaultLoadFailedView(), marginTop: CGFloat = HMAPP.naviStatusBarHeight) -> T {
        return EmptyDataSet.showLoadFailedView(for: self, failedView: view, edgeInsets: UIEdgeInsets(top: marginTop, left: 0, bottom: 0, right: 0))
    }
    
    /// 隐藏空页面占位视图 tableView collectionView在reload时自动隐藏
    func hiddenEmptyDataView() {
        EmptyDataSet.hiddenEmptyDataView(for: self)
    }
    
    ///  隐藏加载失败占位视图
    func hiddenLoadFailedView() {
        EmptyDataSet.hiddenLoadFailedView(for: self)
    }
}


```
- 蓝牙：HMBluetooth
```
/// Dashboard 蓝牙api
enum PTLDashboardBleApi {
    
    /// 请求设备信息
    case deviceInfo
    
    /// 请求Light信息
    case lightInfo
    
    /// 设置Auracast mode
    case setAuracastMode(isOn: Bool)
}
```
```
        let api = PTLDashboardBleApi.setAuracastMode(isOn: isOn)
        peripheral?.request(api, isReply: { resp in
            let subcmd = resp.payload.hm.readUInt8(index: 0)
            return resp.commandId == 0x00 && subcmd == 0x13
        }, object: HMBleDevACKModel()).subscribe(onNext: { devACK in
            if devACK.isSuccess {
                debugPrint("setAuracastMode success")
            } else {
                debugPrint("setAuracastMode failure")
            }
        }, onError: { error in
            debugPrint("setAuracastMode error")
        }).disposed(by: disposeBag)
```
- 缓存：HMCache
```
/// 从缓存中获取Data
    func object(forKey: HMCacheKeyProtocol) -> Data?
    
    /// 缓存Data
    func setObject(_ data: Data, forKey: HMCacheKeyProtocol)
    
    /// 缓存Codable对象
    /// - Parameters:
    ///   - forKey: 缓存key
    ///   - type: 缓存Codable对象类型
    /// - Returns: 从缓存中获取的Codable对象
    func object<T: Codable>(forKey: HMCacheKeyProtocol, type: T.Type) -> T?
    
    /// 缓存Codable对象
    /// - Parameters:
    ///   - object: 缓存Codable对象
    ///   - forKey: 缓存key
    func setObject(_ object: Codable, forKey: HMCacheKeyProtocol)
    
    /// 移除缓存对象
    func removeObject<T: HMCacheKeyProtocol>(forKey: T)
    
    func removeAll()
    
    func existsObject<T: HMCacheKeyProtocol>(forKey: T) -> Bool
    
    func asyncObject(forKey: HMCacheKeyProtocol, completion: @escaping ((Data) -> Void), failure: ((Error) -> Void)?)
    
    func asyncSetObject(_ data: Data, forKey: HMCacheKeyProtocol, completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncObject<T: Codable>(forKey: HMCacheKeyProtocol, type: T.Type, completion: @escaping ((T) -> Void), failure: ((Error) -> Void)?)
    
    func asyncSetObject(_ object: Codable, forKey: HMCacheKeyProtocol, completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncRemoveObject(forKey: HMCacheKeyProtocol, completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncRemoveAll(completion: (() -> Void)?, failure: ((Error) -> Void)?)
    
    func asyncExistsObject(forKey: HMCacheKeyProtocol, completion: ((Bool) -> Void)?)
```
- 自定义ttf字体：HMFont
```
extension UIFont {
    
    /// 创建OpenSans字体
    /// - Parameters:
    ///   - name: OpenSans字体名字
    ///   - size: 字体大小
    /// - Returns: UIFont
    public static func font(_ name: TTFFontName, size: CGFloat) -> UIFont {
        return TTFFont.font(name, size: size)
    }
}

```
- 日志：HMLog
```
HMLog.debug("lprojBundlePath: \(type.rawValue) not found!")
```
- 导航：HMNavigation
```
/// UINavigationController跳转协议
public protocol HMNavigationable {
    
    /// push或pop到controller
    func push(to controller: UIViewController, mode: HMNavigationPushMode, cycleStep: Int, animated: Bool) -> UIViewController?
    
    /// 返回到指定类型中的页面。返回时会匹配到一个即执行。主要用于解决不同场景下，多入口返回到指定页面的问题
    func pop(to controllerTypes: [AnyClass]?, mode: HMNavigationPopMode, animated: Bool) -> UIViewController?
    
    /// 从navigationController的栈中查找第一个某个类型的控制器
    /// - Parameter controllerType: 控制器类型
    /// - Returns: UIViewController
    func firstViewController(for controllerType: AnyClass) -> UIViewController?
    
    /// 从导航栏移除控制器
    func removeNavigationViewControllers(_ controllerTypes: [AnyClass])
}
```
- 路由：HMRoute
```
import URLNavigator

/// partybox灯模块路由
public enum HMLightModuleRoute: HMRouteable {
    
    /// light 控制dashboard页面
    /// pid: 设备pid
    /// groupDeviceIds: 设备group, 第一个为当前连接的设备
    case dashboard(pid: Int, groupDeviceIds: [String])
   
}

extension HMLightModuleRoute {
    
    public var baseUrl: String {
        return "app://lightModule/"
    }
    
    public var path: String {
        switch self {
        case .dashboard:
            return "dashboard"

        }
    }
    
    public var queryParameters: [String: String] {
        var params = [String: String]()
        switch self {
            
        case let .dashboard(pid, groupDeviceIds):
            params["pid"] = "\(pid)"
            params["groupDeviceIds"] = groupDeviceIds.joined(separator: ",")
        }
        return params
    }
    
    public static func register(navigator: URLNavigator.Navigator) {
        navigator.register(routeable: HMLightModuleRoute.dashboard(pid: 0, groupDeviceIds: [])) { url, _, context in
            let params = url.queryParameters
            guard let pidStr = params["pid"], let pid = Int(pidStr) else { return nil }
            guard let groupDeviceIdStr = params["groupDeviceIds"] else { return nil }
            let groupDeviceIds = groupDeviceIdStr.components(separatedBy: ",")
            let vc = HMLightDashboardVC(pid: pid, groupDeviceIds: groupDeviceIds)
            return vc
        }

    }
}

```
- 弹框：HMPopup
```
import HMLibrary_iOS

extension UIViewController {
    
    /// 给vc弹框  默认nil表示获取最顶层的PresentedController
    /// - Parameters:
    ///   - attribute: 弹出框配置
    ///   - vc: 容器vc
    ///   - completion: 弹出完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    func showPupup(attribute: HMPopupAttribute, 
                   for vc: UIViewController? = nil,
                   completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        return HMPopup.show(attribute: attribute, for: vc, completion: completion)
    }
    
    /// 消失弹框
    /// - Parameters:
    ///   - name: 根据显示的name筛选消失的弹框 默认nil表示消失所有显示的弹框
    ///   - vc: 容器vc
    ///   - completion: 消失完成回调
    func hiddenPopup(name: String? = nil,
                     for vc: UIViewController? = nil,
                     completion: (() -> Void)? = nil) {
        HMPopup.dismiss(name: name, for: vc, completion: completion)
    }
    
    /// 弹出Alert
    /// - Parameters:
    ///   - name: 弹出层的name 消失时需一致  默认nil表示消失正在显示的
    ///   - alert: 自定义alert
    ///   - vc: 从某个VC弹出
    ///   - size: 弹框内容布局尺寸
    ///   - offsetX: 距离x轴的偏移量
    ///   - offsetY: 距离y轴的偏移量
    ///   - dismissWhenTapMask: 点击背景是否消失
    ///   - completion: 完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    func showAlert(name: String? = nil,
                   _ alert: UIView,
                   for vc: UIViewController? = nil,
                   size: HMPopupSize = .layoutFit(width: UIScreen.main.bounds.width - 60),
                   offsetX: CGFloat = 30,
                   offsetY: CGFloat = 0,
                   dismissWhenTapMask: Bool = true,
                   completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        let mask = HMPopup.showAlert(name: name, alert, for: vc, size: size, offsetX: offsetX, offsetY: offsetY, dismissWhenTapMask: dismissWhenTapMask, completion: completion)
        mask.attribute.maskColor = UIColor(white: 0, alpha: 0.3)
        return mask
    }
    
    /// 从底部弹出actionSheet
    /// - Parameters:
    ///   - name: 弹出层的name 消失时需一致  默认nil表示消失正在显示的
    ///   - actionSheet: 自定义actionSheet 
    ///   - vc: 从某个VC弹出
    ///   - size: 弹框内容布局尺寸
    ///   - offsetX: 距离x轴的偏移量
    ///   - offsetY: 距离y轴的偏移量
    ///   - dismissWhenTapMask: 点击背景是否消失
    ///   - completion: 完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    func showActionSheet(name: String? = nil,
                         _ actionSheet: UIView,
                         for vc: UIViewController? = nil,
                         size: HMPopupSize = .layoutFit(width: UIScreen.main.bounds.width),
                         offsetX: CGFloat = 0,
                         offsetY: CGFloat = 0,
                         dismissWhenTapMask: Bool = true,
                         completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        let mask = HMPopup.showActionSheet(name: name, actionSheet, for: vc, size: size, offsetX: offsetX, offsetY: offsetY, dismissWhenTapMask: dismissWhenTapMask, completion: completion)
        mask.attribute.maskColor = UIColor(white: 0, alpha: 0.3)
        return mask
    }
    
    /// 从右向左push弹出popupView
    /// - Parameters:
    ///   - name: 弹出层的name 消失时需一致  默认nil表示消失正在显示的
    ///   - popupView: 弹出的popupView
    ///   - vc: 从某个VC弹出
    ///   - size: 弹框内容布局尺寸
    ///   - offsetX: 距离x轴的偏移量
    ///   - offsetY: 距离y轴的偏移量
    ///   - dismissWhenTapMask: 点击背景是否消失
    ///   - completion: 完成回调
    /// - Returns: HMPopupMask
    @discardableResult
    func pushPopover(name: String? = nil,
                     _ popupView: UIView,
                     for vc: UIViewController? = nil,
                     size: HMPopupSize = .layoutFit(width: UIScreen.main.bounds.width),
                     offsetX: CGFloat = 0,
                     offsetY: CGFloat = 0,
                     dismissWhenTapMask: Bool = true,
                     completion: (() -> Void)? = nil) -> HMPopupMaskVC {
        let mask = HMPopup.pushPopover(name: name, popupView, for: vc, size: size, offsetX: offsetX, offsetY: offsetY, dismissWhenTapMask: dismissWhenTapMask, completion: completion)
        mask.attribute.maskColor = UIColor(white: 0, alpha: 0.3)
        return mask
    }
}
```
- 标签Tag：HMTagView
```
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
```
- loading/toast：HUD
```
import HMLibrary_iOS

extension UIView {
    
    /// 显示自定义loading
    /// - Parameters:
    ///   - loadingView: 自定义Loading
    ///   - edge: edge
    func showLoading(_ loadingView: UIView = HUDLoadingView(),
                     edgeInsets: UIEdgeInsets = .zero) {
        HUD.showLoadingHUD(loadingView, for: self, edgeInsets: edgeInsets)
    }
    
    /// 隐藏loading
    func hiddenLoading() {
        HUD.hiddenLoadingHUD(for: self)
    }
    
    /// 显示骨架屏
    /// - Parameters:
    ///   - image: 骨架屏图片
    ///   - padding: 图片距离骨架屏的内边距
    ///   - backgroundColor: hud背景
    ///   - edgeInsets: hud内边距
    /// - Returns: HUDSkeletonLoadingView
    @discardableResult
    func showSkeletonLoading(image: UIImage?,
                             padding: UIEdgeInsets = .zero,
                             backgroundColor: UIColor? = UIColor(white: 0, alpha: 0.3),
                             edgeInsets: UIEdgeInsets = .zero) -> HUDSkeletonLoadingView {
        let skeletonView = HUDSkeletonLoadingView()
        skeletonView.imageView.image = image
        skeletonView.padding = padding
        HUD.showSkeletonHUD(skeletonView, for: self, backgroundColor: backgroundColor, edgeInsets: edgeInsets)
        return skeletonView
    }
    
    /// 移除view上所有的骨架屏
    func hiddenSkeletonLoading() {
        HUD.hiddenSkeletonHUD(for: self)
    }
    
    /// 显示自定义toast
    /// - Parameters:
    ///   - text: 提示文本
    ///   - duration: 提示时间
    ///   - isUserInteractionEnabled: 是否响应事件
    ///   - edge: edge
    ///   - completion: toast完成回调
    func showToast(_ text: String,
                   duration: TimeInterval = 2.0,
                   isUserInteractionEnabled: Bool = false,
                   edgeInsets: UIEdgeInsets = .zero,
                   completion: (() -> Void)? = nil) {
        let toastView = HUDToastView(text: text, duration: duration, completion: completion)
        HUD.showToastHUD(toastView, for: self, isUserInteractionEnabled: isUserInteractionEnabled, edgeInsets: edgeInsets)
    }
    
    /// 隐藏自定义toast
    func hiddenToast() {
        HUD.hiddenToastHUD(for: self)
    }
    
    /// 隐藏所有的自定义loading和toast
    func hiddenAllHUD() {
        HUD.hiddenAllHUD(for: self)
    }
}
```
- 多语言国际化：I18n
```
import HMLibrary_iOS
//import RswiftResources

/// 国际化文本协议
protocol I18nLocalizedable {
    
    /// 国际化key
    var localizedKey: String{ get }
    
    /// 国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]?) -> String
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]?) -> I18nTextDynamicBlock
}

extension I18nLocalizedable {
    
    /// 国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> String {
        return I18n.localized(localizedKey, bundle: LanguageManager.shared.lprojBundle, args: args)
    }
    
    /// 实时刷新国际化文本
    /// - Parameters:
    ///   - args: 参数
    /// - Returns: 国际化后的String
    func localized(args: [CVarArg]? = nil) -> I18nTextDynamicBlock {
        return I18n.localized(localizedKey, bundle: { LanguageManager.shared.lprojBundle }, args: args)
    }
}

// MARK: - 默认给String添加国际化方法
extension String: I18nLocalizedable {
    
    var localizedKey: String {
        return self
    }
}

//extension StringResource: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
//
//extension StringResource1: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
//
//extension StringResource2: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
//
//extension StringResource3: I18nLocalizedable {
//    var localizedKey: String {
//        return self.key.description
//    }
//}
```
- 输入框校验：Validate
```
self.textField.validateRules = ValidateRuleFactoy.accountRules
self.textField.validateResult.subscribe { [weak self] valid in
    guard let `self` = self else { return }
    switch valid {
    case .failed:
        self.txtUserBackView.layer.borderColor = "#EE3B3B".cgColor
        self.lblUserRemind.textColor = "#EE3B3B".color
    default:
        self.txtUserBackView.layer.borderColor = self.txtUserBackView.isFocused ? "#41AE3C".cgColor : UIColor.clear.cgColor
        self.lblUserRemind.textColor = "FFFFFF".color
    }
}.disposed(by: disposeBag)
```

## Installation

HMLibrary_iOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HMLibrary_iOS'
```

## Author

galen, Qiang.Gui@harman.com

## License

HMLibrary_iOS is available under the MIT license. See the LICENSE file for more info.
