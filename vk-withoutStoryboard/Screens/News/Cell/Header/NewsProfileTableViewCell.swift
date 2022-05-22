//
//  NewsProfileTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 18.04.2022.
//

import UIKit

/// Хэдер новости пользователя.
final class NewsProfileTableViewCell: NewsHeaderTableViewCell {
    static var identifier: String = "NewsProfileTableViewCell"

    func configure(_ profile: NewsProfileModel, _ date: Double) {
        avatarView.loadImage(profile.photo100)
        nameLabel.text = profile.firstName + " " + profile.lastName
        convertDate(date)
    }
}
