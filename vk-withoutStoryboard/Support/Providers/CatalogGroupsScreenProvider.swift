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
    var data: [GroupModel] = []

    // MARK: - Private Properties
    private var searchText: String?

    /// Firebase.
    // private let ref: DatabaseReference = Database.database().reference(withPath: "Groups")

    // MARK: - Public Methods
    func setSearchText(_ text: String? = nil) {
        searchText = text
    }

    func fetchData(_ loadView: LoadingView, completion: @escaping () -> Void) {
        loadView.animation(.on)
        Task(priority: .background) {
            guard let response = await requestAsync() else { return }
            self.data = response
            DispatchQueue.main.async {
                completion()
                loadView.animation(.off)
            }
        }
    }

    // MARK: - Private Methods
    /// Запрос каталога групп из api.
    /// - Parameters:
    ///   - searchText: Поиск группы по названию, по умолчанию nil.
    private func requestAsync() async -> [GroupModel]? {
        if let searchText: String = self.searchText {
            let result = await self.sendRequestList(
                endpoint: ApiEndpoint.getSearchGroup(searchText: searchText),
                responseModel: GroupModel.self)

            // Поиск определенных групп по ключевому слову
            switch result {
            case .success(let response):
                return response.items
            case .failure(let error):
                print(error)
                return nil
            }
        } else {
            let result = await self.sendRequestList(
                endpoint: ApiEndpoint.getCatalogGroups,
                responseModel: GroupModel.self)

            // Получение каталога групп
            switch result {
            case .success(let response):
                return response.items
            case .failure(let error):
                print(error)
                return nil
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