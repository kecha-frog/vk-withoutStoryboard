//
//  FriendsViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import RealmSwift
import UIKit

/// Экран друзей пользователя.
final class FriendsViewController: UIViewController {
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

    private let provider = FriendsListScreenProvider()

    private var token: NotificationToken?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createNotificationToken()
        fetchFriends()
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.register(
            FriendsHeaderSectionTableView.self,
            forHeaderFooterViewReuseIdentifier: FriendsHeaderSectionTableView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Setting UI Method
    private func setupUI() {
        tableView.sectionIndexColor = .vkColor
        tableView.sectionHeaderTopPadding = 5
        tableView.sectionIndexBackgroundColor = .white

        title = "Friends"

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

    /// Запрос друзей у api c  анимацией загрузки.
    private func fetchFriends() {
        provider.fillData(loadingView)
    }

    /// Регистрирует блок, который будет вызываться при каждом изменении секкций в бд.
    private func createNotificationToken() {
        token = provider.data.observe { [weak self] result in
            guard let self: FriendsViewController = self  else { return }
            switch result {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // секции в которой надо обновить список друзей
                var reloadSections: [Int] = []
                // секции которые стали пустые
                var emptySections: [LetterModel] = []

                // сортирую секции на удаление и обновление
                modifications.forEach { section in
                    let letter: LetterModel = self.provider.data[section]
                    if letter.items.isEmpty {
                        emptySections.append(letter)
                    } else {
                        reloadSections.append(section)
                    }
                }

                if !insertions.isEmpty {
                    self.tableView.insertSections(IndexSet(insertions), with: .automatic)
                }

                if !reloadSections.isEmpty {
                    self.tableView.reloadSections(IndexSet(reloadSections), with: .automatic)
                }

                if !deletions.isEmpty {
                    self.tableView.deleteSections(IndexSet(deletions), with: .automatic)
                }

                if !emptySections.isEmpty {
                    // удаляю пустые секции
                    self.provider.deleteInRealm(objects: emptySections)
                }
            case .error(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FriendsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        provider.data.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return provider.data.map { $0.name.uppercased() }
    }

    func tableView(_ tableView: UITableView,
                   sectionForSectionIndexTitle title: String,
                   at index: Int) -> Int {
        tableView.scrollToRow(at: .init(row: 0, section: index), at: .top, animated: true)
        return index
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        provider.data[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendsTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: FriendsTableViewCell.identifier
        ) as! FriendsTableViewCell
        cell.configure(friend: provider.data[indexPath.section].items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: FriendsHeaderSectionTableView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FriendsHeaderSectionTableView.identifier
        ) as! FriendsHeaderSectionTableView
        let letter: String = provider.data[section].name.uppercased()
        header.configure(letter)
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAction(indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete: UIContextualAction = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    // MARK: - Delegate Actions
    /// Action для выбранной ячейки
    /// - Parameter indexPath: индекс выбранной ячейки
    private func didSelectRowAction(_ indexPath: IndexPath) {
        let friend: FriendModel = provider.data[indexPath.section].items[indexPath.row]

        let friendCollectionVC = FriendCollectionViewController()
        friendCollectionVC.configure(friendId: friend.id)
        navigationController?.pushViewController(friendCollectionVC, animated: true)
    }

    ///  Action удаление друга у ячейки.
    /// - Parameter indexPath: Индекс друга.
    /// - Returns: UIContextualAction для tableView SwipeActionsConfigurationForRowAt.
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, _ in
            let friend: FriendModel = provider.data[indexPath.section].items[indexPath.row]
            provider.deleteInRealm(objects: [friend])
            // В будущем добавлю удаление друга в апи.
        }
        action.backgroundColor = #colorLiteral(red: 1, green: 0.3464992942, blue: 0.4803417176, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}
