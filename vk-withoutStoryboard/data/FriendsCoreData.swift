//
//  UserModelDataCore.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 08.02.2022.
//

import UIKit
import CoreData

class FriendsCoreData{
    init(){
        checkIsEmpty()
    }
    
    private func checkIsEmpty(){
        let check = fetch()
        if check.isEmpty {
            print("Наполнил базу друзьями")
            addFriendDataCore()
        }
    }
    
    func fetch() -> [UserModel]{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let request = UserModel.fetchRequest()
            let result = try context.fetch(request)
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(user)
        update()
    }
    
    private func update(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
