//
//  FavoriteGroupsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift
import UIKit

/// Провайдер FavoriteGroupsListViewController.
final class FavoriteGroupsScreenProvider: ApiLayer {
    // MARK: - Public Properties
    var data: [GroupModel] {
        if let text: String = searchText {
            // Поиск определенных групп.
            return self.fetchData.filter {
                $0.name
                    .lowercased()
                    .contains(text)
            }
        } else {
            return self.fetchData
        }
    }

    // MARK: - Private Properties
    /// Список групп пользователя из бд.
    private var fetchData: [GroupModel] = []

    private var realmData: Results<RLMGroup> {
        realm.read(RLMGroup.self)
    }

    private var realm = RealmLayer()

    private var token: NotificationToken?

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

    func fetchData(_ loadView: LoadingView) {
        loadView.animation(.on)
        Task(priority: .background) {
            let groups = try await self.requestAsync()
            await self.saveInRealm(groups)
            await loadView.animation(.off)
        }
    }

    /// Удаление группы из бд.
    /// - Parameter group: группы
    func deleteInRealm(_ group: GroupModel) {
        guard let group = realmData.first(where: { $0.id == group.id }) else { return }
        realm.delete(object: group)
    }

    /// Регистрирует блок, который будет вызываться при каждом изменении данных групп пользователя в бд.
    func createNotificationToken(_ tableView: UITableView) {
        // подписка на изменения бд
        // так же можно подписываться на изменения определеного объекта
        token = realmData.observe { result in
            switch result {
                // при первом запуске приложения
            case .initial(let realmGroup):
                self.fetchData = realmGroup.map { self.getFavoriteGroup($0) }
                tableView.reloadData()
                // при изменение бд
            case .update(let realmGroup,
                         let deletions,
                         let insertions,
                         let modifications):
                let deletionsIndexPath: [IndexPath] = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath: [IndexPath] = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath: [IndexPath] = modifications.map { IndexPath(row: $0, section: 0) }

                self.fetchData = realmGroup.map { self.getFavoriteGroup($0) }
                Task {
                    await tableView.beginUpdates()
                    await tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                    await tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                    await tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
                    await tableView.endUpdates()
                }
                // при ошибке
            case .error(let error):
                print(error)
            }
        }
    }

    // MARK: - Private Methods

    private func getFavoriteGroup(_ rmlModel: RLMGroup) -> GroupModel {
        return GroupModel(
            id: rmlModel.id, type: rmlModel.type,
            name: rmlModel.name, screenName: rmlModel.screenName,
            photo200: rmlModel.photo200, isAdmin: rmlModel.isAdmin,
            isAdvertiser: rmlModel.isAdvertiser, isClosed: rmlModel.isClosed,
            isMember: rmlModel.isMember, photo100: rmlModel.photo100,
            photo50: rmlModel.photo50)
    }

    /// Запрос групп пользователя из api.
    ///
    /// Группы сохраняются в бд.
    private func requestAsync() async throws -> [RLMGroup] {
        let result = await sendRequestList(endpoint: .getGroups, responseModel: RLMGroup.self)

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
    private func saveInRealm(_ newGroups: [RLMGroup]) {
        // Группы из которых вышел пользователь, но они еще присутсвуют в бд
        let oldValues: [RLMGroup] = self.realm.read(RLMGroup.self).filter { oldGroup in
            !newGroups.contains { $0.id == oldGroup.id }
        }

        // Удаление групп из которых вышел пользователь
        if !oldValues.isEmpty {
            self.realm.delete(objects: oldValues)
        }

        print(newGroups)
        // Добавление новых групп или обновление данных старых групп
        self.realm.create(objects: newGroups)
    }
}
