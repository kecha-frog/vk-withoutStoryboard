//
//  FriendsHeaderSectionTableView.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 03.02.2022.
//

import UIKit

class FriendsHeaderSectionTableView: UITableViewHeaderFooterView{
    
    static let identifier = "FriendsHeaderSectionTableView"
    
    private let label: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.alpha = 0.7
        text.textColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1)
        return text
    }()
    
    func confugure(_ text: String){
        label.text = text
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubview(label) 
        let top = label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2)
        top.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            top,
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
