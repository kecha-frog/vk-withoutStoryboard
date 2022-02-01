//
//  GroupsStorage.swift
//  firstApp
//
//  Created by Ke4a on 22.01.2022.
//

import Foundation

class GroupsStorage {
    let userGroups: [GroupModel]
    let allGroups: [GroupModel]
    
    init(){
        userGroups = [
            GroupModel(name: "Rock music", category: .music),
            GroupModel(name: "Nature", category: .nature),
            GroupModel(name: "Любители Звездных войн", category: .film),
        ]
        
        allGroups = [
            GroupModel(name: "Rock music", category: .music),
            GroupModel(name: "Classic film", category: .film),
            GroupModel(name: "Classic music", category: .film),
            GroupModel(name: "Western", category: .film),
            GroupModel(name: "Punk", category: .film),
            GroupModel(name: "For children film", category: .film),
            GroupModel(name: "40 kg", category: .other),
            GroupModel(name: "Nature", category: .nature),
            GroupModel(name: "Metal", category: .music),
            GroupModel(name: "Story life", category: .nature),
            GroupModel(name: "Любители Звездных войн", category: .film),
            GroupModel(name: "Other films", category: .film)
        ]
    }
}
