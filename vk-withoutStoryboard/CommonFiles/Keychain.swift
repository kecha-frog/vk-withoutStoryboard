//
//  Keychain.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 02.03.2022.
//

import Foundation
import KeychainSwift

extension Keychain{
    /// Варианты ключей.
    enum Keys:String{
        case token
        case id
    }
}

/// Singleton cохранение токена и id пользователя в Keychain.
class Keychain {
    /// Singleton
    static let standart: Keychain = Keychain()
    private let keychain: KeychainSwift = KeychainSwift()
    private init(){}
    
    /// Получить данные по ключу.
    /// - Parameter key: Ключ.
    /// - Returns: Возращает данные или nil.
    func get(_ key: Keys) -> String? {
        return keychain.get(key.rawValue)
    }
    
    /// записать данные по ключу.
    /// - Parameters:
    ///   - value: Значение которое нужно записать.
    ///   - key: Ключ.
    func set(_ value:String, key: Keys){
        keychain.set(value, forKey: key.rawValue)
    }
    
    /// Удалить данные по ключу.
    /// - Parameter key: Ключ.
    func delete(_ key: Keys){
        keychain.delete(key.rawValue)
    }
}
