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
    
    private var coreData = FriendsCoreData()
    
    private var storage:[UserModel]!
    private var firstLetters = [Character]()
    private var dataFriends:[[UserModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        setupUI()
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.register(FriendsHeaderSectionTableView.self, forHeaderFooterViewReuseIdentifier: FriendsHeaderSectionTableView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: записал
        let sesion = Session.instance
        sesion.userId = 1
        sesion.token = UUID().uuidString
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = dataFriends[indexPath.section][indexPath.row]
        
        let friendCollectionVC = FriendCollectionViewController()
        friendCollectionVC.configure(friendId: friend.id, title: "\(friend.name!) \(friend.surname!)")
        navigationController?.pushViewController(friendCollectionVC, animated: true)
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            let user = self.dataFriends[indexPath.section].remove(at: indexPath.row)
            self.coreData.delete(user)
            
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
        self.tabBarController?.tabBar.isHidden = false
        tableView.sectionHeaderTopPadding = 5
        
        title = "Friends"
        firstLetters = firstLettersArray(storage)
        dataFriends = sortedFriends(storage, firstLetters: firstLetters)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func sortedFriends(_ friends: [UserModel], firstLetters: [Character]) -> [[UserModel]]{
        var sortedFriends = [[UserModel]]()
        for letter in firstLetters {
            let filterFriends = friends.filter { $0.surname?.first == letter }
            sortedFriends.append(filterFriends)
        }
        return sortedFriends
    }
    
    private func firstLettersArray(_ friends: [UserModel]) -> [Character] {
        return Array(Set(friends.compactMap { $0.surname?.first })).sorted()
    }
    
    private func update(){
        storage = coreData.fetch()
        tableView.reloadData()
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        dataFriends.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FriendsHeaderSectionTableView.identifier) as! FriendsHeaderSectionTableView
        header.setText(String(firstLetters[section]))
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
}
