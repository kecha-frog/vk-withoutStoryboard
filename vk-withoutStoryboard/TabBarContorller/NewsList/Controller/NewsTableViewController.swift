//
//  NewsListController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 04.02.2022.
//

// MARK: задание 2:
// работаю с запросом
import UIKit
class NewsTableViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let coreDate = FriendsCoreData()
    private var friendsStorage = [UserModel]()
    private var postsData: [PostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading()
    
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI(){
        self.title = "News"
        
        friendsStorage = coreDate.fetch()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    private func loading(){
        let viewLoad = LoadingView()
        viewLoad.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(viewLoad)
        NSLayoutConstraint.activate([
            viewLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewLoad.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        fetchDataPosts(viewLoad)
    }
}

extension NewsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
        let post = postsData[indexPath.row]
        update()
        let author = friendsStorage.randomElement()
        cell.configure(author: author!, post: post, index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    private func update(){
        friendsStorage = coreDate.fetch()
    }
}

extension NewsTableViewController: NewsTableViewCellDelegate{
    func actionLikePost(_ like: Bool, indexPost: Int) {
        postsData[indexPost].youLike.toggle()
        if like {
            postsData[indexPost].like += 1
        }else if !like {
            postsData[indexPost].like -= 1
        }
    }
}

extension NewsTableViewController{
    func fetchDataPosts(_ viewLoad: LoadingView){
        let fetch = FetchPost()
        fetch.reguest { array in
            self.postsData = array.map({ item in
                PostModel(item)
            })
            self.tableView.reloadData()
            self.setupUI()
            UIView.transition(from: viewLoad, to: self.tableView, duration: 0.33, options: .transitionCrossDissolve) { _ in
                viewLoad.removeFromSuperview()
            }
            
        }
    }
}
