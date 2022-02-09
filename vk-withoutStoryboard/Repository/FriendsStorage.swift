//
//  FriendsStorage.swift
//  firstApp
//
//  Created by Ke4a on 22.01.2022.
//

import Foundation
import UIKit
import CoreData

class FriendStorageImage{
    let imagesDict:[ImageModel]!
    init(_ userId: Int16){
        switch userId{
        case 0:
            imagesDict = [
                .init(name: "borat-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "borat-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "borat-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "borat-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "borat-4", like: Int.random(in: 0...50), youLike:Bool.random())
            ]
        case 1:
            imagesDict = [
                .init(name: "aliG-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-4", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aliG-5", like: Int.random(in: 0...50), youLike:Bool.random()),
            ]
        case 2:
            imagesDict = [
                .init(name: "aladin-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-4", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "aladin-5", like: Int.random(in: 0...50), youLike:Bool.random()),
            ]
        case 3:
            imagesDict = [
                .init(name: "bigBoss-0", like: Int.random(in: 0...50), youLike:Bool.random())
            ]
        case 4:
            imagesDict = [
                .init(name: "bruno-0", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-1", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-2", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-3", like: Int.random(in: 0...50), youLike:Bool.random()),
                .init(name: "bruno-4", like: Int.random(in: 0...50), youLike:Bool.random()),
            ]
        case 5:
            imagesDict = [
                .init(name: "herceg-0", like: Int.random(in: 0...50), youLike:Bool.random())
            ]
        default:
            imagesDict = []
        }
    }
}

// Если база пустая заполняю её
func addFriendsInCoreData(){
    let friends:[FriendModel] = [
        .init(id: 0, name: "Borat", surname: "Sagdiyev",
              avatarName: "borat-avatar"),
        .init(id: 1, name: "Ali", surname: "G",
              avatarName: "aliG-avatar"),
        .init(id: 2, name: "Aladdin", surname: "Dictator",
             avatarName: "aladin-avatar"),
        .init(id: 3, name: "Big", surname: "Boss",
              avatarName: "bigBoss-avatar"),
        .init(id: 4, name: "Bruno", surname: "Gehard",
              avatarName: "bruno-avatar"),
        .init(id: 5, name: "Herceg", surname: "Five",
              avatarName: "herceg-avatar")
    ]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    for friend in friends{
        let user = UserModel(context: context)
        user.setValue(friend.id, forKey: "id")
        user.setValue(friend.name, forKey: "name")
        user.setValue(friend.surname, forKey: "surname")
        user.setValue(friend.avatarName, forKey: "avatarName")
    }
    
    do{
        try context.save()
    }catch let error{
        debugPrint(error)
    }
}
