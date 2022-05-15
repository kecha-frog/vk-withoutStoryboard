//
//  NewsGroupModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import Foundation
// TODO: Расписать комментарии.
struct NewsGroupModel: Decodable {
    let id: Int
    let name: String
    let screenName: String?
    let isClosed: Int?
    let type: String
    let photo50: String
    let photo100: String
    let photo200: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type = "type"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
