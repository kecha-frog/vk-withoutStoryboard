//
//  ApiVKModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 27.02.2022.
//

import Foundation
import RealmSwift

/// Метка для дженерика.
protocol ModelApiVK:Decodable{}

/// Дженерик ответ сервера  api.
class JSONResponse<T:ModelApiVK>: Decodable{
    let count: Int?
    let items: [T]
    var profiles: [NewsProfileModel]?
    var groups: [NewsGroupModel]?
    
    private enum CodingKeys:String, CodingKey{
        case response
    }
    
    private enum ResponseKeys:String, CodingKey{
        case count
        case items
        case profiles
        case groups
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: ResponseKeys.self,forKey: .response)
        
        self.items = try response.decode([T].self, forKey: .items)
        
        // Проверка является ли ответ новостью
        if self.items is [PostModel]{
            self.count = nil
            // Если являеятся то получаем вспомогательные значения
            self.profiles = try response.decode([NewsProfileModel].self, forKey: .profiles)
            self.groups = try response.decode([NewsGroupModel].self, forKey: .groups)
        }else{
            self.count = try response.decode(Int.self, forKey: .count)
            
            self.profiles = nil
            self.groups = nil
        }
    }
}
