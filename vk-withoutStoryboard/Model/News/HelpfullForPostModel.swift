//
//  HelpfullForPostModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 19.04.2022.
//

import Foundation
// MARK: Привести в порядок.
class Comments: Decodable {
    let canPost: Int
    let count: Int

    enum CodingKeys: String, CodingKey {
        case canPost = "can_post"
        case count
    }
}

class Donut: Decodable {
    let isDonut: Bool

    enum CodingKeys: String, CodingKey {
        case isDonut = "is_donut"
    }
}

class Likes: Decodable {
    let canLike: Int
    let count: Int
    let userLikes: Int
    let canPublish: Int

    enum CodingKeys: String, CodingKey {
        case canLike = "can_like"
        case count
        case userLikes = "user_likes"
        case canPublish = "can_publish"
    }
}

class PostSource: Decodable {
    let platform: String?
    let type: String

    enum CodingKeys: String, CodingKey {
        case platform
        case type
    }
}

class Reposts: Decodable {
    let count: Int
    let userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }

}

class Views: Decodable {
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}
