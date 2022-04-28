//
//  FriendService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 01.04.2022.
//

import Foundation
import RealmSwift

/// Сервисный слой для FriendsViewController.
final class FriendsService {
    private var realmCacheService: RealmService = RealmService()
    
    /// Получение из бд секции с друзьями.
    var data: Results<LetterModel>{
        self.realmCacheService.read(LetterModel.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    init(){
        // путь к файлу realm
        realmCacheService.printUrlFile()
    }
    
    // Сделал без парсинга так как он делается в запросе.
    func fillFriendsData(_ loadView: LoadingView) {
        let operationsQueue = OperationQueue()
        
        // Включаем анимацию.
        loadView.animationLoad(.on)
        
        // Запрос друзей
        let friendRequestOperation = FriendRequestOperation()
        // Сохранение друзей в бд
        let dataSaveInRealmOperation = DataSaveInRealmOperation()
        dataSaveInRealmOperation.addDependency(friendRequestOperation)
        operationsQueue.addOperations([friendRequestOperation, dataSaveInRealmOperation], waitUntilFinished: false)
        // Анимация выключается по завершению
        dataSaveInRealmOperation.completionBlock = {
            // Всю работу с UI  делаем в главном потоке
            DispatchQueue.main.async {
                // Выключаем анимацию
                loadView.animationLoad(.off)
            }
        }
    }
    
    func deleteInRealm<T: Object>(objects: [T]){
        self.realmCacheService.delete(objects: objects)
    }
}
