//
//  FavoriteGroupsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

/// Сервисный слой FavoriteGroupsListViewController.
final class FavoriteGroupsService{
    private var realmCacheService: RealmService = RealmService()
    
    /// Список групп пользователя из бд.
    var data: Results<GroupModel>{
        if let text: String = searchText {
            // Поиск определенных групп.
            return self.realmCacheService.read(GroupModel.self).filter("name contains[cd] %@", text)
        }else{
            return self.realmCacheService.read(GroupModel.self)
        }
    }
    
    /// Текст поиска.
    private var searchText: String?
    
    /// Изменение текста поиска.
    /// - Parameter text: текст поиска
    ///
    ///  text - по умолчанию nil.
    func setSearchText(_ text: String? = nil){
        searchText = text
    }
    
    /// Запрос групп пользователя из api.
    /// - Parameter completion: Замыкание.
    ///
    /// Группы сохраняются в бд.
    func fetchApiFavoriteGroupsAsync(_ completion: @escaping () -> Void){
        ApiVK.standart.reguest(GroupModel.self, method: .GET, path: .getGroups, params: ["extended":"1"]) { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    self?.savePhotoInRealm(success.items)
                    completion()
                }
            case .failure(let error):
                debugPrint(error)
                completion()
            }
        }
    }
    
    /// Сохраненние  групп в бд.
    /// - Parameter newGroups: обновленный список групп
    private func savePhotoInRealm(_ newGroups: [GroupModel]){
        // Группы из которых вышел пользователь, но они еще присутсвуют в бд
        let oldValues: [GroupModel] = realmCacheService.read(GroupModel.self).filter { oldGroup in
            !newGroups.contains { $0.id == oldGroup.id}
        }
        
        // Удаление групп из которых вышел пользователь
        if !oldValues.isEmpty{
            realmCacheService.delete(objects: oldValues)
        }
        
        // Добавление новых групп или обновление данных старых групп
        realmCacheService.create(objects: newGroups)
    }
    
    /// Удаление группы из бд.
    /// - Parameter group: группы
    func deleteInRealm(_ group: GroupModel){
        realmCacheService.delete(object: group)
    }
}
