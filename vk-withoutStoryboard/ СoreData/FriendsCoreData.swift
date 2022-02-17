//
//  UserModelDataCore.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 08.02.2022.
//

import UIKit
import CoreData

class FriendsCoreData{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    init(){
        checkIsEmpty()
    }
    
    private func checkIsEmpty(){
        let check = fetch()
        if check.isEmpty {
            print("Вы удалили всех друзей, заполнили coreData друзьями")
            addFriendsInCoreData()
        }
    }
    
    func fetch() -> [UserModel]{
        do{
            let request = UserModel.fetchRequest()
            let result = try context.fetch(request)
            // очистка базы данных
//            result.forEach { item in
//                context.delete(item)
//                update()
//            }
            return result
        }catch let error{
            debugPrint(error)
            return []
        }
    }
    
    func delete(_ user: UserModel){
        context.delete(user)
        save()
    }
    
    private func save(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
