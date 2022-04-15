//
//  TabBarViewController.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 27.01.2022.
//

import UIKit

/// Main TabBarViewController
class TabBarViewController: UITabBarController {
    private let itemFriends: UIViewController = {
        let image = UIImage(systemName: "person.3.sequence")
        let imageFill = UIImage(systemName: "person.3.fill")
        let tarBarItem = UITabBarItem(title: "Friends", image: image, selectedImage: imageFill)
        
        let viewController = UINavigationController(rootViewController: FriendsViewController())
        viewController.view.backgroundColor = .white
        viewController.tabBarItem = tarBarItem
        return viewController
    }()
    
    private let itemGroups: UIViewController = {
        let image = UIImage(systemName: "crown")
        let imageFill = UIImage(systemName: "crown.fill")
        let tarBarItem = UITabBarItem(title: "Groups", image: image, selectedImage: imageFill)
        
        let viewController = UINavigationController(rootViewController: FavoriteGroupsListViewController())
        viewController.view.backgroundColor = .white
        viewController.tabBarItem = tarBarItem
        return viewController
    }()
    
    private let itemNews: UIViewController = {
        let image = UIImage(systemName: "newspaper")
        let imageFill = UIImage(systemName: "newspaper.fill")
        let tarBarItem = UITabBarItem(title: "News", image: image, selectedImage: imageFill)
        
        let viewController = UINavigationController(rootViewController: NewsTableViewController())
        viewController.view.backgroundColor = .white
        viewController.tabBarItem = tarBarItem
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// Настройка UI.
    private func setupUI(){
        tabBar.tintColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        tabBar.backgroundColor = .white
        viewControllers = [itemFriends, itemNews, itemGroups]
    }
}
