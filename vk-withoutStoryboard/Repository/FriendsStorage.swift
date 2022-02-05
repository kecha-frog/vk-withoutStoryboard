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
            .init(id: 0, name: "Borat", surname: "Sagdiyev",
                  imageUser: [
                    .init(name: "borat-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                  .init(name: "borat-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                  .init(name: "borat-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                  .init(name: "borat-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                  .init(name: "borat-4", like: Int.random(in: 0...50), youLike:Bool.random())
            ],
                  avatar:.init(name: "borat-avatar", like: 0, youLike:Bool.random())),
            .init(id: 1, name: "Ali", surname: "G",
                  imageUser: [
                .init(name: "aliG-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-4", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-5", like: Int.random(in: 0...50), youLike:Bool.random()),
            ],
                  avatar:.init(name: "aliG-avatar", like: 0, youLike:Bool.random())),
            .init(id: 2, name: "Aladdin", surname: "Dictator",
                  imageUser: [
                .init(name: "aladin-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-4", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-5", like: Int.random(in: 0...50), youLike:Bool.random()),
            ],
                  avatar:.init(name: "aladin-avatar", like: 0, youLike:Bool.random())),
            .init(id: 3, name: "Big", surname: "Boss",
                  imageUser: [
                .init(name: "bigBoss-0", like: Int.random(in: 0...50), youLike:Bool.random())
            ],
                  avatar:.init(name: "bigBoss-avatar", like: 0, youLike:Bool.random())),
            .init(id: 4, name: "Bruno", surname: "Gehard",
                  imageUser: [
                .init(name: "bruno-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-4", like: Int.random(in: 0...50), youLike:Bool.random()),
            ],
                  avatar:.init(name: "bruno-avatar", like: 0, youLike:Bool.random())),
            .init(id: 5, name: "Herceg", surname: "Five",
                  imageUser: [
                .init(name: "herceg-0", like: Int.random(in: 0...50), youLike:Bool.random())
            ],
                  avatar:.init(name: "herceg-avatar", like: 0, youLike:Bool.random()))
        ]
    }
}
