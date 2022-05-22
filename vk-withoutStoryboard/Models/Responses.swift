//
//  ApiVKModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 27.02.2022.
//

import Foundation

/// Метка для дженерика.
protocol ModelApiMark: Decodable {}

/// Дженерик ответ  сервера.
final class ResponseItem<T: ModelApiMark>: Decodable {
    let response: T

    private enum CodingKeys: String, CodingKey {
        case response
    }
}

struct HeaderNewsPost {
    let profiles: [NewsProfileModel]?
    let groups: [NewsGroupModel]?

    init(_ profiles: [NewsProfileModel]?, _ groups: [NewsGroupModel]? ) {
        self.profiles = profiles
        self.groups = groups
    }
}

/// Дженерик ответ  сервера  api для списка.
final class ResponseList<T: ModelApiMark> {
    let items: [T]

    var headerPost: HeaderNewsPost?

    init(_ items: [T], _ profiles: [NewsProfileModel]? = nil, _ groups: [NewsGroupModel]? = nil) {
        self.items = items

        if profiles == nil, groups == nil {
            headerPost = nil
        } else {
            headerPost = HeaderNewsPost(profiles, groups)
        }
    }
}
