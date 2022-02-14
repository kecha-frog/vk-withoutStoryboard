//
//  PostModel.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 05.02.2022.
//

import Foundation

// модель для создания из полученнного запроса API
struct PostModel{
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    init(_ fetchDataModel: FetchDataModel){
        userId = fetchDataModel.userId
        id = fetchDataModel.id
        title = fetchDataModel.title
        body = fetchDataModel.body
    }
    
    var like = Int.random(in: 0...100)
    var youLike = Bool.random()
    var watch = Int.random(in: 0...10000)
}
