//
//  NewsFooterTableViewCell.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 19.04.2022.
//

import UIKit

final class NewsFooterTableViewCell: UITableViewCell {
    // MARK: - Private Properties
    private let likeControl: LikeControl = {
        let like = LikeControl()
        like.translatesAutoresizingMaskIntoConstraints = false
        return like
    }()

    private let viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        return label
    }()

    // MARK: - Static Properties
    static var identifier: String = "NewsFooterTableViewCell"

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setting UI Method
    /// Настройка UI.
    private func setupUI() {
        selectionStyle = .none

        let constant: CGFloat = 20
        contentView.addSubview(likeControl)
        NSLayoutConstraint.activate([
            likeControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constant),
            likeControl.heightAnchor.constraint(equalToConstant: constant),
            likeControl.widthAnchor.constraint(equalToConstant: constant)
        ])

        #warning("Доделать  комменты и просмотры") 
        // Временная реализация
        contentView.addSubview(viewCountLabel)
        NSLayoutConstraint.activate([
            viewCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constant)
        ])

        let imageViews = UIImageView()
        imageViews.image = UIImage(systemName: "eye")
        imageViews.tintColor = .lightGray
        imageViews.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageViews)
        NSLayoutConstraint.activate([
            imageViews.centerYAnchor.constraint(equalTo: viewCountLabel.centerYAnchor),
            imageViews.leadingAnchor.constraint(equalTo: viewCountLabel.trailingAnchor, constant: 4),
            imageViews.heightAnchor.constraint(equalToConstant: 14),
            imageViews.widthAnchor.constraint(equalToConstant: 14)
        ])

        contentView.addSubview(commentLabel)
        NSLayoutConstraint.activate([
            commentLabel.centerYAnchor.constraint(equalTo: viewCountLabel.centerYAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: imageViews.trailingAnchor, constant: 4)
        ])

        let imageMessage = UIImageView()
        imageMessage.image = UIImage(systemName: "message")
        imageMessage.tintColor = .lightGray
        imageMessage.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageMessage)
        NSLayoutConstraint.activate([
            imageMessage.centerYAnchor.constraint(equalTo: commentLabel.centerYAnchor),
            imageMessage.leadingAnchor.constraint(equalTo: commentLabel.trailingAnchor, constant: 4),
            imageMessage.heightAnchor.constraint(equalTo: imageViews.heightAnchor),
            imageMessage.widthAnchor.constraint(equalTo: imageViews.widthAnchor)
        ])
    }

    // MARK: - Public Methods
    func configure(_ likes: Likes, _ views: Views?, _ comments: Comments) {
        likeControl.configure(likes.count, youLike: likes.userLikes)
        viewCountLabel.text = String(views?.count ?? 0)
        commentLabel.text = String(comments.count)
    }
}
