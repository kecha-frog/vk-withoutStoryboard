//
//  AllGroupsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import Firebase

class AllGroupsService{
    /// список всех групп
    var data:[GroupModel] = []
    
    // firebase
    private let ref = Database.database().reference(withPath: "Groups")
    
    /// запрос всех групп
    /// - Parameters:
    ///   - searchText: поиск определенных групп, по умолчанию nil
    ///   - completion: выполняется в любом случае
    func fetchApiAllGroups(searchText:String? = nil, _ completion: @escaping ()-> Void){
        if let searchText = searchText {
            // поиск определенных групп по ключевому слову
            ApiVK.standart.reguest(GroupModel.self, method: .GET, path: .searchGroup, params: ["q":searchText]) { result in
                switch result {
                case .success(let success):
                    self.data = success.items
                    completion()
                case .failure(let error):
                    debugPrint(error)
                    completion()
                }
            }
        }else{
            // получение всех групп
            ApiVK.standart.reguest(GroupModel.self, method: .GET, path: .getAllGroups, params: nil) { result in
                switch result {
                case .success(let success):
                    self.data = success.items
                    completion()
                case .failure(let error):
                    debugPrint(error)
                    completion()
                }
            }
        }
    }
    
    /// отправка выбранной группы в firebase
    /// - Parameter selectGroup: user select group
    func firebaseSelectGroup(_ selectGroup: GroupModel){
        // id юзера
        guard let id = Keychain.standart.get(.id) else { return }
        
        // получение данных по id юзера, отправка id и название группы 
        ref.child(id).getData { error, snapshot in
            var groups = snapshot.value as? [String:String]
            groups?[String(selectGroup.id)] = selectGroup.name
            let groupsRef = self.ref.child(id)
            groupsRef.setValue(groups)
        }
    }
}
