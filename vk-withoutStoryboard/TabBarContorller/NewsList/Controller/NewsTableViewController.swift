//
//  NewsListController.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 04.02.2022.
//

import UIKit
class NewsTableViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let coreDate = FriendsCoreData()
    private var friendsStorage = [UserModel]()
    private let postStorage = PostStorage()
    private var postsData: [PostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsStorage = coreDate.fetch()
        postsData = postStorage.posts.filter { postItem in
            friendsStorage.contains { $0.id == postItem.authorId}
        }
        setupUI()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI(){
        self.title = "News"
        
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
}

extension NewsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
        let post = postsData[indexPath.row]
        let author = friendsStorage.first { $0.id == post.authorId}
        cell.configure(author: author!, post: post, index: indexPath.row)
        cell.delegate = self
        return cell
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
