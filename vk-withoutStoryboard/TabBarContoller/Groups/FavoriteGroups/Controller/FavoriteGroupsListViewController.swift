//
//  FavoriteGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit

class FavoriteGroupsListViewController: UIViewController {
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchBar =  SearchBarHeaderTableView()
    
    private let coreData = FavotiteGroupsCoreData()
    
    private var dataFavoriteGroup: [GroupModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        self.setupUI()
        fetchApi()
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func setupUI(){
        self.title = "Groups"
        
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAddGroup))
        addButton.tintColor = .black
        navigationItem.setRightBarButton(addButton, animated: true)
        
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        button.tintColor = .black
        navigationItem.setLeftBarButton(button, animated: true)
    }
    
    private func update(){
        dataFavoriteGroup = coreData.fetch()
        tableView.reloadData()
    }
    
    @objc private func showSearchBar(){
        if tableView.tableHeaderView != nil {
            searchBar.animation(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.tableView.tableHeaderView = nil
                self.navigationItem.leftBarButtonItem!.tintColor = .black
            }
        } else{
            navigationItem.leftBarButtonItem!.tintColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
            tableView.tableHeaderView = searchBar
            searchBar.animation(true)
        }
        
    }
    
    private var AllGroupsVC : AllGroupsListViewController? = nil
    
    @objc private func actionAddGroup(){
        AllGroupsVC = AllGroupsListViewController()
        AllGroupsVC?.delegate = self
        AllGroupsVC!.configure(dataFavoriteGroup)
        navigationController?.pushViewController(AllGroupsVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let group = self.dataFavoriteGroup.remove(at: indexPath.row)
            self.coreData.delete(group)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
    
    // запрос групп юзера
    private func fetchApi(){
        let api = fetchApiVK()
        api.reguest(method: .GET, path: .getGroups, params: ["extended":"1"]) { data in
            print(data)
        }
    }
}

extension FavoriteGroupsListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataFavoriteGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier) as! GroupTableViewCell
        let group = dataFavoriteGroup[indexPath.row]
        cell.configure(group: AllGroupModel(id: Int(group.id) ,name: group.name!, category: group.category!))
        cell.selectionStyle = .none
        return cell
    }
}

extension FavoriteGroupsListViewController:AllGroupsListViewControllerDelegate{
    func selectGroup(_ sender: AllGroupModel) {
        coreData.add(sender)
        update()
    }
}

extension FavoriteGroupsListViewController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        update()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // нашел только такой способ задержки
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchSearchApi), object: nil)
        self.perform(#selector(self.fetchSearchApi), with: nil, afterDelay: 1)
        
        dataFavoriteGroup = coreData.fetch()
        if searchText != "" {
            dataFavoriteGroup = dataFavoriteGroup.filter {
                $0.name!.lowercased().contains(searchText.lowercased())}
        }
        tableView.reloadData()
    }
    
    @objc private func fetchSearchApi(_ sender: Any) {
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }
        let api = fetchApiVK()
        api.reguest(method: .GET, path: .searchGroup, params: ["q":text, "count":"10"]) { data in
            print(data)
        }
    }
}
