//
//  FavoriteGroupsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

/// Провайдер FavoriteGroupsListViewController.
final class FavoriteGroupsScreenProvider: ApiLayer {
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

    func fetchData(_ loadView: LoadingView) {
        loadView.animation(.on)
        Task(priority: .background) {
            let groups = try await self.requestAsync()
            await self.savePhotoInRealm(groups)
            await loadView.animation(.off)
        }
    }

    // MARK: - Private Methods
    /// Запрос групп пользователя из api.
    ///
    /// Группы сохраняются в бд.
    private func requestAsync() async throws -> [GroupModel] {
        let result = await sendRequestList(endpoint: .getGroups, responseModel: GroupModel.self)

        switch result {
        case .success(let response):
            return response.items
        case .failure(let error):
            print(error)
            throw error
        }
    }

    /// Сохраненние  групп в бд.
    /// - Parameter newGroups: обновленный список групп
    @MainActor
    private func savePhotoInRealm(_ newGroups: [GroupModel]) {
        // Группы из которых вышел пользователь, но они еще присутсвуют в бд
        let oldValues: [GroupModel] = self.realm.read(GroupModel.self).filter { oldGroup in
            !newGroups.contains { $0.id == oldGroup.id }
        }

        // Удаление групп из которых вышел пользователь
        if !oldValues.isEmpty {
            self.realm.delete(objects: oldValues)
        }

        // Добавление новых групп или обновление данных старых групп
        self.realm.create(objects: newGroups)
    }
}
