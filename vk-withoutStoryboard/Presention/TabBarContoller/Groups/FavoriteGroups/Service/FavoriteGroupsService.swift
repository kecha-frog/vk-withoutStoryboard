//
//  FavoriteGroupsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation

class FavoriteGroupsService{
    private var realmCacheService = RealmCacheService()
    
    func fetchApiFavoriteGroupsAsync(_ completion: @escaping () -> Void){
        ApiVK.standart.reguest(GroupModel.self, method: .GET, path: .getGroups, params: ["extended":"1"]) { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    self?.savePhotoInRealm(success.items)
                    
                }
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    private func savePhotoInRealm(_ newObjects: [GroupModel]){
        let oldValues = Array(realmCacheService.read(GroupModel.self)).filter { oldGroup in
            !newObjects.contains { $0.id == oldGroup.id}
        }
        
        if !oldValues.isEmpty{
            realmCacheService.delete(objects: oldValues)
        }
        
        realmCacheService.create(objects: newObjects)
    }
}
