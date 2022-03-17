//
//  AllGroupsListViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

protocol AllGroupsListViewControllerDelegate{
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
    
    private let searchBar =  SearchBarHeaderTableView()
    
    var delegate: AllGroupsListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchApiAsync { [weak self] in
            self?.update()
        }
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup = dataAllGroups[indexPath.row]
        delegate?.selectGroup(selectGroup)
        navigationController?.popViewController(animated: true)
    }
    
    private func update(){
        tableView.reloadData()
    }
    
    private func fetchApiAsync( completion: @escaping () -> Void){
        let viewLoad = LoadingView()
        viewLoad.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        ApiVK.standart.reguest(GroupModel.self, method: .GET, path: .getAllGroups, params: nil) { [weak self] result in
            switch result {
            case .success(let success):
                self?.dataAllGroups = success.items
                viewLoad.removeSelfAnimation(transitionTo: self!.tableView)
                completion()
            case .failure(let error):
                print(error)
            }
           
        }
    }
}

extension AllGroupsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataAllGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier) as! GroupTableViewCell
        cell.configure(group: dataAllGroups[indexPath.row])
        return cell
    }
}


extension AllGroupsListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else{
            fetchApiAsync { [weak self] in
                self?.update()
            }
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self as Any, selector: #selector(fetchSearchApi), object: nil)
        perform(#selector(fetchSearchApi), with: nil, afterDelay: 0.7)
    }
    
    @objc private func fetchSearchApi(_ sender: Any) {
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }
        
        let viewLoad = LoadingView()
        viewLoad.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        ApiVK.standart.reguest(GroupModel.self, method: .GET, path: .searchGroup, params: ["q":text]) { [weak self] result in
            switch result {
            case .success(let success):
                self?.dataAllGroups = success.items
                viewLoad.removeSelfAnimation(transitionTo: self!.tableView)
                self?.update()
            case .failure(let error):
                print(error)
            }
        }
    }
}
