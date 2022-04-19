//
//  FavoriteGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit
import RealmSwift

// MARK: Controller
/// Экран групп пользователя.
class FavoriteGroupsListViewController: UIViewController {
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
    
    private let searchBarHeader:SearchBarHeaderView  =  {
        let searchbar: SearchBarHeaderView = SearchBarHeaderView()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    /// Сервисный слой.
    private let service: FavoriteGroupsService = FavoriteGroupsService()
    
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchApiAsync()
        createNotificationToken()
        searchBarHeader.setDelegate(self)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    /// Найстройка UI.
    private func setupUI(){
        self.title = "Groups"
        
        self.view.addSubview(searchBarHeader)
        NSLayoutConstraint.activate([
            searchBarHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBarHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        searchBarHeader.setHeightConstraint(0)
        
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBarHeader.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAddGroup))
        addButton.tintColor = .black
        navigationItem.setRightBarButton(addButton, animated: true)
        
        let searchButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        searchButton.tintColor = .black
        navigationItem.setLeftBarButton(searchButton, animated: true)
    }
    
    /// Action кнопки поиска.
    @objc private func showSearchBar(){
        searchBarHeader.switchSearchBar()
    }
    
    /// Action кнопки добавления группы.
    @objc private func actionAddGroup(){
        let AllGroupsVC: CatalogGroupsListViewController = CatalogGroupsListViewController()
        navigationController?.pushViewController(AllGroupsVC, animated: false)
    }
    
    /// Обновление данных таблицы.
    private func updateTableView(){
        tableView.reloadData()
    }
    
    /// Запрос групп пользователя из api с анимацией.
    private func fetchApiAsync(){
        viewLoad.animationLoad(.on)
        
        service.fetchApiFavoriteGroupsAsync { [weak self] in
            self?.viewLoad.animationLoad(.off)
        }
    }
    /// Регистрирует блок, который будет вызываться при каждом изменении данных групп пользователя в бд.
    private func createNotificationToken(){
        // подписка на изменения бд
        // так же можно подписываться на изменения определеного объекта
        token = service.data.observe{ result in
            switch result{
                // при первом запуске приложения
            case .initial:
                self.updateTableView()
                // при изменение бд
            case .update( _,
                          let deletions,
                          let insertions,
                          let modifications):
                let deletionsIndexPath: [IndexPath] = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath: [IndexPath] = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath: [IndexPath] = modifications.map { IndexPath(row: $0, section: 0) }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self: FavoriteGroupsListViewController = self  else { return }
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                    self.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                    self.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
                    self.tableView.endUpdates()
                }
                // при ошибке
            case .error(let error):
                print(error)
            }
        }
    }
}

// MARK: DataSource
extension FavoriteGroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupTableViewCell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier) as! GroupTableViewCell
        let group = service.data[indexPath.row]
        cell.configure(group: group)
        return cell
    }
}

// MARK: Delegate
extension FavoriteGroupsListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete: UIContextualAction = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    ///  Action удаление группы у ячейки.
    /// - Parameter indexPath: Индекс группы.
    /// - Returns: UIContextualAction для tableView SwipeActionsConfigurationForRowAt.
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action: UIContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            let group: GroupModel = service.data[indexPath.row]
            self.service.deleteInRealm(group)
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}

// MARK: SearchBarDelegate
extension FavoriteGroupsListViewController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Если поиск завершен, то сбрасывается поисковое слово в сервисном слое.
        self.service.setSearchText()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Если текст searchBar пуст, то сбрасывается поисковое слово в сервисном слое.
        if searchText.isEmpty {
            self.service.setSearchText()
            self.updateTableView()
        }else{
            DispatchQueue.main.async { [weak self] in
                guard let self = self  else { return }
                
                // текст поиска передается в сервисный слой
                self.service.setSearchText(searchText)
                self.updateTableView()
            }
        }
    }
}
