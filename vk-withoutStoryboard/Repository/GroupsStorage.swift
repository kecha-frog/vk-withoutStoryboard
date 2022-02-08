//
//  GroupsStorage.swift
//  firstApp
//
//  Created by Ke4a on 22.01.2022.
//

import Foundation

class GroupsStorage {
    let groupsArray: [AllGroupModel]
    
    init(){
        groupsArray = [
            AllGroupModel(id: 0, name: "Rock music", category: "music"),
            AllGroupModel(id: 1, name: "Classic film", category: "film"),
            AllGroupModel(id: 2, name: "Classic music", category: "film"),
            AllGroupModel(id: 3, name: "Western", category: "film"),
            AllGroupModel(id: 4, name: "Punk", category: "film"),
            AllGroupModel(id: 5, name: "For children film", category: "film"),
            AllGroupModel(id: 6, name: "40 kg", category: "other"),
            AllGroupModel(id: 7, name: "Nature", category: "nature"),
            AllGroupModel(id: 8, name: "Metal", category: "music"),
            AllGroupModel(id: 9, name: "Story life", category: "nature"),
            AllGroupModel(id: 10, name: "Любители Звездных войн", category: "film"),
            AllGroupModel(id: 11, name: "Other films", category: "film")
        ]
    }
}
