//
//  ApiModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 27.02.2022.
//

import Foundation
import RealmSwift

// для удобвства в будущем
extension Int{
    var boolValue: Bool {
            return self == 1 ? true : false
    }
}

// для метка для дженерика
protocol ModelApiVK:Object, Decodable{}

class JSONResponse<T:ModelApiVK>: Decodable{
    let count: Int
    let items: [T]
    
    private enum CodingKeys:String, CodingKey{
        case response
    }
    
    private enum ResponseKeys:String, CodingKey{
        case count
        case items
    }
    
    required init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        let test = try response.nestedContainer(keyedBy: ResponseKeys.self,forKey: .response)
        self.count = try test.decode(Int.self, forKey: .count)
        self.items = try test.decode([T].self, forKey: .items)
    }
}

// ответы апи
@objcMembers class FriendModelApi: Object, Decodable, ModelApiVK{
    dynamic var id:Int = 0
    dynamic var avatar:String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var isClosed:Bool = false
    dynamic var accessClosed:Bool = false
    dynamic var online:Int = 0
    dynamic var trackCode: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case online
        case avatar = "photo_100"
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case accessClosed = "can_access_closed"
        case trackCode = "track_code"
    }
}

class Size: Object, Decodable{
    @objc dynamic var height: Int
    @objc dynamic var url: String
    @objc dynamic var type: String
    @objc dynamic var width: Int
}

class PhotoModelApi: Object, Decodable, ModelApiVK{
    @objc dynamic var albumId: Int = 0
    @objc dynamic var date: Date = Date()
    @objc dynamic var id:Int = 0
    @objc dynamic var ownerId: Int = 0
    dynamic var sizes = [Size]()
    @objc dynamic var text: String = ""
    @objc dynamic var hasTags : Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case date
        case id
        case ownerId = "owner_id"
        case sizes
        case text
        case hasTags = "has_tags"
    }
}

class GroupModelApi: Object, Decodable, ModelApiVK {
    @objc dynamic var id:Int = 0
    @objc dynamic var isAdmin: Int = 0
    @objc dynamic var isAdvertiser: Int = 0
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var photo200: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var type: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case id
        case isAdmin = "is_admin"
        case isAdvertiser = "is_advertiser"
        case isClosed = "is_closed"
        case isMember = "is_member"
        case name
        case photo100 = "photo_100"
        case photo200 = "photo_200"
        case photo50 =  "photo_50"
        case screenName = "screen_name"
        case type
    }
}
