//
//  FriendsViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit

// MARK: 1
class FriendsViewController: UIViewController {
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let storage = FriendsStorage()
    // массив для хедера
    private var firstLetters = [Character]()
    private var dataFriends:[[FriendModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        // регистрирую хедер
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
        friendCollectionVC.configure(title: friend.title, dataImages: friend.imageUser )
        navigationController?.pushViewController(friendCollectionVC, animated: true)
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.dataFriends[indexPath.section].remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            if self.dataFriends[indexPath.section].isEmpty {
                self.firstLetters.remove(at: indexPath.section)
                self.dataFriends.remove(at: indexPath.section)
                self.tableView.reloadData()
            }
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }

    private func setupUI(){
        // убрал пустоту
        tableView.sectionHeaderTopPadding = 5
        
        title = "Friends"
        let friendsStorage = storage.friends
        firstLetters = firstLettersArray(friendsStorage)
        dataFriends = sortedFriends(friendsStorage, firstLetters: firstLetters)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // получаем массив массивов с друзьями по буквам
    private func sortedFriends(_ friends: [FriendModel], firstLetters: [Character]) -> [[FriendModel]]{
        var sortedFriends = [[FriendModel]]()
        for letter in firstLetters {
            let filterFriends = friends.filter { $0.surname.first == letter }
            sortedFriends.append(filterFriends)
        }
        return sortedFriends
    }
    
    // массив с первыми буквами
    private func firstLettersArray(_ friends: [FriendModel]) -> [Character] {
        return Array(Set(friends.compactMap { $0.surname.first })).sorted()
    }
    
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    // количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        dataFriends.count
    }
    
    // хедер
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
