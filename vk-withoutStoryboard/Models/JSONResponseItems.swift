//
//  ApiVKModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 27.02.2022.
//

import Foundation

/// Метка для дженерика.
protocol ModelApiVK:Decodable {}

struct HelpersForItems {
    let profiles: [NewsProfileModel]?
    let groups: [NewsGroupModel]?
    init(_ profiles: [NewsProfileModel]?, _ groups: [NewsGroupModel]? ){
        self.profiles = profiles
        self.groups = groups
    }
}

/// Дженерик ответ  сервера.
class JSONResponse<T:ModelApiVK>: Decodable {
    let response: T
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
}

/// Дженерик ответ  сервера  api для списка.
class JSONResponseItems<T:ModelApiVK> {
    let count: Int?
    let items: [T]
    
    var helpers: HelpersForItems?
    
    init(_ items: [T], _ count: Int? = nil, _ profiles: [NewsProfileModel]? = nil, _ groups: [NewsGroupModel]? = nil) {
        self.items = items
        
        if profiles == nil , groups == nil {
            helpers =  nil
        }else {
            helpers = HelpersForItems(profiles, groups)
        }
        
        self.count = count
    }
}
