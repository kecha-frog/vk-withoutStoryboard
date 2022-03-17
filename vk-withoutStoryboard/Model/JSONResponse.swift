//
//  ApiVKModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 27.02.2022.
//

import Foundation
import RealmSwift

/// метка для дженерика
protocol ModelApiVK:Object, Decodable{}

/// дженерик ответов  Api
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
