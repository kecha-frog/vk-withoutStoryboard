//
//  AllGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

protocol AllGroupsListViewControllerDelegate: AnyObject{
    func selectGroup(_ sender: GroupModel)
}

// добавил searchBar
class AllGroupsListViewController: UIViewController {
    private var dataAllGroups:[GroupModel] = []
    
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
    
    private let searchBar =  SearchBarHeaderTableView()
    private let service = AllGroupsService()
    weak var delegate: AllGroupsListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllGroups()
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func setupUI(){
        title = "All Groups"
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        tableView.tableHeaderView = searchBar
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup = dataAllGroups[indexPath.row]
        delegate?.selectGroup(selectGroup)
        navigationController?.popViewController(animated: true)
    }
    
    private func update(){
        tableView.reloadData()
    }
    
    private func fetchAllGroups(){
        viewLoad.animationLoad(.on)
        
        service.fetchApiAllGroups { [weak self] result in
            self?.dataAllGroups = result
            self?.update()
            self?.viewLoad.animationLoad(.off)
        }
    }
}

extension AllGroupsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataAllGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier) as! GroupTableViewCell
        cell.configure(group: dataAllGroups[indexPath.row], selection: true)
        return cell
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
    
    @objc private func fetchSearchApi(_ sender: Any) {
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }
        viewLoad.animationLoad(.on)
        service.fetchApiAllGroups(searchText: text) { [weak self] result in
            self?.dataAllGroups = result
            self?.update()
            self?.viewLoad.animationLoad(.off)
        }
    }
}
