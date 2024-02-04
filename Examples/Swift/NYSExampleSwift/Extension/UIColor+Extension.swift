//
//  UIColor+Extension.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit

enum GradientDirection {
    case horizontal
    case vertical
}

extension UIColor {
    
    /// 十六进制颜色创建UIColor
    /// - Parameters:
    ///   - hexString: 色值
    ///   - alpha: 透明度
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var formattedHex = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 随机色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 转换为其十六进制表示
    func toHexString() -> String {
        guard let components = self.cgColor.components, components.count >= 3 else {
            // 如果颜色没有RGBA组件或者长度小于3，返回默认黑色
            return "#000000"
        }
        
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    /// 渐变色
    /// - Parameters:
    ///   - startColor: 开始色
    ///   - endColor: 结束色
    ///   - direction: 方向
    /// - Returns: 渐变色
    static func gradient(from startColor: UIColor, to endColor: UIColor, direction: GradientDirection) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        
        return gradientLayer
    }
    
}
