//
//  ApiModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 27.02.2022.
//

import Foundation

// для удобвства в будущем
extension Int{
    var boolValue: Bool {
            return self == 1 ? true : false
    }
}

// ответы апи
class FriendModelApi:Decodable{
    let id:Int
    let avatar:String
    let firstName: String
    let lastName: String
    let isClosed:Bool
    let accessClosed:Bool
    let online:Int
    let trackCode: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case online
        case avatar = "photo_100"
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case accessClosed = "can_access_closed"
        case trackCode = "track_code"
    }
    
    required init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try item.decode(Int.self, forKey: .id)
        self.avatar = try item.decode(String.self, forKey: .avatar)
        self.firstName = try item.decode(String.self, forKey: .firstName)
        self.lastName = try item.decode(String.self, forKey: .lastName)
        self.isClosed = try item.decode(Bool.self, forKey: .isClosed)
        self.accessClosed = try item.decode(Bool.self, forKey: .accessClosed)
        self.online = try item.decode(Int.self, forKey: .online)
        self.trackCode = try item.decode(String.self, forKey: .trackCode)
    }
}

class PhotoModelApi: Decodable{
    let albumId: Int
    let date: Date
    let id:Int
    let ownerId: Int
    let sizes: [Size]
    let text: String
    let hasTags : Bool
    
    
    /* в будущем реализую
     "likes": {
     "user_likes": 0,
     "count": 391
     },
     "reposts": {
     "count": 3
     },
     "comments": {
     "count": 40
     },
     "can_comment": 1,
     "tags": {
     "count": 0
     }
     */
    
    private enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case date
        case id
        case ownerId = "owner_id"
        case sizes
        case text
        case hasTags = "has_tags"
    }
    
    required init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        self.albumId = try item.decode(Int.self, forKey: .albumId)
        self.date = try item.decode(Date.self, forKey: .date)
        self.id = try item.decode(Int.self, forKey: .id)
        self.ownerId = try item.decode(Int.self, forKey: .ownerId)
        self.sizes = try item.decode([Size].self, forKey: .sizes)
        self.text = try item.decode(String.self, forKey: .text)
        self.hasTags = try item.decode(Bool.self, forKey: .hasTags)
    }
    
    struct Size: Codable{
        let height: Int
        let url: String
        let type: String
        let width: Int
    }
}

class GroupModelApi: Decodable{
    let id:Int
    let isAdmin: Int
    let isAdvertiser: Int
    let isClosed: Int
    let isMember: Int
    let name: String
    let photo100: String
    let photo200: String
    let photo50: String
    let screenName: String
    let type: String
    
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
    
    
    required init(from decoder: Decoder) throws {
        let item = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try item.decode(Int.self, forKey: .id)
        self.isAdmin = try item.decode(Int.self, forKey: .isAdmin)
        self.isAdvertiser = try item.decode(Int.self, forKey: .isAdvertiser)
        self.isClosed = try item.decode(Int.self, forKey: .isClosed)
        self.isMember = try item.decode(Int.self, forKey: .isMember)
        self.name = try item.decode(String.self, forKey: .name)
        self.photo100 = try item.decode(String.self, forKey: .photo100)
        self.photo200 = try item.decode(String.self, forKey: .photo200)
        self.photo50 =  try item.decode(String.self, forKey: .photo50)
        self.screenName = try item.decode(String.self, forKey: .screenName)
        self.type = try item.decode(String.self, forKey: .type)
    }
}
