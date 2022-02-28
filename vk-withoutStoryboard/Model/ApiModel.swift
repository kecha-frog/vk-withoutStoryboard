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
struct FriendModelApi:Codable{
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
}

struct PhotoModelApi: Codable{
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
    
    struct Size: Codable{
        let height: Int
        let url: String
        let type: String
        let width: Int
    }
}

struct GroupModelApi: Codable{
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
}
