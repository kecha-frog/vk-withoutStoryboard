//
//  CatalogGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

// MARK: Controller
/// Экран каталога групп.
class CatalogGroupsListViewController: UIViewController {    
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
    
    private let searchBar:SearchBarHeaderView =  {
        let searchBar: SearchBarHeaderView = SearchBarHeaderView()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    /// Сервисный слой.
    private let service: CatalogGroupsService = CatalogGroupsService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCatalogGroups()
        searchBar.setDelegate(self)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Настройка UI.
    private func setupUI(){
        title = "Catalog Groups"
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        searchBar.setHeightConstraint(40)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    /// Обновление данных таблицы.
    private func updateTableView(){
        tableView.reloadData()
    }
    
    /// Запрос каталога групп из  api  c анимацией загрузки.
    private func fetchCatalogGroups(){
        viewLoad.animationLoad(.on)
        
        service.fetchApiCatalogGroups { [weak self]  in
            guard let self: CatalogGroupsListViewController = self else { return }
            
            self.updateTableView()
            self.viewLoad.animationLoad(.off)
        }
    }
}

extension CatalogGroupsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup: GroupModel = service.data[indexPath.row]
        //self.service.firebaseSelectGroup(selectGroup)
        navigationController?.popViewController(animated: false)
    }
}

extension CatalogGroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupTableViewCell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier) as! GroupTableViewCell
        cell.configure(group: service.data[indexPath.row])
        return cell
    }
}

extension CatalogGroupsListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Eсли текст поиска пустой, то загружается общий каталог групп.
        guard searchText != "" else{
            fetchCatalogGroups()
            return
        }
        
        // debounce для текста поиска, выполняется когда прекратится ввод данных
        NSObject.cancelPreviousPerformRequests(withTarget: self as Any, selector: #selector(fetchSearchApi), object: nil)
        perform(#selector(fetchSearchApi), with: nil, afterDelay: 0.7)
    }
    
    /// Запрос на поиск группы по названию.
    @objc private func fetchSearchApi() {
        guard let text: String = searchBar.text, !text.isEmpty else{
            return
        }
        
        viewLoad.animationLoad(.on)
        service.fetchApiCatalogGroups(searchText: text) { [weak self]  in
            guard let self = self else { return }
            
            self.updateTableView()
            self.viewLoad.animationLoad(.off)
        }
    }
}
