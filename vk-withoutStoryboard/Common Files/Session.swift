//
//  Session.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 17.02.2022.
//

import Foundation

// MARK: Создал
class Session{
    static let instance = Session()
    private init(){}
    var userId: Int = Int()
    var token: String = ""
}
