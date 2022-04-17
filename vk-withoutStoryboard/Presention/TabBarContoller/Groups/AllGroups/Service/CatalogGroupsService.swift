//
//  CatalogGroupsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
//import Firebase

/// Сервисный слой для CatalogGroupsListViewController.
class CatalogGroupsService{
    /// Cписок всех групп.
    var data:[GroupModel] = []
    
    /// Firebase.
    //private let ref: DatabaseReference = Database.database().reference(withPath: "Groups")
    
    /// Запрос каталога групп из api.
    /// - Parameters:
    ///   - searchText: Поиск группы по названию, по умолчанию nil.
    ///   - completion: Замыкание.  Выполняется даже при ошибке.
    func fetchApiCatalogGroups(searchText: String? = nil, _ completion: @escaping ()-> Void){
        if let searchText: String = searchText {
            // Поиск определенных групп по ключевому слову
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
            // Получение каталога групп
            ApiVK.standart.reguest(GroupModel.self, method: .GET, path: .getCatalogGroups, params: nil) { result in
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
    
    /// Отправка названия выбранной группы пользователя  в firebase.
    /// - Parameter selectGroup: Выбранная группа.
    //    func firebaseSelectGroup(_ selectGroup: GroupModel){
    //        //  Id пользователя
    //        guard let id: String = Keychain.standart.get(.id) else { return }
    //
    //        // Получение данных по id пользователя, отправка id и название группы
    //        ref.child(id).getData { error, snapshot in
    //            var groups: [String : String]? = snapshot.value as? [String:String]
    //            groups?[String(selectGroup.id)] = selectGroup.name
    //            let groupsRef: DatabaseReference = self.ref.child(id)
    //            groupsRef.setValue(groups)
    //        }
    //    }
}
