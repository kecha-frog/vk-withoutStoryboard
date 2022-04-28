//
//  OperationsService.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 28.04.2022.
//

import Foundation
import RealmSwift

class AsyncOperation: Operation{
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet{
            willChangeValue(forKey:newValue.keyPath)
            willChangeValue(forKey:state.keyPath)
        }
        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled{
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
     override func cancel() {
        super.cancel()
        state = .finished
    }
}

class FriendRequestOperation: AsyncOperation {
    var data: [FriendModel]?
    
    override func main() {
        ApiVK.standart.requestItems(FriendModel.self, method: .GET, path: .getFriends, params: ["fields":"online,photo_100"]) { [weak self] result in
            switch result {
            case .success(let success):
                self?.data = success.items
                self?.state = .finished
            case .failure(let error):
                print(error)
                self?.cancel()
            }
        }
    }
}


class DataSaveInRealmOperation: Operation {
    override func main() {
        let realmCacheService: RealmService = RealmService()
        
        guard let depencies = dependencies.first as? FriendRequestOperation,
              let data = depencies.data else { return }
        
        // список для обновления данных старых друзей
        var friendsUpdate: [FriendModel] = []
        // список для обнавления существующих секций
        var alphabetUpdate: [(LetterModel, FriendModel)] = []
        // список секций другом которые надо создать
        var newAlphabet: [LetterModel] = []
        
        // список друзей из бд в данный момент
        let oldDBFriends: Results<FriendModel> = realmCacheService.read(FriendModel.self)
        
        // список друзей которых надо удалить из бд
        let deleteFriends:[FriendModel] = oldDBFriends.filter { friend in
            !data.contains { $0.id == friend.id }
        }
        
        // проходим по друзьям из api для распределения по нужным спискам для последующей работы.
        data.forEach { newFriend in
            // Проверям друга из api в списке друзей из бд
            if oldDBFriends.contains(where: { $0.id == newFriend.id}) {
                // если друг есть в бд то добавляем в список для обнавления данных
                friendsUpdate.append(newFriend)
            } else{
                // Если друга нет в бд.
                // Получаем первую буквы фамилии друга для секции
                guard let letterNameFriend: String = newFriend.lastName.first?.lowercased() else { return }
                // Проверка есть ли уже секция с буквой друга
                realmCacheService.read(LetterModel.self, key: letterNameFriend) { result in
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
        realmCacheService.create(objects: friendsUpdate)
        
        realmCacheService.writeTransction {
            // добавляю новых друзей в существующие секции
            alphabetUpdate.forEach { (letter, newfriend) in
                letter.items.append(newfriend)
            }
        }
        
        // добавляю в бд новые секции с друзьями
        realmCacheService.create(objects: newAlphabet)
        
        // удаление друзей
        realmCacheService.delete(objects: deleteFriends)
    }
}
