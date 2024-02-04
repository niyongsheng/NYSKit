//
//  String+Extension.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit
import RegexBuilder

extension String {
    
    static func isBlank(string: String?) -> Bool {
        guard let value = string else { return true }
        return value.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    /// 计算字符串高度
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return boundingBox.height
    }
    
    /// 随机字符串
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return randomString(letters: letters, length: length)
    }
    
    static func randomString(letters: String?, length: Int) -> String {
        guard let validLetters = letters, !validLetters.isEmpty else {
            return ""
        }
        return String((0..<length).map { _ in validLetters.randomElement()! })
    }
    
}
