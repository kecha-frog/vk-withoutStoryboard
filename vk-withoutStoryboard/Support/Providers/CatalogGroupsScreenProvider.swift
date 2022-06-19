//
//  CatalogGroupsScreenProvider.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
// import Firebase

/// Провайдер для CatalogGroupsListViewController.
final class CatalogGroupsScreenProvider: ApiLayer {
    // MARK: - Public Properties
    /// Cписок всех групп.
    var viewModels: [CatalogViewModel] = []

    // MARK: - Private Properties
    private var searchText: String?

    private let groupFactory = CatalogGroupsViewModelFactory()

    /// Firebase.
    // private let ref: DatabaseReference = Database.database().reference(withPath: "Groups")

    // MARK: - Public Methods
    func setSearchText(_ text: String? = nil) {
        searchText = text
    }

    func fetchData(_ loadView: LoadingView, completion: @MainActor @escaping () -> Void) {
        loadView.animation(.on)
        Task(priority: .background) {
            let response = try await requestAsync()
            self.viewModels = groupFactory.constructViewModels(from: response)
            await completion()
            await loadView.animation(.off)
        }
    }

    // MARK: - Private Methods
    /// Запрос каталога групп из api.
    /// - Parameters:
    ///   - searchText: Поиск группы по названию, по умолчанию nil.
    private func requestAsync() async throws -> [RLMGroup] {
        if let searchText: String = self.searchText {
            let result = await self.sendRequestList(
                endpoint: ApiEndpoint.getSearchGroup(searchText: searchText),
                responseModel: RLMGroup.self)

            // Поиск определенных групп по ключевому слову
            switch result {
            case .success(let response):
                return response.items
            case .failure(let error):
                print(error)
                throw error
            }
        } else {
            let result = await self.sendRequestList(
                endpoint: ApiEndpoint.getCatalogGroups,
                responseModel: RLMGroup.self)

            // Получение каталога групп
            switch result {
            case .success(let response):
                return response.items
            case .failure(let error):
                print(error)
                throw error
            }
        }
    }

    /// Отправка названия выбранной группы пользователя  в firebase.
    /// - Parameter selectGroup: Выбранная группа.
    //    func firebaseSelectGroup(_ selectGroup: GroupModel){
    //        //  Id пользователя
    //        guard let id: String = Keychain.shared.get(.id) else { return }
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
