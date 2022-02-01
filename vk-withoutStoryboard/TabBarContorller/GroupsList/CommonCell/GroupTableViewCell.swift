//
//  GroupTableViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static let identifier = "GroupsTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUi(){
        contentView.addSubview(imageViewCell)
        let widthConstraint = imageViewCell.widthAnchor.constraint(equalToConstant: 82)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        let heightConstraint = imageViewCell.heightAnchor.constraint(equalToConstant: 82)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint,
            imageViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageViewCell.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            imageViewCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: imageViewCell.rightAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: imageViewCell.centerYAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
    
    func configure(group:GroupModel){
        nameLabel.text = group.name
        imageViewCell.image = UIImage(named: group.imageName)
    }
}
