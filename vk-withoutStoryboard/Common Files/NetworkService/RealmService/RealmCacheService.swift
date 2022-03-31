//
//  RealmCacheService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 15.03.2022.
//

import Foundation
import RealmSwift

final class RealmCacheService{
    enum Errors: Error{
        case noRealmObject(String)
        case noPrimatyKey(String)
        case failedToRead(String)
    }
    
    var realm: Realm
    
    init(deleteRealmIfMigrationNeeded migration : Bool = false){
        do{
            if migration{
                let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
                self.realm = try Realm(configuration: config)
            }else{
                self.realm = try Realm()
            }
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    func printFileUrl(){
        print(realm.configuration.fileURL as Any)
    }
    
    func create<T:ModelApiVK>(object: T){
        do{
            realm.beginWrite()
            realm.add(object, update: .modified)
            try realm.commitWrite()
        }catch{
            debugPrint(error)
        }
        
    }
    
    func create<T:ModelApiVK>(objects: [T]){
        do{
            realm.beginWrite()
            realm.add(objects, update: .modified)
            try realm.commitWrite()
        }catch{
            debugPrint(error)
        }
        
    }
    
    func read<T:ModelApiVK>(_ object:T.Type) -> Results<T>{
        return realm.objects(T.self)
    }
    
    func read<T:ModelApiVK>(_ object:T.Type,
                            key: String,
                            completion: @escaping (Result<T,Error>) -> Void){
        if let result = realm.object(ofType: T.self, forPrimaryKey: key){
            completion(.success(result))
        }else{
            completion(.failure(Errors.failedToRead("Fail to read object")))
        }
    }
}
