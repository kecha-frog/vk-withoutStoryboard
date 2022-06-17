//
//  FriendPhotosScreenProvider.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

/// Провайдер для FriendCollectionViewController.
final class FriendPhotosScreenProvider: ApiLayer {
    // MARK: - Public Properties
    var fullNameFriend: String {
        guard let firstName = friend?.firstName, let lastName = friend?.lastName else { return "#error_name" }
        return firstName + " " + lastName
    }

    /// Все фото друга из бд.
    var data: Results<RLMPhoto> {
        self.realm.read(RLMPhoto.self).filter("owner == %@", friend ?? "")
    }

    // MARK: - Private Properties
    private var friend: RLMFriend?

    private var realm = RealmLayer()

    // MARK: - Initializers
    /// Идентифицируем друга по id.
    /// - Parameter friendId: Id  друга.
    init(friendId: Int) {
        // Поиск друга по id  в бд
        self.realm.read(RLMFriend.self, key: friendId) { result in
            switch result {
            case .success(let friend):
                self.friend = friend
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Public Methods
    func fetchData(_ loadView: LoadingView) {
        guard let id = self.friend?.id else { return }
        Task(priority: .background) {
            await loadView.animation(.on)
            do {
                let result = try await requestAsync(id: id)
                await savePhotoInRealm(result)
            } catch {
                print(error)
            }
            await loadView.animation(.off)
        }
    }

    // MARK: - Private Methods
    /// Запрос из api фото друга.
    ///
    /// Фото сохраняются  в бд.
    private func requestAsync(id: Int) async throws -> [RLMPhoto] {
        let result = await sendRequestList(endpoint: .getPhotos(userId: id), responseModel: RLMPhoto.self)

        switch result {
        case .success(let response):
            return response.items
        case .failure(let error):
            throw error
        }
    }

    /// Сохранение фото друга в бд.
    /// - Parameter newPhotoFromApi: Список фото друга.
    @MainActor
    private func savePhotoInRealm(_ newPhotoFromApi: [RLMPhoto]) {
        guard let friend = self.friend else { return }

        // список фото друга которые он удалил
        let oldValues = Array(self.realm.read(RLMPhoto.self)
            .filter("owner == %@", friend))
            .filter { oldPhoto in
                !newPhotoFromApi.contains { $0.id == oldPhoto.id }
            }

        if !oldValues.isEmpty {
            self.realm.delete(objects: oldValues)
        }
        // Новый список фото друга
        let newValue = newPhotoFromApi.map { photo -> RLMPhoto in
            photo.owner = friend
            return photo
        }
        self.realm.create(objects: newValue)
    }
}
