//
//  GroupTableViewCell.swift
//  firstApp-withoutStoryboard
//
//  Created by Ke4a on 31.01.2022.
//

import UIKit

/// Ячейка группы.
class GroupTableViewCell: UITableViewCell {
    private let nameLabel:UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageViewCell: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static let identifier = "GroupsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        imageViewCell.image = nil
    }
    
    /// Настройка UI.
    private func setupUI(){
        contentView.addSubview(imageViewCell)
        let topConstraint: NSLayoutConstraint = imageViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
        topConstraint.priority = UILayoutPriority(rawValue: 999)
        let bottomConstraint: NSLayoutConstraint = imageViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
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
    
    /// Конфигурация ячейки.
    /// - Parameter group: Экземпляр группы.
    func configure(group:GroupModel){
        nameLabel.text = group.name
        // Загрузка изображения группы.
        LoaderImage.standart.load(url: group.photo200) { [weak self] image in
            self?.imageViewCell.image = image
        }
    }
}
