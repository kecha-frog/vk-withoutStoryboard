//
//  GroupsModelCoreData.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 08.02.2022.
//

import Foundation
import UIKit
import CoreData

class FavotiteGroupsCoreData {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func add(_ group: GroupModelApi){
        let groupModel = GroupModel(context: context)
        groupModel.setValue(group.id, forKey: "id")
        groupModel.setValue(group.name, forKey: "name")
        //groupModel.setValue(group.category, forKey: "category")
        do{
            try context.save()
        }catch let error{
            debugPrint(error)
        }
    }
    
    func fetch() -> [GroupModel]{
        do{
            let request = GroupModel.fetchRequest()
            request.returnsObjectsAsFaults = true
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
    
    func delete(_ user: GroupModel){
        context.delete(user)
        save()
    }
    
    private func save(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
