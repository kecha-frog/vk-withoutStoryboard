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

class AllGroupsListViewController: UIViewController {
    var dataAllGroups:[GroupModel] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var delegate: AllGroupsListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUI(){
        title = "All Groups"
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func configure(_ dataAllGroups: [GroupModel]){
        self.dataAllGroups = dataAllGroups
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup = dataAllGroups[indexPath.row]
        delegate?.selectGroup(selectGroup)
        navigationController?.popViewController(animated: true)
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
