//
//  FetchModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 09.02.2022.
//

import Foundation

// модель для json
struct FetchDataModel: Decodable{
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
