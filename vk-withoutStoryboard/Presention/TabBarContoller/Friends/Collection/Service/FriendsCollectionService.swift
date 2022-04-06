//
//  FriendsCollectionService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation

class FriendsCollectionService{
    private var friend:FriendModel?
    private var realmCacheService = RealmCacheService()
    
    init(friend:FriendModel){
        self.friend = friend
    }
    
    func fetchApiAsync(_ completion: @escaping ()-> Void){
        guard let friend = self.friend else { return }
        ApiVK.standart.reguest(PhotoModel.self, method: .GET, path: .getPhotos, params: [
            "owner_id":String(friend.id),
            "album_id": "profile",
            "count":"10",
            "extended":"1"
        ]) { [weak self] result in
            switch result {
            case .success(let success):
                self?.savePhotoInRealm(success.items)
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    private func savePhotoInRealm(_ newObjects: [PhotoModel]){
        guard let friend = self.friend else { return }
        let oldValues = Array(realmCacheService.read(PhotoModel.self).filter("owner == %@", friend)).filter { oldPhoto in
            !newObjects.contains { $0.id == oldPhoto.id}
        }
        
        if !oldValues.isEmpty{
            realmCacheService.delete(objects: oldValues)
        }
        
        let newValue = newObjects.map { photo -> PhotoModel in
            photo.owner = friend
            return photo
        }
        realmCacheService.create(objects: newValue)
    }
}
