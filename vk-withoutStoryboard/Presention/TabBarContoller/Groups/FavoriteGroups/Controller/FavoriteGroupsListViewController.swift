//
//  FavoriteGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit
import RealmSwift

/// группы юзера
class FavoriteGroupsListViewController: UIViewController {
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewLoad: LoadingView?
    
    private let modelSelf = GroupModel.self
    
    private let searchBar =  SearchBarHeaderTableView()
    private let service = FavoriteGroupsService()
    private var realmCacheService = RealmCacheService()
    private var token: NotificationToken?
    private var searchText: String?
    
    private var dataFavoriteGroup: Results<GroupModel>{
        if let text = searchText {
            return self.realmCacheService.read(modelSelf).filter("name contains[cd] %@", text)
        }else{
            return self.realmCacheService.read(modelSelf)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        fetchApiAsync()
        createNotificationToken()
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
    
    @objc private func actionAddGroup(){
        let AllGroupsVC = AllGroupsListViewController()
        AllGroupsVC.delegate = self
        navigationController?.pushViewController(AllGroupsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //let group = self.dataFavoriteGroup.remove(at: indexPath.row)
            //self.coreData.delete(group)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
    
    private func viewLoadAnimation(_ hiden: Bool = false){
        if hiden{
            viewLoad?.removeSelfAnimation(transitionTo: tableView)
        }else{
            viewLoad = {
                let view = LoadingView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            view.addSubview(viewLoad!)
            NSLayoutConstraint.activate([
                viewLoad!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                viewLoad!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                viewLoad!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                viewLoad!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
        }
    }
    
    private func fetchApiAsync(){
        viewLoadAnimation()
        
        service.fetchApiFavoriteGroupsAsync { [weak self] in
            self?.viewLoadAnimation(true)
        }
    }

    
    private func createNotificationToken(){
        token = dataFavoriteGroup.observe{ [weak self] result in
            guard let self = self  else { return }
            switch result{
            case .initial(let groups):
                break
            case .update( _,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self  else { return }
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                    self.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                    self.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
                    self.tableView.endUpdates()
                }
            case .error(let error):
                debugPrint(error)
            }
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
        cell.configure(group: group)
        return cell
    }
}

extension FavoriteGroupsListViewController:AllGroupsListViewControllerDelegate{
    func selectGroup(_ sender: GroupModel) {
        //coreData.add(sender)
        update()
    }
}

extension FavoriteGroupsListViewController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchText = nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            DispatchQueue.main.async { [weak self] in
                guard let self = self  else { return }
                self.searchText = searchText
                self.update()
            }
        }else{
            self.searchText = nil
            self.update()
        }
    }
}
