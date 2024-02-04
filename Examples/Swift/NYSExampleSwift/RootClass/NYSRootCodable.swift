//
//  NYSRootCodable.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import ExCodable

protocol AutoKeyMapping {
    static var keyMapping: [AnyKeyMap<Self>] { get }
}

struct AnyKeyMap<T> {
    let key: String
}

//extension AutoKeyMapping {
//    static var keyMapping: [AnyKeyMap<Self>] {
//        let mirror = Mirror(reflecting: Self.self)
//        return mirror.children.compactMap { (label, value) in
//            guard let label = label else { return nil }
//            
//            if let subMapping = value as? AutoKeyMapping {
//                // 递归展开子映射
//                return subMapping.keyMapping.map { AnyKeyMap(key: "\(label).\($0.key)") }
//            } else {
//                return AnyKeyMap(key: label)
//            }
//        }
//        .flatMap { $0 }
//    }
//}


struct NYSRootCodable: Equatable {
    static func == (lhs: NYSRootCodable, rhs: NYSRootCodable) -> Bool {
        return lhs.ID == rhs.ID && lhs.xid == rhs.xid
    }
    
    var ID: Int = 0
    var xid: String!
}

extension NYSRootCodable: ExCodable {
    
    static let keyMapping: [KeyMap<Self>] = [
        KeyMap(\.ID, to: "id"),
        KeyMap(\.xid, to: "nested.id")
    ]
    
    init(from decoder: Decoder) throws {
        try decode(from: decoder, with: Self.keyMapping)
    }
    
    func encode(to encoder: Encoder) throws {
        try encode(to: encoder, with: Self.keyMapping)
    }
    
}
