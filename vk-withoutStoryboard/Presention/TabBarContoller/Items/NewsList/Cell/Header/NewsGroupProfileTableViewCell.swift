//
//  NewsGroupProfileTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

/// Хэдер новости группы.
class NewsGroupProfileTableViewCell: NewsHeaderTableViewCell {
    static var identifier: String = "NewsGroupTableViewCell"

    func configure(_ profile: NewsGroupModel, _ date: Date){
        avatar.loadData(profile.photo100)
        nameLabel.text = profile.name
        dateLabel.text = date.formatted(date: .numeric, time: .standard)
    }
}
