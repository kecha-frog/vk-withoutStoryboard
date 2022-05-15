//
//  FavoriteGroupsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

/// Провайдер FavoriteGroupsListViewController.
final class FavoriteGroupsScreenProvider {
    // MARK: - Public Properties
    /// Список групп пользователя из бд.
    var data: Results<GroupModel> {
        if let text: String = searchText {
            // Поиск определенных групп.
            return self.realm.read(GroupModel.self).filter("name contains[cd] %@", text)
        } else {
            return self.realm.read(GroupModel.self)
        }
    }

    // MARK: - Private Properties
    private var realm = RealmLayer()

    /// Текст поиска.
    private var searchText: String?

    // MARK: - Public Methods
    /// Изменение текста поиска.
    /// - Parameter text: текст поиска
    ///
    ///  text - по умолчанию nil.
    func setSearchText(_ text: String? = nil) {
        searchText = text
    }

    /// Удаление группы из бд.
    /// - Parameter group: группы
    func deleteInRealm(_ group: GroupModel) {
        realm.delete(object: group)
    }

    /// Запрос групп пользователя из api.
    /// - Parameter completion: Замыкание.
    ///
    /// Группы сохраняются в бд.
    func fetchApiAsync(_ completion: @escaping () -> Void) {
        ApiVK.standart.requestItems(GroupModel.self,
                                    method: .GET,
                                    path: .getGroups,
                                    params: ["extended": "1"]) { [weak self] result in
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

    // MARK: - Private Methods
    /// Сохраненние  групп в бд.
    /// - Parameter newGroups: обновленный список групп
    private func savePhotoInRealm(_ newGroups: [GroupModel]) {
        // Группы из которых вышел пользователь, но они еще присутсвуют в бд
        let oldValues: [GroupModel] = realm.read(GroupModel.self).filter { oldGroup in
            !newGroups.contains { $0.id == oldGroup.id }
        }

        // Удаление групп из которых вышел пользователь
        if !oldValues.isEmpty {
            realm.delete(objects: oldValues)
        }

        // Добавление новых групп или обновление данных старых групп
        realm.create(objects: newGroups)
    }
}
