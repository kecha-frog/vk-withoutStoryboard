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
    
    let imageViewCell:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = #colorLiteral(red: 0.2624342442, green: 0.4746298194, blue: 0.7327683568, alpha: 1).cgColor
        
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
        
        
        contentView.addSubview(textLabelCell)
        NSLayoutConstraint.activate([
            textLabelCell.leftAnchor.constraint(equalTo: imageViewCell.rightAnchor, constant: 8),
            textLabelCell.centerYAnchor.constraint(equalTo: imageViewCell.centerYAnchor),
            textLabelCell.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
    
    func configure(friend: FriendModel){
        textLabelCell.text = "\(friend.name) \(friend.surname)"
        imageViewCell.image = UIImage(named: friend.avatar.name)
        self.layoutIfNeeded()
        imageViewCell.layer.cornerRadius = imageViewCell.frame.size.width / 2
    }

}

