//
//  TypeNameProtocol.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import Foundation

/// 命名空间
let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String

protocol TypeNameProtocol {
    
    var className: String { get }
    
    static var className: String { get }
    
}

extension TypeNameProtocol {
    
    var className: String { String(describing: self) }
    
    static var className: String { String(describing: self) }
    
    /// 用于非继承NSObject的class\enum\struct去掉命名空间的名称打印
    var classNameWithoutNamespace: String {
        
        if self is NSObject {
            return className
        } else {
            return className.replacingOccurrences(of: "\(nameSpace ?? "").", with: "")
        }
    }
    
    static var classNameWithoutNamespace: String {
        if self is NSObject.Type {
            return className
        } else {
            return className.replacingOccurrences(of: "\(nameSpace ?? "").", with: "")
        }
    }
    
}

extension TypeNameProtocol where Self: AnyObject {
    /// 获取对象的内存地址(class类才有)
    var memoryAddress: String {
        return "<\(classNameWithoutNamespace): \(Unmanaged.passUnretained(self).toOpaque())>"
    }
}
