//
//  NYSService.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/15.
//

import ExCodable

struct NYSService: Equatable {
    
    private(set) var ID: Int = 0
    private(set) var star: Int = 0
    private(set) var name: String!
    private(set) var desc: String!
    private(set) var url: String!
    private(set) var bgColor: String!
    private(set) var isRecommend: Bool = false
    
}

extension NYSService: ExCodable {
    
    static let keyMapping: [KeyMap<Self>] = [
        KeyMap(\.ID, to: "id"),
        KeyMap(\.star, to: "star"),
        KeyMap(\.name, to: "name"),
        KeyMap(\.desc, to: "desc"),
        KeyMap(\.url, to: "url"),
        KeyMap(\.bgColor, to: "bgColor"),
        KeyMap(\.isRecommend, to: "isRecommend")
    ]
    
    init(from decoder: Decoder) throws {
        try decode(from: decoder, with: Self.keyMapping)
        bgColor = UIColor.randomColor.toHexString()
    }
    
    func encode(to encoder: Encoder) throws {
        try encode(to: encoder, with: Self.keyMapping)
    }
    
}
