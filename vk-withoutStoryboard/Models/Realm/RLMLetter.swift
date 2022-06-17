//
//  LetterModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 20.03.2022.
//

import Foundation
import RealmSwift

/// Модель секции с друзьями для Realm.
@objcMembers
final class RLMLetter: Object {
    dynamic var name: String = ""
    dynamic var items = List<RLMFriend>()

    override class func primaryKey() -> String? {
        return "name"
    }
}
