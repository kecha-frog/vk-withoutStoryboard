//
//  FriendsViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit
import CoreData
import RealmSwift

class FriendsViewController: UIViewController {
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewLoad: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let modelSelf = FriendModel.self
    
    private var realmCacheService = RealmCacheService()
    
    private var storage = [FriendModel]()
    private var firstLetters = [Character]()
    
    private var dataFriends: Results<AlphabetModel>{
        self.realmCacheService.read(AlphabetModel.self)
    }
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        realmCacheService.printFileUrl()
        createNotificationToken()
        fetchApiAsync { [weak self] in
            self?.loadRealmData()
        }
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.register(FriendsHeaderSectionTableView.self, forHeaderFooterViewReuseIdentifier: FriendsHeaderSectionTableView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = dataFriends[indexPath.section].items[indexPath.row]
        
        let friendCollectionVC = FriendCollectionViewController()
        friendCollectionVC.configure(friendId: friend.id)
        navigationController?.pushViewController(friendCollectionVC, animated: true)
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            //let user = self.dataFriends[indexPath.section].remove(at: indexPath.row)
            //self.coreData.delete(user)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            if self.dataFriends[indexPath.section].isEmpty {
//                self.firstLetters.remove(at: indexPath.section)
//                self.dataFriends.remove(at: indexPath.section)
//                let indexSet = IndexSet(arrayLiteral: indexPath.section)
//                tableView.deleteSections(indexSet, with: .fade)
//            }
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }

    private func setupUI(){
        tableView.sectionHeaderTopPadding = 5
        
        title = "Friends"
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func sortedFriends(_ friends: [FriendModel], firstLetters: [Character]) -> [[FriendModel]]{
        var sortedFriends = [[FriendModel]]()
        for letter in firstLetters {
            let filterFriends = friends.filter { $0.lastName.first == letter }
            sortedFriends.append(filterFriends)
        }
        return sortedFriends
    }
    
    private func firstLettersArray(_ friends: [FriendModel]) -> [Character] {
        return Array(Set(friends.compactMap { $0.lastName.first })).sorted()
    }
    
    private func update(){
        tableView.reloadData()
    }
    
    private func viewLoadAnimation(_ hiden: Bool = false){
        if hiden{
            viewLoad.removeSelfAnimation(transitionTo: tableView)
        }else{
            view.addSubview(viewLoad)
            NSLayoutConstraint.activate([
                viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
        }
    }
    
    private func fetchApiAsync( completion: @escaping () -> Void){
        viewLoadAnimation()
        ApiVK.standart.reguest(modelSelf, method: .GET, path: .getFriends, params: ["fields":"online,photo_100"]) { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async { [weak self] in
                    self?.saveInRealm(success.items)
                }
                self?.viewLoadAnimation(true)
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    private func loadRealmData(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self  else { return }
            let result = self.realmCacheService.read(self.modelSelf)
            self.storage = Array(result)
            self.firstLetters = self.firstLettersArray(self.storage)
//            self.dataFriends = self.sortedFriends(self.storage, firstLetters: self.firstLetters)
            self.update()
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
    
    private func createNotificationToken(){
        token = dataFriends.observe{ [weak self] result in
            guard let self = self  else { return }
            switch result{
            case .initial(let groups):
                print(groups.count)
            case .update( _,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
//                let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
//                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
//                let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }
                
                // придумать как обновлять секцию
//                modifications.forEach { modif in
//                    let letter = self.dataFriends[modif]
//                    let isEmpty = letter.items.isEmpty
//                    if isEmpty {
//                        
//                    }
//                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self  else { return }
                    self.update()
                }
            case .error(let error):
                print(error)
            }
        }
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        dataFriends.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FriendsHeaderSectionTableView.identifier) as! FriendsHeaderSectionTableView
        let letter = dataFriends[section].letter
        header.setText(String(letter))
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataFriends[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier) as! FriendsTableViewCell
        cell.configure(friend: dataFriends[indexPath.section].items[indexPath.row])
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var array = firstLetters.map{String($0)}
        array.append("#")
        return array
    }
        
//    func tableView(_ tableView: UITableView,
//                   sectionForSectionIndexTitle title: String,
//                   at index: Int) -> Int {
//        guard title != "#" else {
//            dataFriends = sortedFriends(self.storage, firstLetters: firstLetters)
//            tableView.reloadData()
//            return 0
//        }
//        dataFriends = [sortedFriends(self.storage, firstLetters: firstLetters)[index]]
//        tableView.reloadData()
//        return index
//    }
}
