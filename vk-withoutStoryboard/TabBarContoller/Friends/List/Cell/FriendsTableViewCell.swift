//
//  FriendsTableViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    static var identifier = "FriendsTableViewCell"
    
    private let textLabelCell:UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let AvatarViewCell:AvatarView = {
        let imageView = AvatarView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return  imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabelCell.text = nil
    }
    
    private func setupUI(){
        contentView.addSubview(AvatarViewCell)
        let topConstraint = AvatarViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint = AvatarViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            AvatarViewCell.widthAnchor.constraint(equalToConstant: 82),
            AvatarViewCell.heightAnchor.constraint(equalToConstant: 82),
            topConstraint,
            bottomConstraint,
            AvatarViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            AvatarViewCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.addSubview(textLabelCell)
        NSLayoutConstraint.activate([
            textLabelCell.leadingAnchor.constraint(equalTo: AvatarViewCell.trailingAnchor, constant: 8),
            textLabelCell.centerYAnchor.constraint(equalTo: AvatarViewCell.centerYAnchor),
            textLabelCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(friend: FriendModelApi){
        textLabelCell.text = "\(friend.firstName) \(friend.lastName)"
        AvatarViewCell.loadData(friend.avatar)
    }
}

