//
//  FriendPhotosService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

/// Сервисный слой для FriendCollectionViewController.
class FriendPhotosService{
    var friend:FriendModel?
    
    private var realmCacheService = RealmService()
    
    /// Все фото друга из бд.
    var data: Results<PhotoModel> {
        self.realmCacheService.read(PhotoModel.self).filter("owner == %@", friend)
    }
    
    /// Идентифицируем друга по id.
    /// - Parameter friendId: Id  друга.
    init(friendId:Int){
        // Поиск друга по id  в бд
        self.realmCacheService.read(FriendModel.self, key: friendId) { result in
            switch result{
            case .success(let friend):
                self.friend = friend
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Запрос из api фото друга.
    /// - Parameter completion: Замыкание.
    ///
    /// Фото сохраняются  в бд.
    func fetchApiAsync(_ completion: @escaping ()-> Void){
        guard let friend = self.friend else { return }
        
        ApiVK.standart.requestItems(PhotoModel.self, method: .GET, path: .getPhotos, params: [
            "owner_id":String(friend.id),
            "album_id": "profile",
            "count":"10",
            "extended":"1"
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
    
    /// Сохранение фото друга в бд.
    /// - Parameter newPhotoFromApi: Список фото друга.
    private func savePhotoInRealm(_ newPhotoFromApi: [PhotoModel]){
        guard let friend = self.friend else { return }
        
        // список фото друга которые он удалил
        let oldValues = Array(realmCacheService.read(PhotoModel.self).filter("owner == %@", friend)).filter { oldPhoto in
            !newPhotoFromApi.contains { $0.id == oldPhoto.id}
        }
        
        if !oldValues.isEmpty{
            realmCacheService.delete(objects: oldValues)
        }
        // Новый список фото друга
        let newValue = newPhotoFromApi.map { photo -> PhotoModel in
            photo.owner = friend
            return photo
        }
        realmCacheService.create(objects: newValue)
    }
}
