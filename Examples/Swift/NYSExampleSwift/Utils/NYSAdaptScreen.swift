//
//  NYSAdaptScreen.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import Foundation
import UIKit

let NScreenWidth = UIScreen.main.bounds.width
let NScreenHeight = UIScreen.main.bounds.height

/// 状态栏高度
let NStatusBarHeight = UIDevice.nys_statusBarHeight()
/// 导航栏高度
let NNavBarHight = UIDevice.nys_navigationBarHeight()
/// 状态栏+导航栏
let NTopHeight = UIDevice.nys_navigationFullHeight()
/// 底部标签栏高度
let NTabBarHeight = UIDevice.nys_tabBarHeight()
/// 底部安全高度
let NSafeBottomHeight = UIDevice.nys_safeDistanceBottom()
/// 底部标签栏+安全高度
let NBottomHeight = UIDevice.nys_tabBarFullHeight()

/// Iphone6
let NBaseWidth:CGFloat = 375.0
let NBaseHeight:CGFloat = 667.0

/// 水平缩放
/// - Returns: 比例
func HorizontalRatio() -> CGFloat {
    return NScreenWidth / NBaseWidth
}

/// 垂直缩放
/// - Returns: 比例
func VerticalRatio() -> CGFloat {
    return NScreenHeight / NBaseHeight
}

func RealValueX(x:CGFloat) ->CGFloat {
    return x * HorizontalRatio()
}

func RealValueY(y:CGFloat) ->CGFloat {
    return y * VerticalRatio()
}

/// 等比例缩放Rect
func AdaptionRectFromFrame(frame:CGRect) -> CGRect {
    let newX = frame.origin.x * HorizontalRatio()
    let newY = frame.origin.y * HorizontalRatio()
    let newW = frame.size.width * HorizontalRatio()
    let newH = frame.size.height * HorizontalRatio()
    return CGRect(x: newX, y: newY, width: newW, height: newH)
}

/// 当前版本Version
let GetAppCurrentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")

/// 虚线绘制
func DrawDashLine(lineView : UIView,lineLength : Int ,lineSpacing : Int,lineColor : UIColor) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = lineView.bounds
    // 只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
    shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
    // shapeLayer.fillColor = UIColor.blue.cgColor
    shapeLayer.strokeColor = lineColor.cgColor
    
    shapeLayer.lineWidth = lineView.frame.size.height
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    
    shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
    
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: lineView.frame.size.width, y: 0))
    
    shapeLayer.path = path
    lineView.layer.addSublayer(shapeLayer)
}
