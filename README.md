
![(logo)](https://github.com/niyongsheng/NYSKit/blob/master/logo.png?raw=true)
NYSKit
===
[![](https://img.shields.io/badge/platform-iOS-orange.svg)](https://developer.apple.com/ios/)
[![](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/niyongsheng/BaseClass_MVP_IOS/blob/master/LICENSE)
===

## Introduction:
> IOS应用快速构建框架。<br>
> Quick build [framework](#architecture) for IOS apps.
<img src="./Images/nysws.drawio.png">

## Screenshot
![image](https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/base_ios_demo.gif)

## Features
- [x] [mvvm](https://en.wikipedia.org/wiki/Model–view–viewmodel)
- [x] [swiftUI](https://developer.apple.com/tutorials/sample-apps/)
- [x] [dark-mode](https://developer.apple.com/design/human-interface-guidelines/dark-mode/)
- [x] [localization](https://developer.apple.com/localization/)
- [x] [ad/qr/nav/net/map/mock/codable/cache/theme manager](https://github.com/niyongsheng/NYSWS/blob/main/NYSWS/NYSAppSwift/NYSAppSwift/README.md)

## Usage
```ruby
  pod 'NYSKit', :git => 'https://github.com/niyongsheng/NYSKit.git', :tag => '0.0.4'
  pod 'NYSUIKit', :git => 'https://github.com/niyongsheng/NYSKit.git', :tag => '0.0.4'

  pod install
```
```objectivec
  #import <NYSKit/NYSKit.h>
  #import <NYSUIKit/NYSUIKit.h>
```
```swift
  import NYSKit
  import NYSUIKit
```
`NYSKit Document:` https://niyongsheng.github.io/Document/NYSWS/NYSKit/index.html

`NYSUIKit Document:` https://niyongsheng.github.io/Document/NYSWS/NYSUIKit/index.html

`Example Project:`[NYSWS](https://github.com/niyongsheng/NYSWS)

## Architecture
```text
NYSKit
├─ NYSError.h
├─ NYSError.m
├─ NYSKeyChain.h
├─ NYSKeyChain.m
├─ NYSKit.h
├─ NYSKitManager.h
├─ NYSKitManager.m
├─ NYSKitPublicHeader.h
├─ NYSNetRequest.h
├─ NYSNetRequest.m
├─ NYSRegularCheck.h
├─ NYSRegularCheck.m
├─ NYSTools.h
└─ NYSTools.m
```
```text
NYSUIKit
├─ BaseClass
│    ├─ NYSBaseNavigationController.h
│    ├─ NYSBaseNavigationController.m
│    ├─ NYSBaseObject.h
│    ├─ NYSBaseObject.m
│    ├─ NYSBasePresenter.h
│    ├─ NYSBasePresenter.m
│    ├─ NYSBaseTabBarController.h
│    ├─ NYSBaseTabBarController.m
│    ├─ NYSBaseView.h
│    ├─ NYSBaseView.m
│    ├─ NYSBaseViewController.h
│    ├─ NYSBaseViewController.m
│    ├─ NYSBaseWindow.h
│    ├─ NYSBaseWindow.m
│    └─ WebViewController
│           ├─ ErrorHtml
│           ├─ NYSJSHandler.h
│           ├─ NYSJSHandler.m
│           ├─ NYSWebViewController.h
│           └─ NYSWebViewController.m
├─ Category
│    ├─ NSBundle+NYSFramework.h
│    ├─ NSBundle+NYSFramework.m
│    ├─ NSBundle+NYSLanguageSwitch.h
│    ├─ NSBundle+NYSLanguageSwitch.m
│    ├─ NSDictionary+NilSafe.h
│    ├─ NSDictionary+NilSafe.m
│    ├─ NSError+NYS.h
│    ├─ NSError+NYS.m
│    ├─ UIButton+NYS.h
│    ├─ UIButton+NYS.m
│    ├─ UIImage+NYS.h
│    ├─ UIImage+NYS.m
│    ├─ UINavigationController+FDFullscreenPopGesture.h
│    ├─ UINavigationController+FDFullscreenPopGesture.m
│    ├─ UINavigationController+NYSUIKit.h
│    ├─ UINavigationController+NYSUIKit.m
│    ├─ UITextField+NYS.h
│    ├─ UITextField+NYS.m
│    ├─ UIView+NYS.h
│    └─ UIView+NYS.m
├─ Manager
│    └─ ThemeManager
│           ├─ README.md
│           ├─ ThemeManager.h
│           └─ ThemeManager.m
├─ NYSUIKit
├─ NYSUIKit.h
├─ NYSUIKitPublicHeader.h
├─ Resources(资源文件:字体、图片、国际化)
├─ UI(UI组件库)
└─ Utilities
       ├─ NYSUIKitUtilities.h
       └─ NYSUIKitUtilities.m
```

## Remind
① `ARC`<br>
② `Cocoapods`<br>
③ `iPhone\iPad`<br>
④ `iOS >= 13.0`<br>
⑤ `Xcode >= 14.0`<br>

## Contribution
Reward[:lollipop:](https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Beg/README.md)  Encourage[:heart:](https://github.com/niyongsheng/NYSKit/stargazers)

## Contact Me
* E-mail: niyongsheng@Outlook.com
* Weibo: [@Ni永胜](https://weibo.com/u/7317805089)
