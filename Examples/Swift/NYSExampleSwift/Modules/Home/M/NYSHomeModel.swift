//
//  NYSHomeCodable.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/8.
//

import Foundation
import NYSUIKit
import ExCodable
import YYModel

class NYSHomeModel: NYSBaseObject, Codable {
    
}

struct NYSHomeList: Codable {
    let name : String?
    let type : String?
    let date : String?
    let title : String?
    let content : String?
}

class NYSHomeListModel: NYSBaseObject {
    @objc var name: String?
    @objc var type: String?
    @objc var date: String?
    @objc var title: String?
    @objc var content: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
