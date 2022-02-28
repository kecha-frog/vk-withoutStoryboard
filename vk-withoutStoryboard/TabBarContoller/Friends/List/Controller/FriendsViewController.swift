//
//  FriendsViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit
import CoreData

class FriendsViewController: UIViewController {
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //private var coreData = FriendsCoreData()
    private let API = fetchApiVK()
    private var storage = [FriendModelApi]()
    private var firstLetters = [Character]()
    private var dataFriends:[[FriendModelApi]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchApiAsync {
            self.update()
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
        let friend = dataFriends[indexPath.section][indexPath.row]
        
        let friendCollectionVC = FriendCollectionViewController()
        friendCollectionVC.configure(friendId: friend.id, title: "\(friend.firstName) \(friend.lastName)")
        navigationController?.pushViewController(friendCollectionVC, animated: true)
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            let user = self.dataFriends[indexPath.section].remove(at: indexPath.row)
            //self.coreData.delete(user)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if self.dataFriends[indexPath.section].isEmpty {
                self.firstLetters.remove(at: indexPath.section)
                self.dataFriends.remove(at: indexPath.section)
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                tableView.deleteSections(indexSet, with: .fade)
            }
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
    
    private func sortedFriends(_ friends: [FriendModelApi], firstLetters: [Character]) -> [[FriendModelApi]]{
        var sortedFriends = [[FriendModelApi]]()
        for letter in firstLetters {
            let filterFriends = friends.filter { $0.lastName.first == letter }
            sortedFriends.append(filterFriends)
        }
        return sortedFriends
    }
    
    private func firstLettersArray(_ friends: [FriendModelApi]) -> [Character] {
        return Array(Set(friends.compactMap { $0.lastName.first })).sorted()
    }
    
    private func update(){
        //storage = coreData.fetch()
        tableView.reloadData()
    }
    
    private func fetchApiAsync( completion: @escaping () -> Void){
        let viewLoad = LoadingView()
        viewLoad.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        API.reguest(FriendModelApi.self, method: .GET, path: .getFriends, params: ["fields":"online,photo_50"]) { [weak self] data in
            self?.storage = data.response.items
            self?.firstLetters = self?.firstLettersArray(data.response.items) ?? []
            self?.dataFriends = self?.sortedFriends(data.response.items, firstLetters: self!.firstLetters) ?? []
            UIView.transition(from: viewLoad, to: self!.tableView, duration: 0.33, options: .transitionCrossDissolve) { _ in
                viewLoad.removeFromSuperview()
            }
            completion()
        }
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        dataFriends.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FriendsHeaderSectionTableView.identifier) as! FriendsHeaderSectionTableView
        let letter = dataFriends[section][0].lastName.first
        header.setText(String(letter!))
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataFriends[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier) as! FriendsTableViewCell
        cell.configure(friend: dataFriends[indexPath.section][indexPath.row])
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
            dataFriends = sortedFriends(self.storage, firstLetters: firstLetters)
            tableView.reloadData()
            return 0
        }
        dataFriends = [sortedFriends(self.storage, firstLetters: firstLetters)[index]]
        tableView.reloadData()
        return index
    }
}
