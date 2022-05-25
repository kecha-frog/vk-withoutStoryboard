//
//  NewsTableViewController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

/// Экран с новостями.
final class NewsTableViewController: UIViewController {
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

    /// Провайдер.
    private let provider = NewsScreenProvider()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        registerCells()
        fetchNews()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Setting UI
    /// Настройка с UI.
    private func setupUI() {
        title = "News"
        tableView.separatorStyle = .none

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])

        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }

    /// Настройка с RefreshControl.
    private func setupRefreshControl() {
        // Инициализируем и присваиваем сущность UIRefreshControl
        tableView.refreshControl = UIRefreshControl()
        // Настраиваем свойства контрола, как, например,
        // отображаемый им текст
        //tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        // Цвет спиннера
        tableView.refreshControl?.tintColor = .vkColor
        // И прикрепляем функцию, которая будет вызываться контролом
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }

    // MARK: - Action
    @objc func refreshControlAction() {
        // Начинаем обновление новостей
        self.tableView.refreshControl?.beginRefreshing()
        // Определяем время самой свежей новости
        // или берем текущее время
        let dateLastNews = self.provider.data.first?.date ?? Date().timeIntervalSince1970
        // отправляем сетевой запрос загрузки новостей

        provider.refreshData(startTime: dateLastNews) { [weak self] section in
            guard let self = self else { return }
            // выключаем вращающийся индикатор
            self.tableView.refreshControl?.endRefreshing()

            // проверяем, что более свежие новости действительно есть
            guard section > 0 else { return }
            let indexSet = IndexSet(integersIn: 0..<section)
            self.tableView.insertSections(indexSet, with: .automatic)
        }
    }

    // MARK: - Private Methods
    /// /// Запрос новостей из api с анимацией загрузки.
    private func fetchNews() {
        loadingView.animation(.on)
        provider.fetchData {  
            self.loadingView.animation(.off)
            self.tableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource
extension NewsTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        provider.data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        provider.data[section].constructor.count
    }

    /// Регистрация ячеек.
    fileprivate func registerCells(){
        tableView.register(NewsProfileTableViewCell.self, forCellReuseIdentifier: NewsProfileTableViewCell.identifier)
        tableView.register(
            NewsGroupProfileTableViewCell.self,
            forCellReuseIdentifier: NewsGroupProfileTableViewCell.identifier)
        tableView.register(NewsPhotosTableViewCell.self, forCellReuseIdentifier: NewsPhotosTableViewCell.identifier)
        tableView.register(NewsTextTableViewCell.self, forCellReuseIdentifier: NewsTextTableViewCell.identifier)
        tableView.register(NewsFooterTableViewCell.self, forCellReuseIdentifier: NewsFooterTableViewCell.identifier)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConstructor = provider.data[indexPath.section].constructor[indexPath.row]
        // Выбор ячейки изходя из данных новости
        switch cellConstructor {
        case .group(let group):
            let date = provider.data[indexPath.section].date

            guard let cell: NewsGroupProfileTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: NewsGroupProfileTableViewCell.identifier
            ) as? NewsGroupProfileTableViewCell else { return UITableViewCell() }
            cell.configure(group, date)
            return cell
        case .profile(let profile):
            let date = provider.data[indexPath.section].date

            guard let cell: NewsProfileTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: NewsProfileTableViewCell.identifier
            ) as? NewsProfileTableViewCell else { return UITableViewCell() }
            cell.configure(profile, date)
            return cell
        case .photo(let attachments):
            guard let cell: NewsPhotosTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: NewsPhotosTableViewCell.identifier
            ) as? NewsPhotosTableViewCell else { return UITableViewCell() }
            cell.configure(attachments)
            return cell
        case .text(let text):
            guard let cell: NewsTextTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: NewsTextTableViewCell.identifier
            ) as? NewsTextTableViewCell else { return UITableViewCell() }
            cell.configure(text)
            return cell
        case .likeAndView(let likes, let views, let commments):
            guard let cell: NewsFooterTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: NewsFooterTableViewCell.identifier
            ) as? NewsFooterTableViewCell else { return UITableViewCell() }
            cell.configure(likes, views, commments)
            return cell
        default:
            guard let cell: NewsTextTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: NewsTextTableViewCell.identifier
            ) as? NewsTextTableViewCell else { return UITableViewCell() }
            // Приложение на данный момент не поддерживает AUDIO/VIDEO/OTHER FILES в новости.
            cell.configure("###  NOT WORK AUDIO/VIDEO/OTHER FILES ###")
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension NewsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Разделитель новостей
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
}
