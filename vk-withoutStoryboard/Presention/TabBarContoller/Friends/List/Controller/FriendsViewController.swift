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
    
    private let service = FriendsService()
    private var realmCacheService = RealmCacheService()
    
    private var storage = [FriendModel]()
    private var firstLetters = [String]()
    private var sectionLetter : String?
    private var dataFriends: Results<AlphabetModel>{
        if let section = sectionLetter {
            return self.realmCacheService.read(AlphabetModel.self).filter("letter == %@", section).sorted(byKeyPath: "letter", ascending: true)
        }else{
            return self.realmCacheService.read(AlphabetModel.self).sorted(byKeyPath: "letter", ascending: true)
        }
    }
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        realmCacheService.printFileUrl()
        createNotificationToken()
        fetchFriends()
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
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func firstLettersArray(_ friends: [FriendModel]) -> [String] {
        let array = Array(Set(friends.compactMap { $0.lastName.first })).sorted()
        return array.map{String($0)}
    }
    
    private func update(){
        tableView.reloadData()
    }
    
    private func fetchFriends(){
        viewLoad.animationLoad(.on)
        service.fetchApiAsync { [weak self] in
            self?.loadRealmData()
            self?.viewLoad.animationLoad(.off)
        }
    }
    
    private func loadRealmData(){
        service.loadRealmData { result in
            self.storage = Array(result)
            self.firstLetters = self.firstLettersArray(self.storage)
            self.update()
        }
    }
    
    private func createNotificationToken(){
        token = dataFriends.observe{ [weak self] result in
            guard let self = self  else { return }
            switch result{
            case .initial(let groups):
                break
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
                debugPrint(error)
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
        
    func tableView(_ tableView: UITableView,
                   sectionForSectionIndexTitle title: String,
                   at index: Int) -> Int {
        guard title != "#" else {
            sectionLetter = nil
            update()
            return 0
        }
        sectionLetter = firstLetters[index].lowercased()
        update()
        return index
    }
}
