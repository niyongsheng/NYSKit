
![(logo)](https://github.com/niyongsheng/NYSKit/blob/master/logo.png?raw=true)
NYSKit
===
[![](https://img.shields.io/badge/platform-iOS-orange.svg)](https://developer.apple.com/ios/)
[![](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/niyongsheng/BaseClass_MVP_IOS/blob/master/LICENSE)
===

## Introduction:
> 宏+基类+工具+组件 ios应用构建框架<br>
> Macros+BaseClass+Tool+Component IOS App Build Framework

## Features:
- [x] MVC
- [x] MVP
- [x] XIB
- [x] AD
- [x] IM
- [x] UM
- [x] DB
- [x] Rich Text Push
- [x] Sign With Apple
- [x] Dark Mode (support < ios 13)

## Screenshot：
![image](https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/base_ios_demo.gif)

## Usage：
```ruby
cd ../NYSKit/BaseIOS

pod install
```
- *直接[改名](http://note.youdao.com/s/2P6PiTG)，或者将[NYSKit](https://github.com/niyongsheng/NYSKit/tree/master/BaseIOS/BaseIOS/NYSKit)迁移至你的项目中使用。*
- *Simply [rename](http://note.youdao.com/s/2P6PiTG), or migrate [NYSKit](https://github.com/niyongsheng/NYSKit/tree/master/BaseIOS/BaseIOS/NYSKit) to your project for use.*

<p align="right">———— Example Project:
       <a  href="https://github.com/niyongsheng/AppDemo">AppDemo </a>
</p>

## Architecture:
<img src="https://github.com/niyongsheng/NYSKit/blob/master/class_relation.png" onerror="https://s1.ax1x.com/2020/07/20/Ufghmn.jpg" onclick="http://note.youdao.com/s/QfERZJrs" alt="Github图片无法加载，请自行修改hosts文件。">

```text
NYSKit
├─ AppDelegate
│    ├─ AppDelegate+AppService.h
│    ├─ AppDelegate+AppService.m
│    ├─ AppDelegate+PushService.h
│    ├─ AppDelegate+PushService.m
│    ├─ AppDelegate.h
│    └─ AppDelegate.m
├─ AppManager
│    ├─ AppManager.h
│    ├─ AppManager.m
│    ├─ DBManager.h
│    ├─ DBManager.m
│    ├─ ADManager.h
│    ├─ ADManager.m
│    ├─ ThemeManager
│    │    ├─ ThemeManager.h
│    │    ├─ ThemeManager.m
│    │    ├─ themejson_day.json
│    │    └─ themejson_night.json
│    ├─ IMManager
│    │    ├─ DataSource
│    │    ├─ IMManager.h
│    │    └─ IMManager.m
│    ├─ UMManager.h
│    ├─ UMManager.m
│    └─ UserManager
│           ├─ UserManager.h
│           ├─ UserManager.m
│           └─ UserModel
├─ BaseClass
│    ├─ NYSBaseNavigationController.h
│    ├─ NYSBaseNavigationController.m
│    ├─ NYSBaseTabBarController.h
│    ├─ NYSBaseTabBarController.m
│    ├─ NYSBaseViewController.h
│    ├─ NYSBaseViewController.m
│    ├─ NYSBaseProtocol.h
│    ├─ NYSBaseProtocol.m
│    ├─ NYSBaseWindow.h
│    ├─ NYSBaseWindow.m
│    └─ WebViewController
├─ Category
├─ Headers
│    ├─ Bridging-Header.h
│    ├─ CommonMacros.h
│    ├─ PrefixHeader.pch
│    ├─ ThemeMacros.h
│    └─ UtilsMacros.h
├─ Network
│    ├─ NYSRequest.h
│    └─ NYSRequest.m
├─ NewFeature
│    ├─ NYSNewfeatureViewController.h
│    └─ NYSNewfeatureViewController.m
├─ Resource
│    ├─ Fonts
│    │    └─ 04b_03b.TTF
│    └─ Images
└─ Utils
       ├─ FPS
       ├─ LEEBubble
       ├─ LEETheme
       ├─ Memory
       ├─ CMPopTipView
       ├─ TableViewAnimationKit
       ├─ FDFullscreenPopGesture
       └─ Tools

```

## Remind
① `ARC`<br>
② `Cocoapods`<br>
② `iPhone\iPad`<br>
④ `iOS >= 10.0`<br>
⑤ `Xcode >= 9.3`<br>

## Contribution
Reward[:lollipop:](https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Beg/README.md)  Encourage[:heart:](https://github.com/niyongsheng/NYSKit/stargazers)

## Contact Me [:octocat:](https://niyongsheng.github.io)
* E-mail: niyongsheng@Outlook.com
* Weibo: [@Ni永胜](https://weibo.com/u/7317805089)
