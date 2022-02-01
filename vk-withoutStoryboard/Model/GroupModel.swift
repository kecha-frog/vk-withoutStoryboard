//
//  GroupModel.swift
//  firstApp
//
//  Created by Ke4a on 22.01.2022.
//

import Foundation

struct GroupModel{
    let name:String
    let category: CategoryGroup
    var imageName:String {
        get {category.rawValue}
    }
    
    enum CategoryGroup:String{
        case music
        case film
        case nature
        case other
    }
}
