//
//  AlphabetModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 20.03.2022.
//

import Foundation
import RealmSwift

@objcMembers class AlphabetModel: Object{
    @objc dynamic var letter: String = ""
    dynamic var items = List<FriendModel>()
    
    override class func primaryKey() -> String? {
        return "letter"
    }
}
