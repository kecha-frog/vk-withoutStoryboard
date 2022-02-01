//
//  FriendsTableViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    static var identifier = "FriendsTableViewCell"
    
    let textLabelCell:UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let AvatarViewCell:AvatarView = {
        let imageView = AvatarView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return  imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(AvatarViewCell)
        let widthConstraint = AvatarViewCell.widthAnchor.constraint(equalToConstant: 82)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        let heightConstraint = AvatarViewCell.heightAnchor.constraint(equalToConstant: 82)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint,
            AvatarViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            AvatarViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            AvatarViewCell.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            AvatarViewCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.addSubview(textLabelCell)
        NSLayoutConstraint.activate([
            textLabelCell.leftAnchor.constraint(equalTo: AvatarViewCell.rightAnchor, constant: 8),
            textLabelCell.centerYAnchor.constraint(equalTo: AvatarViewCell.centerYAnchor),
            textLabelCell.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
    
    func configure(friend: FriendModel){
        textLabelCell.text = "\(friend.name) \(friend.surname)"
        AvatarViewCell.setImage(friend.avatar.name)
    }
}

