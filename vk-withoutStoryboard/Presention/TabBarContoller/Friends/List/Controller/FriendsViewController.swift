//
//  FriendsViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit
import RealmSwift

// MARK: Controller
class FriendsViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewLoad: LoadingView = {
        let view: LoadingView = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let service: FriendsService = FriendsService()
    
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createNotificationToken()
        fetchFriends()
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.register(FriendsHeaderSectionTableView.self, forHeaderFooterViewReuseIdentifier: FriendsHeaderSectionTableView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI(){
        tableView.sectionIndexColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
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
    
    /// Перезагрузка данных tableView.
    private func updateTableView(){
        tableView.reloadData()
    }
    
    /// Запрос друзей у api c  анимацией загрузки.
    private func fetchFriends(){
        viewLoad.animationLoad(.on)
        service.fetchApiAsync { [weak self] in
            self?.viewLoad.animationLoad(.off)
        }
    }
    
    /// Регистрирует блок, который будет вызываться при каждом изменении секкций в бд.
    private func createNotificationToken(){
        token = service.data.observe{ [weak self] result in
            guard let self: FriendsViewController = self  else { return }
            switch result{
            case .initial:
                self.updateTableView()
            case .update(_, let deletions, let insertions, let modifications):
                // секции в которой надо обновить список друзей
                var reloadSections: [Int] = []
                // секции которые стали пустые
                var emptySections: [LetterModel] = []
                
                // сортирую секции на удаление и обнавление
                modifications.forEach { section in
                    let letter: LetterModel = self.service.data[section]
                    if letter.items.isEmpty{
                        emptySections.append(letter)
                    }else{
                        reloadSections.append(section)
                    }
                }
                
                if !insertions.isEmpty{
                    self.tableView.insertSections(IndexSet(insertions), with: .automatic)
                }
                
                if !reloadSections.isEmpty{
                    self.tableView.reloadSections(IndexSet(reloadSections), with: .automatic)
                }
                
                if !deletions.isEmpty{
                    self.tableView.deleteSections(IndexSet(deletions), with: .automatic)
                }
                
                if !emptySections.isEmpty{
                    // удаляю пустые секции
                    self.service.deleteInRealm(objects: emptySections)
                }
            case .error(let error):
                print(error)
            }
        }
    }
}

// MARK: UITableViewDataSource
extension FriendsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        service.data.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return service.data.map { $0.name.uppercased() }
    }
    
    func tableView(_ tableView: UITableView,
                   sectionForSectionIndexTitle title: String,
                   at index: Int) -> Int {
        tableView.scrollToRow(at: .init(row: 0, section: index), at: .top, animated: true)
        return index
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier) as! FriendsTableViewCell
        cell.configure(friend: service.data[indexPath.section].items[indexPath.row])
        return cell
    }
}


// MARK: UITableViewDelegate
extension FriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: FriendsHeaderSectionTableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FriendsHeaderSectionTableView.identifier) as! FriendsHeaderSectionTableView
        let letter: String = service.data[section].name.uppercased()
        header.setText(letter)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend: FriendModel = service.data[indexPath.section].items[indexPath.row]
        
        let friendCollectionVC: FriendCollectionViewController = FriendCollectionViewController()
        friendCollectionVC.configure(friendId: friend.id)
        navigationController?.pushViewController(friendCollectionVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete: UIContextualAction = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    ///  Action удаление друга
    /// - Parameter indexPath: Индекс друга.
    /// - Returns: UIContextualAction для tableView SwipeActionsConfigurationForRowAt.
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            let friend: FriendModel = service.data[indexPath.section].items[indexPath.row]
            service.deleteInRealm(objects: [friend])
            // В будущем добавлю удаление друга в апи.
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}
