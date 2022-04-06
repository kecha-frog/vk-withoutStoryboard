//
//  FriendService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

class FriendsService {
    private var realmCacheService = RealmCacheService()
    
    func fetchApiAsync(_ completion: @escaping ()-> Void){
        ApiVK.standart.reguest(FriendModel.self, method: .GET, path: .getFriends, params: ["fields":"online,photo_100"]) { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    self?.saveInRealm(success.items)
                    completion()
                }
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func loadRealmData(_ completion: @escaping (_ result: Results<FriendModel>)-> Void){
        DispatchQueue.main.async { [weak self] in
            guard let self = self  else { return }
            let result = self.realmCacheService.read(FriendModel.self)
            completion(result)
        }
    }
    
    private func saveInRealm(_ objects: [FriendModel]){
        objects.forEach { friend in
            // не придумал как сделать проверку на изменение данных у друга
            self.realmCacheService.read(FriendModel.self, key: friend.id, completion: { result in
                switch result{
                case .success(let friendDelete):
                    self.realmCacheService.delete(object: friendDelete)
                case .failure(let errorDelete):
                    debugPrint(errorDelete)
                }
            })
            
            let letter = friend.lastName.first?.lowercased()
            self.realmCacheService.read(AlphabetModel.self, key: letter) { [weak self] result in
                switch result{
                case .success(let letter):
                    do{
                        self?.realmCacheService.realm.beginWrite()
                        letter.items.append(friend)
                        try self?.realmCacheService.realm.commitWrite()
                    }catch{
                        debugPrint(error)
                    }
                case .failure(let error):
                    do{
                        self?.realmCacheService.realm.beginWrite()
                        var object = self?.realmCacheService.realm.create(AlphabetModel.self, value: [letter], update: .modified)
                        object?.items.append(friend)
                        self?.realmCacheService.realm.add(object!, update: .modified)
                        try self?.realmCacheService.realm.commitWrite()
                    }catch{
                        debugPrint(error)
                    }
                }
            }
        }
    }
}
