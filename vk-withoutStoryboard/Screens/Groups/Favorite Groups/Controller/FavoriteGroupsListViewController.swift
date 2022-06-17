//
//  FavoriteGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import RealmSwift
import UIKit

/// Экран групп пользователя.
final class FavoriteGroupsListViewController: UIViewController {
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

    private let searchBarHeader: SearchBarHeaderView  =  {
        let searchbar = SearchBarHeaderView()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()

    /// Провайдер.
    private let provider = FavoriteGroupsScreenProvider()

    private var token: NotificationToken?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchGroups()
        createNotificationToken()
        searchBarHeader.setDelegate(self)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    // MARK: - Setting UI Method
    /// Найстройка UI.
    private func setupUI() {
        self.title = "Groups"

        self.view.addSubview(searchBarHeader)
        NSLayoutConstraint.activate([
            searchBarHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBarHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        searchBarHeader.setHeightConstraint(0)

        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBarHeader.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])

        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        addButton.tintColor = .black
        navigationItem.setRightBarButton(addButton, animated: true)

        let searchButton = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(searchButtonAction))
        searchButton.tintColor = .black
        navigationItem.setLeftBarButton(searchButton, animated: true)
    }

    // MARK: - Actions
    /// Action кнопки поиска.
    @objc private func searchButtonAction() {
        searchBarHeader.switchSearchBar()
    }

    /// Action кнопки добавления группы.
    @objc private func addButtonAction() {
        let allGroupsVC = CatalogGroupsListViewController()
        navigationController?.pushViewController(allGroupsVC, animated: false)
    }

    // MARK: - Private Methods
    /// Обновление данных таблицы.
    private func updateTableView() {
        tableView.reloadData()
    }

    /// Запрос групп пользователя из api с анимацией.
    private func fetchGroups() {
        provider.fetchData(loadingView)
    }
    
    /// Регистрирует блок, который будет вызываться при каждом изменении данных групп пользователя в бд.
    private func createNotificationToken() {
        // подписка на изменения бд
        // так же можно подписываться на изменения определеного объекта
        token = provider.data.observe { result in
            switch result {
                // при первом запуске приложения
            case .initial:
                break
                // при изменение бд
            case .update(_,
                         let deletions,
                         let insertions,
                         let modifications):
                let deletionsIndexPath: [IndexPath] = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath: [IndexPath] = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath: [IndexPath] = modifications.map { IndexPath(row: $0, section: 0) }

                Task {
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

// MARK: - UITableViewDataSource
extension FavoriteGroupsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        provider.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GroupTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: GroupTableViewCell.identifier
        ) as? GroupTableViewCell else { return UITableViewCell() }
        let group = provider.data[indexPath.row]
        cell.configure(group: group)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteGroupsListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete: UIContextualAction = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    // MARK: - Actions
    ///  Action удаление группы у ячейки.
    /// - Parameter indexPath: Индекс группы.
    /// - Returns: UIContextualAction для tableView SwipeActionsConfigurationForRowAt.
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, _ in
            let group: RLMGroup = provider.data[indexPath.row]
            self.provider.deleteInRealm(group)
        }
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}

// MARK: - UISearchBarDelegate
extension FavoriteGroupsListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Если поиск завершен, то сбрасывается поисковое слово в сервисном слое.
        self.provider.setSearchText()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Если текст searchBar пуст, то сбрасывается поисковое слово в сервисном слое.
        if searchText.isEmpty {
            self.provider.setSearchText()
            self.updateTableView()
        } else {
            Task {
                // текст поиска передается в Провайдер
                self.provider.setSearchText(searchText)
                self.updateTableView()
            }
        }
    }
}
