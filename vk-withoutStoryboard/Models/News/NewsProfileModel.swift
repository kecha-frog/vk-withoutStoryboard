//
//  NewsProfileModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import Foundation
#warning("Расписать комментарии.")
struct NewsProfileModel: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let canAccessClosed: Bool?
    let isClosed: Bool?
    let sex: Int
    let screenName: String?
    let photo50: String
    let photo100: String
    let onlineInfo: OnlineInfo
    let online: Int
    let onlineMobile: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case onlineInfo = "online_info"
        case online
        case onlineMobile = "online_mobile"
    }
}

struct OnlineInfo: Codable {
    let visible: Bool
    let lastSeen: Date?
    let isOnline: Bool
    let isMobile: Bool

    enum CodingKeys: String, CodingKey {
        case visible = "visible"
        case lastSeen = "last_seen"
        case isOnline = "is_online"
        case isMobile = "is_mobile"
    }
}
