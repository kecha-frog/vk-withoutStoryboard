//
//  AllGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

/// протокол-делегат функция отправка выбранной группы
protocol AllGroupsListViewControllerDelegate: AnyObject{
    func selectGroup(_ sender: GroupModel)
}

// добавил searchBar
class AllGroupsListViewController: UIViewController {    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewLoad: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchBar:SearchBarHeaderView =  {
        let serchBar = SearchBarHeaderView()
        serchBar.translatesAutoresizingMaskIntoConstraints = false
        return serchBar
    }()
    
    private let service = AllGroupsService()
    weak var delegate: AllGroupsListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllGroups()
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.setDelegate(self)
    }
    
    private func setupUI(){
        title = "All Groups"
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
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
    
    private func update(){
        tableView.reloadData()
    }
    
    private func fetchAllGroups(){
        viewLoad.animationLoad(.on)
        
        service.fetchApiAllGroups { [weak self]  in
            self?.update()
            self?.viewLoad.animationLoad(.off)
        }
    }
}

extension AllGroupsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier) as! GroupTableViewCell
        cell.configure(group: service.data[indexPath.row], selection: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup = service.data[indexPath.row]
        self.service.firebaseSelectGroup(selectGroup)
        delegate?.selectGroup(selectGroup)
        navigationController?.popViewController(animated: true)
    }
}

extension AllGroupsListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else{
            fetchAllGroups()
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self as Any, selector: #selector(fetchSearchApi), object: nil)
        perform(#selector(fetchSearchApi), with: nil, afterDelay: 0.7)
    }
    
    @objc private func fetchSearchApi() {
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }
        viewLoad.animationLoad(.on)
        service.fetchApiAllGroups(searchText: text) { [weak self]  in
            self?.update()
            self?.viewLoad.animationLoad(.off)
        }
    }
}
