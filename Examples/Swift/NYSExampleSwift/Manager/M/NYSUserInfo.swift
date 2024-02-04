//
//  NYSUserInfo.swift
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

import ExCodable

struct NYSUserInfo: Equatable {
    
    private(set) var id : Int = 0
    private(set) var isBan : Bool = false
    private(set) var tagArr : [String] = []
    private(set) var alias : String?
    private(set) var roleArr : [String] = []
    private(set) var permissionArr : [String] = []
    private(set) var email : String?
    private(set) var tel : String?
    private(set) var icon : String = ""
    private(set) var nickname : String?
    private(set) var password : String?
    private(set) var trueName : String?
    private(set) var type : Int = 0
    private(set) var username : String?
    
}

extension NYSUserInfo: ExCodable {
    
    static var keyMapping: [KeyMap<Self>] = [
        KeyMap(\.id, to: "id"),
        KeyMap(\.isBan, to: "isBan"),
        KeyMap(\.tagArr, to: "tagArr"),
        KeyMap(\.alias, to: "alias"),
        KeyMap(\.roleArr, to: "roleArr"),
        KeyMap(\.permissionArr, to: "permissionArr"),
        KeyMap(\.email, to: "email"),
        KeyMap(\.tel, to: "tel"),
        KeyMap(\.icon, to: "icon"),
        KeyMap(\.nickname, to: "nickname"),
        KeyMap(\.password, to: "password"),
        KeyMap(\.trueName, to: "trueName"),
        KeyMap(\.type, to: "type"),
        KeyMap(\.username, to: "username"),
    ]
    
    init(from decoder: Decoder) throws {
        try decode(from: decoder, with: Self.keyMapping)
    }
    
    func encode(to encoder: Encoder) throws {
        try encode(to: encoder, with: Self.keyMapping)
    }
    
}
