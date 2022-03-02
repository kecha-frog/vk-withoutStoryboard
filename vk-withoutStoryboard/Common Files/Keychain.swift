//
//  File.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 02.03.2022.
//

import Foundation
import KeychainSwift

extension Keychain{
    enum Keys:String{
        case token
        case id
    }
}

class Keychain {
    static let standart = Keychain()
    private let keychain = KeychainSwift()
    
    private init(){}
    
    func get(_ key: Keys) -> String? {
        return keychain.get(key.rawValue)
    }
    
    func set(_ value:String, key: Keys){
        keychain.set(value, forKey: key.rawValue)
    }
    
    func delete(_ key: Keys){
        keychain.delete(key.rawValue)
    }
}
