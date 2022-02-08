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
    func add(_ group: AllGroupModel){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let groupModel = GroupModel(context: context)
        groupModel.setValue(group.id, forKey: "id")
        groupModel.setValue(group.name, forKey: "name")
        groupModel.setValue(group.category, forKey: "category")
        do{
            try context.save()
        }catch let error{
            debugPrint(error)
        }
    }
    
    func fetch() -> [GroupModel]{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let request = GroupModel.fetchRequest()
            request.returnsObjectsAsFaults = true
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
    
    func delete(_ user: GroupModel){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(user)
        update()
    }
    
    private func update(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
