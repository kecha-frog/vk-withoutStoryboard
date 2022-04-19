//
//  FriendsTableViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 30.01.2022.
//

import UIKit

/// Ячейка таблицы FriendsViewController.
class FriendsTableViewCell: UITableViewCell {
    private let label: UILabel = {
        let text: UILabel = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let avatarView: AvatarView = {
        let imageView: AvatarView = AvatarView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static var identifier: String = "FriendsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        avatarView.prepareForReuse()
    }
    
    /// Настройка Ui.
    private func setupUI(){
        contentView.addSubview(avatarView)
        let topConstraint: NSLayoutConstraint = avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint: NSLayoutConstraint = avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 82),
            avatarView.heightAnchor.constraint(equalToConstant: 82),
            topConstraint,
            bottomConstraint,
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    /// Конфигурация ячейки.
    /// - Parameter friend: Друг.
    func configure(friend: FriendModel){
        label.text = "\(friend.firstName) \(friend.lastName)"
        avatarView.loadData(friend.avatar)
    }
}
