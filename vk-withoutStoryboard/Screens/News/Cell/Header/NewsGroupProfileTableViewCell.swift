//
//  NewsGroupProfileTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

/// Хэдер новости группы.
final class NewsGroupProfileTableViewCell: NewsHeaderTableViewCell {
    static var identifier: String = "NewsGroupTableViewCell"

    func configure(_ profile: NewsGroupModel, _ date: Double) {
        avatarView.loadImage(profile.photo100)
        nameLabel.text = profile.name
        convertDate(date)
    }
}
