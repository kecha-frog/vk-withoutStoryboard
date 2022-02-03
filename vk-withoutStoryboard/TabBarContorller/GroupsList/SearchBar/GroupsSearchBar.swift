//
//  GroupsSearchBar.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 03.02.2022.
//

import UIKit

class GroupsSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 40))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = .brown
        placeholder = "Введите название группы"
        searchTextField.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        showsCancelButton = true
    }
    
    override func image(for icon: UISearchBar.Icon, state: UIControl.State) -> UIImage? {
        return UIImage(named: "vkLogo")
    }
}
