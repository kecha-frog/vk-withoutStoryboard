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
    
    /// Запрос списка друзей из api.
    /// - Parameter completion: Замыкание. Выполняется даже при ошибке запроса.
    ///
    /// Друзья сохраняются  в бд.
    func fetchApiAsync(_ completion: @escaping ()-> Void){
        ApiVK.standart.reguest(FriendModel.self, method: .GET, path: .getFriends, params: ["fields":"online,photo_100"]) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    guard let self: FriendsService = self else { return }
                    self.saveInRealm(success.items)
                    completion()
                }
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    /// Удаление друзей из базы данных.
    /// - Parameter objects: список друзей.
    func deleteInRealm<T:Object>(objects:[T]){
        self.realmCacheService.delete(objects: objects)
    }

    /// Сохранение друзей в бд.
    /// - Parameter friendsFromApi: Список друзей.
    ///
    /// Написал сложную логику сохранение друзей, чтоб уменьшить траназцикцию записи.
    /// (на 1500 объектов было 45 сек, стало 4 сек)
    private func saveInRealm(_ friendsFromApi: [FriendModel]){
        // список для обновления данных старых друзей
        var friendsUpdate: [FriendModel] = []
        // список для обнавления существующих секций
        var alphabetUpdate: [(LetterModel, FriendModel)] = []
        // список секций другом которые надо создать
        var newAlphabet: [LetterModel] = []
        
        // список друзей из бд в данный момент
        let oldDBFriends: Results<FriendModel> = self.realmCacheService.read(FriendModel.self)
        
        // список друзей которых надо удалить из бд
        let deleteFriends:[FriendModel] = oldDBFriends.filter { friend in
            !friendsFromApi.contains { $0.id == friend.id }
        }
        
        // проходим по друзьям из api для распределения по нужным спискам для последующей работы.
        friendsFromApi.forEach { newFriend in
            // Проверям друга из api в списке друзей из бд
            if oldDBFriends.contains(where: { $0.id == newFriend.id}) {
                // если друг есть в бд то добавляем в список для обнавления данных
                friendsUpdate.append(newFriend)
            } else{
                // Если друга нет в бд.
                // Получаем первую буквы фамилии друга для секции
                guard let letterNameFriend: String = newFriend.lastName.first?.lowercased() else { return }
                // Проверка есть ли уже секция с буквой друга
                self.realmCacheService.read(LetterModel.self, key: letterNameFriend) { result in
                    switch result{
                    case .success(let letter):
                        //добавляю друга в список для обновления списка друзей существующих секций
                        alphabetUpdate.append((letter, newFriend))
                    case .failure:
                        // проверяю есть ли секция в массиве не сохраненных данных бд
                        if let indexSection: Int = newAlphabet.firstIndex(where: { $0.name == letterNameFriend }){
                            // если есть то добавляю друга в секциию
                            newAlphabet[indexSection].items.append(newFriend)
                        }else{
                            // создаю секцию
                            let letter: LetterModel = LetterModel()
                            letter.name = letterNameFriend
                            // добавляю друга в секцию
                            letter.items.append(newFriend)
                            // добавляю секцию в список которые надо создать
                            newAlphabet.append(letter)
                        }
                        
                    }
                }
            }
        }
        
        // обновляем данные старых друзей
        self.realmCacheService.create(objects: friendsUpdate)
        
        self.realmCacheService.writeTransction {
            // добавляю новых друзей в существующие секции
            alphabetUpdate.forEach { (letter, newfriend) in
                letter.items.append(newfriend)
            }
        }
        
        // добавляю в бд новые секции с друзьями
        self.realmCacheService.create(objects: newAlphabet)
        
        // удаление друзей
        self.deleteInRealm(objects: deleteFriends)
    }
}
