//
//  File.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 02.03.2022.
//

import Foundation
import KeychainSwift

/// Синглтон cохранение токена и id юзера в Keychain
class Keychain {
    static let standart = Keychain()
    private let keychain = KeychainSwift()
    private init(){}
    
    /// получить
    /// - Parameter key: ключ
    /// - Returns: возращает данные или nil
    func get(_ key: Keys) -> String? {
        return keychain.get(key.rawValue)
    }
    
    /// записать
    /// - Parameters:
    ///   - value: значение
    ///   - key: ключ
    func set(_ value:String, key: Keys){
        keychain.set(value, forKey: key.rawValue)
    }
    
    /// удалить
    /// - Parameter key: ключ
    func delete(_ key: Keys){
        keychain.delete(key.rawValue)
    }
}

// варианты ключей
extension Keychain{
    enum Keys:String{
        case token
        case id
    }
}
