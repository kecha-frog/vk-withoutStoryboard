//
//  SearchBarHeaderTableView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 04.02.2022.
//

import UIKit


class SearchBarHeaderTableView: UIView{
    private let button:UIButton = {
        let image = UIImage(systemName: "magnifyingglass")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(searchBarFunc), for: .touchUpInside)
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar =  UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Введите название группы"
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        searchBar.searchTextField.leftView = nil
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var delegate:UISearchBarDelegate?{
        get {
            self.searchBar.delegate
        }
        set(delegate){
            self.searchBar.delegate = delegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        addButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButton(){
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            button.widthAnchor.constraint(equalToConstant: frame.height)
        ])
    }
    
    private func addSearchBar() {
        addSubview(searchBar)
        let leadingAnchorSearchBar = searchBar.leadingAnchor.constraint(equalTo: button.trailingAnchor)
        leadingAnchorSearchBar.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            searchBar.heightAnchor.constraint(equalTo: button.heightAnchor),
            leadingAnchorSearchBar,
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // появление поиска
    @objc private func searchBarFunc(){
        if subviews.contains(searchBar) {
            searchBar.removeFromSuperview()
            button.backgroundColor = .lightGray
        }else{
            addSearchBar()
            button.backgroundColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        }
    }
}
