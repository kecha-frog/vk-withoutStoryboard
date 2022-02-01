//
//  FavoriteGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit

class FavoriteGroupsListViewController: UIViewController {
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    var dataFavoriteGroup: [GroupModel] = []
    let storage = GroupsStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupUI(){
        dataFavoriteGroup = storage.userGroups
        self.title = "Groups"
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAddGroup))
        navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    //для делегата
    var AllGroupsVC : AllGroupsListViewController? = nil
    
    @objc func actionAddGroup(){
        //фильтрую повторов не было
        let dataFavoriteGroups = dataFavoriteGroup.map { $0.name }
        let dataAllGroups = storage.allGroups.filter { group in
            !dataFavoriteGroups.contains {$0 == group.name}
        }
        
        AllGroupsVC = AllGroupsListViewController()
        AllGroupsVC?.delegate = self
        AllGroupsVC!.configure(dataAllGroups)
        navigationController?.pushViewController(AllGroupsVC!, animated: true)
    }
    
    // Удаление группы
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.dataFavoriteGroup.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
    
}

extension FavoriteGroupsListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataFavoriteGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier) as! GroupTableViewCell
        cell.configure(group: dataFavoriteGroup[indexPath.row])
        return cell
    }
}

extension FavoriteGroupsListViewController:AllGroupsListViewControllerDelegate{
    func selectGroup(_ sender: GroupModel) {
        dataFavoriteGroup.append(sender)
        tableView.reloadData()
    }
}
