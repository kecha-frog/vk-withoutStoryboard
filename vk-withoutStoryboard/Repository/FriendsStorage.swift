//
//  FriendsStorage.swift
//  firstApp
//
//  Created by Ke4a on 22.01.2022.
//

import Foundation


class FriendsStorage{
    var friends:[FriendModel] = []
    init(){
        friends = [
            .init(name: "Borat", surname: "Sagdiyev",
                  imageUser: [
                  .init(name: "borat-0", like: 0),
                  .init(name: "borat-1", like: 0),
                  .init(name: "borat-2", like: 0),
                  .init(name: "borat-3", like: 0),
                  .init(name: "borat-4", like: 0)
            ],
                  avatar:.init(name: "borat-avatar", like: 0)),
            .init(name: "Ali", surname: "G",
                  imageUser: [
                .init(name: "aliG-0", like: 0),
                .init(name: "aliG-1", like: 0),
                .init(name: "aliG-2", like: 0),
                .init(name: "aliG-3", like: 0),
                .init(name: "aliG-4", like: 0),
                .init(name: "aliG-5", like: 0),
            ],
                  avatar:.init(name: "aliG-avatar", like: 0)),
            .init(name: "Aladdin", surname: "Dictator",
                  imageUser: [
                .init(name: "aladin-0", like: 0),
                .init(name: "aladin-1", like: 0),
                .init(name: "aladin-2", like: 0),
                .init(name: "aladin-3", like: 0),
                .init(name: "aladin-4", like: 0),
                .init(name: "aladin-5", like: 0),
            ],
                  avatar:.init(name: "aladin-avatar", like: 0)),
            .init(name: "Big", surname: "Boss",
                  imageUser: [
                .init(name: "bigBoss-0", like: 0)
            ],
                  avatar:.init(name: "bigBoss-avatar", like: 0)),
            .init(name: "Bruno", surname: "Gehard",
                  imageUser: [
                .init(name: "bruno-0", like: 0),
                .init(name: "bruno-1", like: 0),
                .init(name: "bruno-2", like: 0),
                .init(name: "bruno-3", like: 0),
                .init(name: "bruno-4", like: 0),
            ],
                  avatar:.init(name: "bruno-avatar", like: 0)),
            .init(name: "Herceg", surname: "Five",
                  imageUser: [
                .init(name: "herceg-0", like: 0)
            ],
                  avatar:.init(name: "herceg-avatar", like: 0))
        ]
    }
}
