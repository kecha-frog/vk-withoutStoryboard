//
//  FriendPhotosScreenProvider.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

/// Провайдер для FriendCollectionViewController.
final class FriendPhotosScreenProvider {
    // MARK: - Public Properties
    var fullNameFriend: String {
        guard let firstName = friend?.firstName, let lastName = friend?.lastName else { return "#error_name" }
                return firstName + " " + lastName
    }

    /// Все фото друга из бд.
    var data: Results<PhotoModel> {
        self.realm.read(PhotoModel.self).filter("owner == %@", friend ?? "")
    }

    // MARK: - Private Properties
    private var friend: FriendModel?

    private var realm = RealmLayer()

    // MARK: - Initializers
    /// Идентифицируем друга по id.
    /// - Parameter friendId: Id  друга.
    init(friendId: Int) {
        // Поиск друга по id  в бд
        self.realm.read(FriendModel.self, key: friendId) { result in
            switch result {
            case .success(let friend):
                self.friend = friend
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Public Methods
    /// Запрос из api фото друга.
    /// - Parameter completion: Замыкание.
    ///
    /// Фото сохраняются  в бд.
    func fetchApiAsync(_ completion: @escaping () -> Void) {
        guard let friend = self.friend else { return }

        ApiVK.standart.requestItems(PhotoModel.self, method: .GET, path: .getPhotos, params: [
            "owner_id": String(friend.id),
            "album_id": "profile",
            "count": "10",
            "extended": "1"
        ]) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let success):
                self.savePhotoInRealm(success.items)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Private Methods
    /// Сохранение фото друга в бд.
    /// - Parameter newPhotoFromApi: Список фото друга.
    private func savePhotoInRealm(_ newPhotoFromApi: [PhotoModel]) {
        guard let friend = self.friend else { return }

        // список фото друга которые он удалил
        let oldValues = Array(realm.read(PhotoModel.self)
            .filter("owner == %@", friend))
            .filter { oldPhoto in
                !newPhotoFromApi.contains { $0.id == oldPhoto.id }
            }

        if !oldValues.isEmpty {
            realm.delete(objects: oldValues)
        }
        // Новый список фото друга
        let newValue = newPhotoFromApi.map { photo -> PhotoModel in
            photo.owner = friend
            return photo
        }
        realm.create(objects: newValue)
    }
}
