//
//  GroupTableViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageViewCell: UIImageView = {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageViewCell.image = nil
    }
    
    private func setupUi(){
        contentView.addSubview(imageViewCell)
        let topConstraint = imageViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint = imageViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            imageViewCell.widthAnchor.constraint(equalToConstant: 82),
            imageViewCell.heightAnchor.constraint(equalToConstant: 82),
            topConstraint,
            bottomConstraint,
            imageViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageViewCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: imageViewCell.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: imageViewCell.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(group:AllGroupModel){
        nameLabel.text = group.name
        imageViewCell.image = UIImage(named: group.category)
    }
}
