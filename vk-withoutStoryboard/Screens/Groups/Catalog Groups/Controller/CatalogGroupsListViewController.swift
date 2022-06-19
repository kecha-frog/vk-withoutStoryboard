//
//  CatalogGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

/// Экран каталога групп.
final class CatalogGroupsListViewController: UIViewController {
    // MARK: - Private Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchBar: SearchBarHeaderView =  {
        let searchBar = SearchBarHeaderView()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    /// Провайдер.
    private let provider = CatalogGroupsScreenProvider()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCatalogGroups()
        searchBar.setDelegate(self)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Setting UI Method
    /// Настройка UI.
    private func setupUI() {
        title = "Catalog Groups"
        searchBar.setDelegate(self)

        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        searchBar.setHeightConstraint(40)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Private Methods
    /// Запрос каталога групп из  api  c анимацией загрузки.
    private func fetchCatalogGroups() {
        provider.fetchData(loadingView) {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension CatalogGroupsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let selectGroup: GroupModel = provider.data[indexPath.row]
        // self.service.firebaseSelectGroup(selectGroup)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - UITableViewDataSource
extension CatalogGroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        provider.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GroupTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: GroupTableViewCell.identifier
        ) as? GroupTableViewCell else { return UITableViewCell() }
        cell.configure(group: provider.viewModels[indexPath.row])
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension CatalogGroupsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Eсли текст поиска пустой, то загружается общий каталог групп.
        if searchText.isEmpty {
            provider.setSearchText()
        } else {
            provider.setSearchText(searchText)
        }

        // debounce для текста поиска, выполняется когда прекратится ввод данных
        NSObject.cancelPreviousPerformRequests(
            withTarget: self as Any,
            selector: #selector(searchAction),
            object: nil)
        perform(#selector(searchAction), with: nil, afterDelay: 1)
    }

    // MARK: - Actions
    /// Запрос на поиск группы по названию.
    @objc private func searchAction() {
        fetchCatalogGroups()
    }
}
